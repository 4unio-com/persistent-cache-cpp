add_executable(persistent_string_cache_impl_test persistent_string_cache_impl_test.cpp)
target_link_libraries(persistent_string_cache_impl_test ${TESTLIBS})
add_definitions(-DTEST_DIR="${CMAKE_CURRENT_BINARY_DIR}")

add_test(persistent_string_cache_impl persistent_string_cache_impl_test)
set(TARGETS ${TARGETS} persistent_string_cache_impl_test)

set(UNIT_TEST_TARGETS ${UNIT_TEST_TARGETS} ${TARGETS} PARENT_SCOPE)
