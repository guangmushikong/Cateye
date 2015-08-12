#ORIGIN_ARCHITECTURE = x86; x64

SET(CMAKE_BUILD_TYPE "$ENV{ORIGIN_BUILD_TYPE}")
IF(NOT CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE "Release")
ENDIF()

SET(CMAKE_CONFIGURATION_TYPES "${CMAKE_BUILD_TYPE}" CACHE STRING "Configs" FORCE)

##############################ORIGIN_BUILD_TYPE = Release; Debug#############################
SET(ORIGIN_ARCHITECTURE  "$ENV{ORIGIN_ARCHITECTURE}" CACHE STRING "architecture" FORCE)

IF(NOT ORIGIN_ARCHITECTURE)
	SET(ORIGIN_ARCHITECTURE "x86")
ENDIF()
#############################################################################################


#设置BUILD目录,为工程输出目录（dll, lib, exe）
#BUILD_ROOT
#----bin
#------x86
#--------Release
#----------LIB_NAME.dll
#--------Debug
#----------LIB_NAMEd.dll
#------x64
#--------Release
#----------LIB_NAME.dll
#--------Debug
#----------LIB_NAMEd.dll
#----lib
#------x86
#--------Release
#----------LIB_NAME.lib
#--------Debug
#----------LIB_NAMEd.lib
#------x64
#--------Release
#----------LIB_NAME.lib
#--------Debug
#----------LIB_NAMEd.lib

SET(BUILD_ROOT "$ENV{ORIGIN_BUILD_ROOT}")
Message("BUILD_ROOT: ${BUILD_ROOT}")
############################################################################################



#设置INSTALL目录，供第三方使用（inclue、 bin、lib）
#INSTALL_ROOT
#--LIB_NAME
#----include
#------*.h
#----bin
#------x86
#--------Release
#----------LIB_NAME.dll
#--------Debug
#----------LIB_NAMEd.dll
#------x64
#--------Release
#----------LIB_NAME.dll
#--------Debug
#----------LIB_NAMEd.dll
#----lib
#------x86
#--------Release
#----------LIB_NAME.lib
#--------Debug
#----------LIB_NAMEd.lib
#------x64
#--------Release
#----------LIB_NAME.lib
#--------Debug
#----------LIB_NAMEd.lib

SET(INSTALL_ROOT "$ENV{ORIGIN_INSTALL_ROOT}")
Message("INSTALL_ROOT = ${INSTALL_ROOT}")
SET(CMAKE_INSTALL_PREFIX "${INSTALL_ROOT}")
############################################################################################




#设置Packages目录
SET(PACKAGES_ROOT "$ENV{ORIGIN_PACKAGES_ROOT}")
Message("PACKAGES_ROOT = ${PACKAGES_ROOT}")
SET(CPACK_OUTPUT_FILE_PREFIX "${PACKAGES_ROOT}")
##############################################################################################

IF(WIN32)
		SET(INSTALL_FRAMEWORK_DIR "Frameworks")
		SET(INSTALL_INCLUDE_DIR   "include")
   	SET(INSTALL_RUNTIME_DIR   "bin/${ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
   	SET(INSTALL_LIBRARY_DIR   "lib/${ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
   	SET(INSTALL_ARCHIVE_DIR   "lib/${ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
   			
		SET(CMAKE_DEBUG_POSTFIX "d" CACHE STRING "Debug variable used to add the postfix to dll's and exe's.  Defaults to 'd' on WIN32 builds and empty on all other platforms" FORCE)
  	
  	SET( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE PATH
     "Path to custom CMake Modules" FORCE )
		SET( INSTALL_DOC "${INSTALL_DOC}" CACHE BOOL
     "Set to OFF to skip build/install Documentation" FORCE )
     
    #######################构造BUILD目录结构########################################### 
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BUILD_ROOT}/bin/$ENV{ORIGIN_ARCHITECTURE}")
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
    ###################################################################################
    
    
    SET(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
		
		##设置链接库的目录
		LINK_DIRECTORIES("${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
		LINK_DIRECTORIES("${INSTALL_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")

		LINK_DIRECTORIES("${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
		LINK_DIRECTORIES("${INSTALL_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")	
else(WIN32)

endif(WIN32)

include_directories( ${PROJECT_SOURCE_DIR}/include )
include_directories( ${PROJECT_BINARY_DIR}/include )


OPTION(BUILD_SHARED_LIBS "Set to ON to build ORIGIN for dynamic linking.  Use OFF for static." ON)
#############################################################################################
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(ORIGIN_WINDOWS ON BOOL FORCE)
  set(ARCH i686)
  set(ORIGIN_ARCH ${ARCH}_win32)
  set(LL_ARCH_DIR ${ARCH}-win32)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Windows")

INCLUDE(../../CMake/ORIGINDetermineCompiler.cmake)  
INCLUDE(../../CMake/ORIGINUtilities.cmake)