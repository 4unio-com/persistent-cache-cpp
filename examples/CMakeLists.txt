set (install_dir ${CMAKE_INSTALL_PREFIX}/share/doc/${LIBNAME}/examples)

add_executable(string_cache string_cache.cpp)
target_link_libraries(string_cache ${LIBNAME})

if ("${cmake_build_type_lower}" STREQUAL "coverage")
    SET_PROPERTY(TARGET string_cache APPEND_STRING PROPERTY LINK_FLAGS "-g --coverage ")
endif()

install(FILES string_cache.cpp
        DESTINATION ${install_dir})

add_executable(person_cache person_cache.cpp)
target_link_libraries(person_cache ${LIBNAME})

if ("${cmake_build_type_lower}" STREQUAL "coverage")
    SET_PROPERTY(TARGET person_cache APPEND_STRING PROPERTY LINK_FLAGS "-g --coverage ")
endif()

install(FILES person_cache.cpp
        DESTINATION ${install_dir})

install(FILES README
        DESTINATION ${install_dir})
