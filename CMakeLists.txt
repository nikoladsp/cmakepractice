cmake_minimum_required(VERSION 3.26)
project(cmakepractice)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#list(APPEND CMAKE_PREFIX_PATH "${PROJECT_BINARY_DIR}/external/lib/cmake")

add_subdirectory("external")

find_package(nlohmann_json 3.10.5 EXACT REQUIRED)# PATHS ${PROJECT_BINARY_DIR}/external/lib/cmake NO_DEFAULT_PATH)
find_package(SOCI 4.0.3 EXACT REQUIRED)# PATHS ${EXTERNALS_CMAKE_DIR} NO_DEFAULT_PATH)

add_executable(cmakepractice main.cpp
        foo.h)

target_link_libraries(cmakepractice nlohmann_json::nlohmann_json SOCI::soci_core SOCI::soci_sqlite3_static)
