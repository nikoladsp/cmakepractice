set(FMT_INSTALL_DIR ${CMAKE_BINARY_DIR}/external)
set(FMT_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/fmt-src)
set(FMT_BINARY_DIR ${CMAKE_BINARY_DIR}/external/build/fmt)

FetchContent_Declare(
        fmt
        OVERRIDE_FIND_PACKAGE
        URL "https://github.com/fmtlib/fmt/archive/refs/tags/11.2.0.tar.gz"
        URL_HASH SHA256=bc23066d87ab3168f27cef3e97d545fa63314f5c79df5ea444d41d56f962c6af
)

FetchContent_GetProperties(fmt)
if(NOT fmt_POPULATED)
    FetchContent_Populate(fmt)
endif()

if(NOT EXISTS "${FMT_INSTALL_DIR}/lib/libfmt.a")
    file(MAKE_DIRECTORY ${FMT_BINARY_DIR})

    execute_process(
        COMMAND ${CMAKE_COMMAND}
        -S ${FMT_SOURCE_DIR}
        -B ${FMT_BINARY_DIR}
        -DCMAKE_INSTALL_PREFIX=${FMT_INSTALL_DIR}
        -DFMT_DOC=OFF
        -DFMT_TEST=OFF
         RESULT_VARIABLE result_configure
    )
    if(NOT result_configure EQUAL 0)
        message(FATAL_ERROR "Failed to configure FMT")
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${FMT_BINARY_DIR} --target install
        RESULT_VARIABLE result_build
    )
    if(NOT result_build EQUAL 0)
        message(FATAL_ERROR "Failed to build/install FMT")
    endif()
endif()
