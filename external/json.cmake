set(JSON_INSTALL_DIR ${CMAKE_BINARY_DIR}/external)
set(JSON_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/json-src)
set(JSON_BINARY_DIR ${CMAKE_BINARY_DIR}/external/build/json)

FetchContent_Declare(
    json
    OVERRIDE_FIND_PACKAGE
    URL "https://github.com/nlohmann/json/archive/refs/tags/v3.10.5.tar.gz"
    URL_HASH SHA256=5daca6ca216495edf89d167f808d1d03c4a4d929cef7da5e10f135ae1540c7e4
)

FetchContent_GetProperties(json)
if(NOT json_POPULATED)
    FetchContent_Populate(json)
endif()

if(NOT EXISTS "${JSON_INSTALL_DIR}/include/nlohmann/json.hpp")
    file(MAKE_DIRECTORY ${JSON_BINARY_DIR})

    execute_process(
        COMMAND ${CMAKE_COMMAND}
        -S ${JSON_SOURCE_DIR}
        -B ${JSON_BINARY_DIR}
        -DCMAKE_INSTALL_PREFIX=${JSON_INSTALL_DIR}
        -DJSON_BuildTests=OFF
        RESULT_VARIABLE result_configure
    )
    if(NOT result_configure EQUAL 0)
        message(FATAL_ERROR "Failed to configure JSON")
    endif()

    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${JSON_BINARY_DIR} --target install
        RESULT_VARIABLE result_build
    )
    if(NOT result_build EQUAL 0)
        message(FATAL_ERROR "Failed to build/install JSON")
    endif()
endif()
