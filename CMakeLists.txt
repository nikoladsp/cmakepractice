cmake_minimum_required(VERSION 3.26)
project(cmakepractice)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

list(APPEND CMAKE_PREFIX_PATH "${PROJECT_BINARY_DIR}/external/lib/cmake")
#list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/external")
#set(ENV{PKG_CONFIG_PATH} "${PROJECT_BINARY_DIR}/external/lib/pkgconfig")
#set(ZLIB_ROOT "${CMAKE_BINARY_DIR}/external")
#set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

include(FetchContent)
#include(ExternalProject)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external")
include(fmt)
include(json)
include(soci)
include(zlib)

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
