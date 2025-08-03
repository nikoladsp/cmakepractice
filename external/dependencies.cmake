include(FetchContent)

string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" ARCH_LOWER)

if(ARCH_LOWER MATCHES "^(x86_64|amd64)$")
    set(ARCH_SUFFIX "64")
elseif(ARCH_LOWER MATCHES "^(i[3-6]86)$")
    set(ARCH_SUFFIX "32")
elseif(ARCH_LOWER MATCHES "^(armv7|armv7l|arm)$")
    set(ARCH_SUFFIX "arm32")
elseif(ARCH_LOWER MATCHES "^(aarch64)$")
    set(ARCH_SUFFIX "arm64")
else()
    set(ARCH_SUFFIX "${ARCH_LOWER}")
endif()

set(INSTALL_DIR ${CMAKE_BINARY_DIR}/external/${ARCH_SUFFIX})

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external")

include(${CMAKE_CURRENT_LIST_DIR}/fmt.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/json.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/soci.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/zlib.cmake)

list(PREPEND CMAKE_PREFIX_PATH "${PROJECT_BINARY_DIR}/external/${ARCH_LOWER}/lib/cmake")
