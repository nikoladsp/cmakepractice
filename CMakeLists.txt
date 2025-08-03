cmake_minimum_required(VERSION 3.26)
project(cmakepractice)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(external/dependencies.cmake)

find_package(SOCI 4.0.3 EXACT REQUIRED)
find_package(FMT 11.2.0 EXACT REQUIRED)
find_package(nlohmann_json 3.10.5 EXACT REQUIRED)
find_package(zlib 1.3.1 EXACT REQUIRED)

add_executable(cmakepractice main.cpp foo.h)

target_link_libraries(cmakepractice
    PRIVATE
    ZLIB::ZLIB
    nlohmann_json::nlohmann_json
    fmt::fmt
    SOCI::soci_core_static
    SOCI::soci_sqlite3_static
)
