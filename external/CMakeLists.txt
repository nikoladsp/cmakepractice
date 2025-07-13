#cmake_minimum_required(VERSION 3.26)
#project(cmakepractice)
#
#set(CMAKE_CXX_STANDARD 17)
#
#add_executable(cmakepractice main.cpp)
include(FetchContent)
include(CMakePrintHelpers)

#if(BUILD_DEPS)
#    file(REMOVE_RECURSE ${PROJECT_SOURCE_DIR}/deps/bin)
#    file(REMOVE_RECURSE ${PROJECT_SOURCE_DIR}/deps/include)
#    file(REMOVE_RECURSE ${OUTPUT_LIB_DIR})
#    file(REMOVE_RECURSE ${PROJECT_SOURCE_DIR}/deps/share)
#    file(REMOVE_RECURSE ${PROJECT_SOURCE_DIR}/build/_deps)
#endif()

#set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/deps)
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/deps/lib")
#cmake_print_variables(CMAKE_SYSTEM_NAME CMAKE_SYSTEM_PROCESSOR)

if (${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
    set(EXTERNALS_CMAKE_DIR ${PROJECT_BINARY_DIR}/external/lib/cmake)
else (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(EXTERNALS_CMAKE_DIR ${PROJECT_BINARY_DIR}/external/lib64/cmake)
endif()
#cmake_print_variables(EXTERNALS_CMAKE_DIR CMAKE_GENERATOR_PLATFORM)

include("json.cmake")
include("soci.cmake")