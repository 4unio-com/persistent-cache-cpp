project(persistent-cache-cpp C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

cmake_minimum_required(VERSION 2.8.11)

set(LIBNAME persistent-cache-cpp)

string(TOLOWER "${CMAKE_BUILD_TYPE}" cmake_build_type_lower) # Build types should always be lower case

set(ACCEPTED_BUILD_TYPES "" none release debug relwithdebinfo coverage)
list(FIND ACCEPTED_BUILD_TYPES "${cmake_build_type_lower}" IS_BUILD_TYPE_ACCEPTED)
if(${IS_BUILD_TYPE_ACCEPTED} EQUAL -1)
    message(FATAL_ERROR "Invalid CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}\nValid types are: ${ACCEPTED_BUILD_TYPES}")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11 -Wall -pedantic -Wextra")

# Some additional warnings not included by the general flags set above.
set(EXTRA_C_WARNINGS "-Wcast-align -Wcast-qual -Wformat -Wredundant-decls -Wswitch-default")
set(EXTRA_CXX_WARNINGS "-Wnon-virtual-dtor -Wctor-dtor-privacy -Wold-style-cast")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${EXTRA_C_WARNINGS} ${EXTRA_CXX_WARNINGS}")

# By default, for release builds, warnings become hard errors.
if ("${cmake_build_type_lower}" STREQUAL "release" OR "${cmake_build_type_lower}" STREQUAL "relwithdebinfo")
    option(Werror "Treat warnings as errors" ON)
else()
    option(Werror "Treat warnings as errors" OFF)
endif()

# If warnings are errors, don't error on deprecated declarations.
if (${Werror})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
    if ("${cmake_build_type_lower}" STREQUAL "release" OR "${cmake_build_type_lower}" STREQUAL "relwithdebinfo")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=deprecated-declarations")
    endif()
endif()

# Flags for thread/address sanitizer
set(SANITIZER "" CACHE STRING "Build with -fsanitize=<value> (legal values: thread, address)")

if ("${SANITIZER}" STREQUAL "")
    # Do nothing
elseif (${SANITIZER} STREQUAL "thread")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=thread -fno-omit-frame-pointer -g")
elseif (${SANITIZER} STREQUAL "address")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address -fno-omit-frame-pointer -g")
else()
    message(FATAL_ERROR "Invalid SANITIZER setting: ${SANITIZER}")
endif()

# Some tests are slow, so make it possible not to run them
# during day-to-day development.
option(slowtests "Run slow tests" ON)

# Definitions for testing with valgrind.

configure_file(CTestCustom.cmake.in CTestCustom.cmake) # Tests in CTestCustom.cmake are skipped for valgrind

find_program(MEMORYCHECK_COMMAND NAMES valgrind)
if (MEMORYCHECK_COMMAND)
    set(MEMORYCHECK_COMMAND_OPTIONS
        "--suppressions=${CMAKE_SOURCE_DIR}/valgrind-suppress --errors-for-leak-kinds=definite --show-leak-kinds=definite --leak-check=full --num-callers=50 --error-exitcode=3"
    )
    add_custom_target(valgrind DEPENDS NightlyMemCheck)
else()
    message(WARNING "Cannot find valgrind: valgrind target will not be available")
endif()

include(CTest)
enable_testing()

include(EnableCoverageReport)

find_package(Boost COMPONENTS filesystem REQUIRED)
find_package(Threads REQUIRED)

include_directories(include)

add_subdirectory(src)
add_subdirectory(tests)

enable_coverage_report(
    TARGETS
        ${LIBNAME}
        ${UNIT_TEST_TARGETS}
    FILTER
        ${CMAKE_SOURCE_DIR}/tests/*
        ${CMAKE_BINARY_DIR}/*
    TESTS
        ${UNIT_TEST_TARGETS}
)

include(UseDoxygen OPTIONAL)

file(GLOB public_headers ${CMAKE_SOURCE_DIR}/include/core/*.h)
add_doxygen(
    ${LIBNAME}-doc
    INPUT
        ${public_headers}
    OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/doc
    STRIP_FROM_PATH
        "${CMAKE_SOURCE_DIR}/src"
    STRIP_FROM_INC_PATH
        "${CMAKE_SOURCE_DIR}/include"
    EXCLUDE_PATTERNS
        */internal/*
    EXCLUDE_SYMBOLS
        *::internal*
        *::Priv
    EXAMPLE_PATH
        "${CMAKE_SOURCE_DIR}/include"  # TODO: HACK to avoid warning. See bug 1476487
    ALL
)

# TODO: Below is the way doc can be generated without using add_doxygen() from cmake-extras.
#       This avoids re-building the doc even though nothing is out of date.
#       See bug 1476488.

#find_package(Doxygen)
#find_program(DOT_EXECUTABLE dot /usr/bin)
#if (NOT DOXYGEN_FOUND OR NOT DOT_EXECUTABLE)
#    message(WARNING "Cannot generate documentation: doxygen and/or graphviz not found")
#else()
#    configure_file(${PROJECT_SOURCE_DIR}/doc/Doxyfile.in ${PROJECT_BINARY_DIR}/doc/Doxyfile @ONLY IMMEDIATE)
#    add_custom_command(OUTPUT ${PROJECT_BINARY_DIR}/doc/lib${LIBNAME}/index.html
#                       COMMAND ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/doc/Doxyfile
#                       DEPENDS ${PROJECT_BINARY_DIR}/doc/Doxyfile
#                               ${PROJECT_SOURCE_DIR}/include/core/*.h)
#    add_custom_target(doc ALL
#                       DEPENDS ${PROJECT_BINARY_DIR}/doc/lib${LIBNAME}/index.html)
#    install(DIRECTORY ${PROJECT_BINARY_DIR}/doc/lib${LIBNAME}
#            DESTINATION ${CMAKE_INSTALL_PREFIX}/share/doc)
#endif()
