# CMake generated Testfile for 
# Source directory: /home/michi/src/persistent-cache-cpp/trunk/tests/headers
# Build directory: /home/michi/src/persistent-cache-cpp/trunk/build/tests/headers
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(stand-alone-core-headers "/home/michi/src/persistent-cache-cpp/trunk/tests/headers/compile_headers.py" "/home/michi/src/persistent-cache-cpp/trunk/include/core" "/usr/lib/ccache/c++" " -fPIC -fsyntax-only -I/home/michi/src/persistent-cache-cpp/trunk/include -I/home/michi/src/persistent-cache-cpp/trunk/include/core   --std=c++11 -Wall -pedantic -Wextra -Wcast-align -Wcast-qual -Wformat -Wredundant-decls -Wswitch-default -Wnon-virtual-dtor -Wctor-dtor-privacy -Wold-style-cast ")
add_test(stand-alone-core-internal-headers "/home/michi/src/persistent-cache-cpp/trunk/tests/headers/compile_headers.py" "/home/michi/src/persistent-cache-cpp/trunk/include/core/internal" "/usr/lib/ccache/c++" " -fPIC -fsyntax-only -I/home/michi/src/persistent-cache-cpp/trunk/include -I/home/michi/src/persistent-cache-cpp/trunk/include/core/internal   --std=c++11 -Wall -pedantic -Wextra -Wcast-align -Wcast-qual -Wformat -Wredundant-decls -Wswitch-default -Wnon-virtual-dtor -Wctor-dtor-privacy -Wold-style-cast ")
add_test(clean-public-core-headers "/home/michi/src/persistent-cache-cpp/trunk/tests/headers/check_public_headers.py" "/home/michi/src/persistent-cache-cpp/trunk/include/core")
