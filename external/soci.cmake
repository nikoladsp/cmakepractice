set(DEP_NAME "SOCI")
set(DEP_VERSION "4.0.3")

find_package(${DEP_NAME} ${DEP_VERSION} EXACT PATHS ${EXTERNALS_CMAKE_DIR} NO_DEFAULT_PATH)

if(${DEP_NAME}_FOUND)
    message("${DEP_NAME} ${DEP_VERSION} found")
    return()
endif()

FetchContent_Declare(
        ${DEP_NAME}
        OVERRIDE_FIND_PACKAGE
        URL "https://github.com/SOCI/soci/archive/refs/tags/v${DEP_VERSION}.tar.gz"
        URL_HASH SHA256=4b1ff9c8545c5d802fbe06ee6cd2886630e5c03bf740e269bb625b45cf934928
)
FetchContent_GetProperties(${DEP_NAME})
FetchContent_Populate(${DEP_NAME})

if(NOT ${${DEP_NAME}_POPULATED})
    message(FATAL_ERROR "${DEP_NAME}-${DEP_VERSION} not populated")
endif()

set(BUILD_CMD "cmake;-DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/external;-DSOCI_CXX11=ON;-DWITH_BOOST=OFF;-DSOCI_TESTS=OFF;${soci_SOURCE_DIR}")
execute_process(
    COMMAND ${BUILD_CMD}
    WORKING_DIRECTORY "${${DEP_NAME}_BINARY_DIR}"
    RESULT_VARIABLE DEP_RESULT
)

if(NOT DEP_RESULT EQUAL "0")
    message(FATAL_ERROR "${DEP_NAME} configure failed with ${DEP_RESULT}")
else()
    message("-- ${DEP_NAME} ${DEP_VERSION} configure finished")
endif()

execute_process(
    COMMAND make install
    WORKING_DIRECTORY "${${DEP_NAME}_BINARY_DIR}"
    RESULT_VARIABLE DEP_RESULT
)

if(NOT DEP_RESULT EQUAL "0")
    message(FATAL_ERROR "${DEP_NAME} build failed with ${DEP_RESULT}")
else()
    message("-- ${DEP_NAME} ${DEP_VERSION} build finished")
endif()

find_package(${DEP_NAME} ${DEP_VERSION} EXACT REQUIRED PATHS ${EXTERNALS_CMAKE_DIR} NO_DEFAULT_PATH)
