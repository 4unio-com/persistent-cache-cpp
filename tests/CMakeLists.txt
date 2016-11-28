add_subdirectory(copyright)
add_subdirectory(core)
add_subdirectory(headers)
add_subdirectory(whitespace)

# Tests in subdirectories set this. We push it up to the parent so we can
# exclude the unit tests from coverage.
set(UNIT_TEST_TARGETS ${UNIT_TEST_TARGETS} PARENT_SCOPE)
