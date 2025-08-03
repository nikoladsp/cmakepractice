set(SOCI_INSTALL_DIR ${EXTERNAL_INSTALL_DIR})
set(SOCI_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/soci-src)
set(SOCI_BINARY_DIR ${EXTERNAL_BUILD_DIR}/soci)

FetchContent_Declare(
    soci
    OVERRIDE_FIND_PACKAGE
    URL "https://github.com/SOCI/soci/archive/refs/tags/v4.0.3.tar.gz"
    URL_HASH SHA256=4b1ff9c8545c5d802fbe06ee6cd2886630e5c03bf740e269bb625b45cf934928
)

FetchContent_GetProperties(soci)
if(NOT soci_POPULATED)
    FetchContent_Populate(soci)
endif()

if(NOT EXISTS "${SOCI_INSTALL_DIR}/lib/libsoci_core.a")
    file(MAKE_DIRECTORY ${SOCI_BINARY_DIR})

    execute_process(
        COMMAND ${CMAKE_COMMAND}
        -S ${SOCI_SOURCE_DIR}
        -B ${SOCI_BINARY_DIR}
        -DCMAKE_INSTALL_PREFIX=${SOCI_INSTALL_DIR}
        -DSOCI_STATIC=ON
        -DSOCI_SHARED=OFF
        -DSOCI_TESTS=OFF
        -DWITH_SQLITE3=ON
        -DWITH_MYSQL=OFF
        -DWITH_POSTGRESQL=OFF
        -DWITH_ORACLE=OFF
        -DWITH_BOOST=OFF
        RESULT_VARIABLE result_configure
    )
    if(NOT result_configure EQUAL 0)
        message(FATAL_ERROR "Failed to configure SOCI")
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${SOCI_BINARY_DIR} --target install
        RESULT_VARIABLE result_build
    )
    if(NOT result_build EQUAL 0)
        message(FATAL_ERROR "Failed to build/install SOCI")
    endif()
endif()
