set(ZLIB_INSTALL_DIR ${CMAKE_BINARY_DIR}/external)
set(ZLIB_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/zlib-src)
set(ZLIB_BINARY_DIR ${CMAKE_BINARY_DIR}/external/build/zlib)

FetchContent_Declare(
    zlib
    OVERRIDE_FIND_PACKAGE
    URL "https://zlib.net/zlib-1.3.1.tar.gz"
    URL_HASH SHA256=9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23
)

FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
    FetchContent_Populate(zlib)
endif()

if(NOT EXISTS "${ZLIB_INSTALL_DIR}/lib/libz.a")
    file(MAKE_DIRECTORY ${ZLIB_BINARY_DIR})

    execute_process(
        COMMAND ./configure --prefix=${ZLIB_INSTALL_DIR}
        WORKING_DIRECTORY ${ZLIB_SOURCE_DIR}
        RESULT_VARIABLE result_configure
    )
    if(NOT result_configure EQUAL 0)
        message(FATAL_ERROR "Failed to configure ZLIB")
    endif()

    execute_process(
        COMMAND make
        WORKING_DIRECTORY ${ZLIB_SOURCE_DIR}
        RESULT_VARIABLE result_build
    )
    if(NOT result_build EQUAL 0)
        message(FATAL_ERROR "Failed to build ZLIB")
    endif()

    execute_process(
        COMMAND make install
        WORKING_DIRECTORY ${ZLIB_SOURCE_DIR}
        RESULT_VARIABLE result_build
    )
    if(NOT result_build EQUAL 0)
        message(FATAL_ERROR "Failed to install ZLIB")
    endif()
endif()

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}/external")
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)

add_library(ZLIB::ZLIB UNKNOWN IMPORTED GLOBAL)
add_dependencies(ZLIB::ZLIB zlib)

set_target_properties(ZLIB::ZLIB PROPERTIES
    IMPORTED_LOCATION ${ZLIB_INSTALL_DIR}/lib/libz.a
    INTERFACE_INCLUDE_DIRECTORIES ${ZLIB_INSTALL_DIR}/include
)
