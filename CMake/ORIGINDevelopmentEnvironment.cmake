#第三方库目录 ORIGIN_DEPS_DIR
#ORIGIN_ARCHITECTURE = x86; x64
#ORIGIN_BUILD_TYPE = Release; Debug

#设置BUILD目录
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

#设置INSTALL目录
#INSTALL_ROOT
#--LIB_NAME
#----include
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
############################################################################################
#设置打包目录

SET(CMAKE_BUILD_TYPE "$ENV{ORIGIN_BUILD_TYPE}")
IF(NOT CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE "Release")
ENDIF()

SET(CMAKE_CONFIGURATION_TYPES "${CMAKE_BUILD_TYPE}" CACHE STRING "Configs" FORCE)

SET(ORIGIN_ARCHITECTURE  "$ENV{ORIGIN_ARCHITECTURE}" CACHE STRING "architecture" FORCE)

IF(NOT ORIGIN_ARCHITECTURE)
	SET(ORIGIN_ARCHITECTURE "x86")
ENDIF()


SET(INSTALL_ROOT "$ENV{ORIGIN_INSTALL_PREFIX}")
message(INSTALL_ROOT)
SET(BUILD_ROOT "$ENV{ORIGIN_BUILD_ROOT}")

IF(NOT INSTALL_ROOT)
	SET(INSTALL_ROOT "${CMAKE_BINARY_DIR}/install")
ENDIF()

SET(CMAKE_INSTALL_PREFIX "${INSTALL_ROOT}")

SET(ORIGIN_DEPS_LIBRARY_DIR_DEBUG "$ENV{ORIGIN_DEPS_DIR}/lib/$ENV{ORIGIN_ARCHITECTURE}/debug" )
SET(ORIGIN_DEPS_LIBRARY_DIR_RELEASE "$ENV{ORIGIN_DEPS_DIR}/lib/$ENV{ORIGIN_ARCHITECTURE}/release")

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
     
     
    SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BUILD_ROOT}/bin/$ENV{ORIGIN_ARCHITECTURE}")
    SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
    SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
    
    SET(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
		#SET(CPACK_PACKAGING_INSTALL_PREFIX "${BUILD_ROOT}")
		SET(CPACK_OUTPUT_FILE_PREFIX packages)
		
    LINK_DIRECTORIES("$ENV{ORIGIN_DEPS_DIR}/lib/$ENV{ORIGIN_ARCHITECTURE}")
		LINK_DIRECTORIES("${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}")
#		LINK_DIRECTORIES("$ENV{ORIGIN_INSTALL_PREFIX}/lib/$ENV{ORIGIN_ARCHITECTURE}")
		
		LINK_DIRECTORIES("$ENV{ORIGIN_DEPS_DIR}/lib/$ENV{ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
		LINK_DIRECTORIES("${BUILD_ROOT}/lib/$ENV{ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")
#		LINK_DIRECTORIES("$ENV{ORIGIN_INSTALL_PREFIX}/lib/$ENV{ORIGIN_ARCHITECTURE}/${CMAKE_BUILD_TYPE}")	
else(WIN32)

endif(WIN32)

include_directories( ${PROJECT_SOURCE_DIR}/include )
include_directories( ${PROJECT_BINARY_DIR}/include )
include_directories( $ENV{ORIGIN_DEPS_DIR}/include )
include_directories( ${CMAKE_INSTALL_PREFIX}/include )


OPTION(BUILD_SHARED_LIBS "Set to ON to build ORIGIN for dynamic linking.  Use OFF for static." ON)
#############################################################################################
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(ORIGIN_WINDOWS ON BOOL FORCE)
  set(ARCH i686)
  set(ORIGIN_ARCH ${ARCH}_win32)
  set(LL_ARCH_DIR ${ARCH}-win32)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Windows")

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(ORIGIN_LINUX ON BOOl FORCE)
  execute_process(COMMAND uname -m COMMAND sed s/i.86/i686/
                  OUTPUT_VARIABLE ARCH OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(ORIGIN_ARCH ${ARCH}_linux)
  set(ORIGIN_ARCH_DIR ${ARCH}-linux)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(DARWIN 1)
  # set this dynamically from the build system now -
  # NOTE: wont have a distributable build unless you add this on the configure line with:
  # -DCMAKE_OSX_ARCHITECTURES:STRING='i386;ppc'
  #set(CMAKE_OSX_ARCHITECTURES i386;ppc)
  set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.4u.sdk)
  if (CMAKE_OSX_ARCHITECTURES MATCHES "i386" AND CMAKE_OSX_ARCHITECTURES MATCHES "ppc")
    set(ARCH universal)
  else (CMAKE_OSX_ARCHITECTURES MATCHES "i386" AND CMAKE_OSX_ARCHITECTURES MATCHES "ppc")
    if (${CMAKE_SYSTEM_PROCESSOR} MATCHES "ppc")
      set(ARCH ppc)
    else (${CMAKE_SYSTEM_PROCESSOR} MATCHES "ppc")
      set(ARCH i386)
    endif (${CMAKE_SYSTEM_PROCESSOR} MATCHES "ppc")
  endif (CMAKE_OSX_ARCHITECTURES MATCHES "i386" AND CMAKE_OSX_ARCHITECTURES MATCHES "ppc")
  set(LL_ARCH ${ARCH}_darwin)
  set(LL_ARCH_DIR universal-darwin)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
     
#add rpath support on *nix like system
SET(CMAKE_SKIP_BUILD_RPATH  TRUE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}/lib;./../../lib/x86")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

