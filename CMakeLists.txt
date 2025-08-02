cmake_minimum_required(VERSION 3.26)
project(cmakepractice)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_PREFIX_PATH "${PROJECT_BINARY_DIR}/external/lib/cmake")

include(FetchContent)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external")
include(fmt)
include(json)
include(soci)

find_package(SOCI 4.0.3 EXACT REQUIRED)
find_package(FMT 11.2.0 EXACT REQUIRED)
find_package(nlohmann_json 3.10.5 EXACT REQUIRED)

add_executable(cmakepractice main.cpp foo.h)

target_link_libraries(cmakepractice
        PRIVATE
        nlohmann_json::nlohmann_json
        fmt::fmt
        SOCI::soci_core_static
        SOCI::soci_sqlite3_static
)
