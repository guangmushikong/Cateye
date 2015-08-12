include(InstallRequiredSystemLibraries)
include(BundleUtilities)

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Origin Work")
set(CPACK_PACKAGE_VENDOR "MagicPixel")
set(CPACK_PACKAGE_DESCRIPTION_FILE "$ENV{CMAKE_ROOT}/Copyright.txt")
set(CPACK_RESOURCE_FILE_LICENSE "$ENV{CMAKE_ROOT}/Copyright.txt")
set(CPACK_PACKAGE_VERSION "${VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}${VERSION_MAJOR}.${VERSION_MINOR}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${VERSION}")

# Make this explicit here, rather than accepting the CPack default value,
# so we can refer to it:
set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")

# Installers for 32- vs. 64-bit CMake:
#  - Root install directory (displayed to end user at installer-run time)
#  - "NSIS package/display name" (text used in the installer GUI)
#  - Registry key used to store info about the installation
if(CMAKE_CL_64)
	set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
	set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}-Win64")
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}${CPACK_PACKAGE_VERSION}-Win64")
else()
	set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
	set(CPACK_NSIS_PACKAGE_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
	set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_PACKAGE_NAME}${CPACK_PACKAGE_VERSION}")
endif()

if(NOT DEFINED CPACK_SYSTEM_NAME)
	# make sure package is not Cygwin-unknown, for Cygwin just
	# cygwin is good for the system name
	if("${CMAKE_SYSTEM_NAME}" STREQUAL "CYGWIN")
	  set(CPACK_SYSTEM_NAME Cygwin)
	else()
	  set(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})
	endif()
endif()

if(${CPACK_SYSTEM_NAME} MATCHES Windows)
	if(CMAKE_CL_64)
	  set(CPACK_SYSTEM_NAME win64-x64)
	else()
	  set(CPACK_SYSTEM_NAME win32-x86)
	endif()
endif()

if(NOT DEFINED CPACK_PACKAGE_FILE_NAME)
	# if the CPACK_PACKAGE_FILE_NAME is not defined by the cache
	# default to source package - system, on cygwin system is not
	# needed
	if(CYGWIN)
	  set(CPACK_PACKAGE_FILE_NAME "${CPACK_SOURCE_PACKAGE_FILE_NAME}")
	else()
	  set(CPACK_PACKAGE_FILE_NAME
		"${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
	endif()
endif()

set(CPACK_PACKAGE_CONTACT "QQ409039112")

#include CPack model once all variables are set
include(CPack)

