##################################################################################
# This currently sets up the options for the WARNING FLAGS for the compiler we are generating for.
# Currently only have gnu
##################################################################################
MACRO(ORIGIN_ADD_COMMON_LIBRARY_FLAGS)
   OPTION(ORIGIN_COMPILE_WITH_FULL_WARNING "ORIGIN developers : Compilation with FULL warning (use only for ossim developers)." OFF)
   MARK_AS_ADVANCED(ORIGIN_COMPILE_WITH_FULL_WARNING)
   
   IF(ORIGIN_COMPILE_WITH_FULL_WARNING)
     IF(CMAKE_COMPILER_IS_GNUCXX)
       SET(ORIGIN_COMMON_COMPILER_FLAGS "${ORIGIN_COMMON_COMPILER_FLAGS} -Wall -Wunused  -Wunused-function  -Wunused-label  -Wunused-parameter -Wunused-value -Wunused-variable -Wuninitialized -Wsign-compare -Wparentheses -Wunknown-pragmas -Wswitch" CACHE STRING "List of compilation parameters.")
     ENDIF(CMAKE_COMPILER_IS_GNUCXX)
   ENDIF(ORIGIN_COMPILE_WITH_FULL_WARNING)

   IF(WIN32)
      #---
      # This option is to enable the /MP to compile multiple source files by using 
      # multiple processes.
      #---
      OPTION(WIN32_USE_MP "Set to ON to build ORIGIN with the /MP option (Visual Studio 2005 and above)." OFF)
      MARK_AS_ADVANCED(WIN32_USE_MP)
      IF(WIN32_USE_MP)
         SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP")
      ENDIF(WIN32_USE_MP)
     
      set(ORIGIN_COMMON_COMPILER_FLAGS "${ORIGIN_COMMON_COMPILER_FLAGS} -DNOMINMAX -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE") 
 
      set(DEBUG_BUILD OFF)
      IF(CMAKE_BUILD_TYPE)
         if(CMAKE_BUILD_TYPE STREQUAL "debug")
         	set(DEBUG_BUILD ON)
         endif()
      ENDIF(CMAKE_BUILD_TYPE)
     
      ###
      # Currently must set /FORCE:MULTIPLE for Visual Studio 2010. 29 October 2010 - drb
      ###
  
      IF(MSVC)
         message("MSVC_VERSION: ${MSVC_VERSION}")
      ENDIF(MSVC)
      if(${MSVC_VERSION} EQUAL 1600)
         if (DEBUG_BUILD)
            SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}  /FORCE:MULTIPLE")
         else ( )
            SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}  /FORCE:MULTIPLE")
         endif (DEBUG_BUILD)
         SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} /FORCE:MULTIPLE")
      else( )
         SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ")
      endif(${MSVC_VERSION} EQUAL 1600)

   ENDIF(WIN32)
   
   OPTION(ORIGIN_ADD_FPIC "Compilation with FPIC flag if static library.  The default is on since we have plugins that need to be shared." ON)
   MARK_AS_ADVANCED(ORIGIN_ADD_FPIC)
   IF(ORIGIN_ADD_FPIC)
       IF(UNIX AND NOT BUILD_SHARED_LIBS)
          STRING(REGEX MATCH "fPIC" REG_MATCHED "${ORIGIN_COMMON_COMPILER_FLAGS}")
          if(NOT REG_MATCHED)
             set(ORIGIN_COMMON_COMPILER_FLAGS "${ORIGIN_COMMON_COMPILER_FLAGS} -fPIC")
          endif(NOT REG_MATCHED)
       ENDIF(UNIX AND NOT BUILD_SHARED_LIBS)
   ENDIF(ORIGIN_ADD_FPIC)

   MARK_AS_ADVANCED(ORIGIN_COMMON_COMPILER_FLAGS)
ENDMACRO(ORIGIN_ADD_COMMON_LIBRARY_FLAGS)

MACRO(ORIGIN_ADD_COMMON_SETTINGS)
   IF(APPLE)
        SET(TEMP_CMAKE_OSX_ARCHITECTURES "x86_64")
        SET(CMAKE_OSX_SYSROOT "${CMAKE_OSX_SYSROOT}")
        # This is really fragile, but CMake doesn't provide the OS system
        # version information we need. (Darwin versions can be changed
        # independently of OS X versions.)
        # It does look like CMake handles the CMAKE_OSX_SYSROOT automatically.
        IF(EXISTS /Developer/SDKs/MacOSX10.6.sdk)
            SET(TEMP_CMAKE_OSX_ARCHITECTURES "i386;x86_64")
            IF(NOT ("${CMAKE_CXX_FLAGS}" MATCHES "mmacosx-version-min"))
               SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.5 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types.")
            ENDIF()
        ELSEIF(EXISTS /Developer/SDKs/MacOSX10.5.sdk)
            # 64-bit compiles are not supported with Carbon. We should enable 
            SET(TEMP_CMAKE_OSX_ARCHITECTURES "i386;x86_64")
            SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.5 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types.")
        ELSEIF(EXISTS /Developer/SDKs/MacOSX10.4u.sdk)
            SET(TEMP_CMAKE_OSX_ARCHITECTURES "i386;ppc")
            SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mmacosx-version-min=10.4 -ftree-vectorize -fvisibility-inlines-hidden" CACHE STRING "Flags used by the compiler during all build types.")
        ELSE()
            # No Universal Binary support
            # Should break down further to set the -mmacosx-version-min,
            # but the SDK detection is too unreliable here.
        ENDIF()
        IF(NOT CMAKE_OSX_ARCHITECTURES)
           SET(CMAKE_OSX_ARCHITECTURES "${TEMP_CMAKE_OSX_ARCHITECTURES}" CACHE STRING "Build architectures for OSX" FORCE)
        ENDIF()
        OPTION(ORIGIN_BUILD_APPLICATION_BUNDLES "Enable the building of applications and examples as OSX Bundles" OFF)
        
       MARK_AS_ADVANCED(CMAKE_OSX_ARCHITECTURES)
       MARK_AS_ADVANCED(CMAKE_CXX_FLAGS)
       MARK_AS_ADVANCED(CMAKE_OSX_SYSROOT)
       MARK_AS_ADVANCED(ORIGIN_BUILD_APPLICATION_BUNDLES)
   ENDIF(APPLE)

  SET(MAKE_APPENDS_BUILD_TYPE "NO")
  IF(CMAKE_GENERATOR)
     STRING(TOUPPER ${CMAKE_GENERATOR} CMAKE_GENERATOR_TEST_UPPER)
     STRING(COMPARE EQUAL "${CMAKE_GENERATOR_TEST_UPPER}" "XCODE" CMAKE_GENERATOR_TEST)
     IF(CMAKE_GENERATOR_TEST)
          SET(MAKE_APPENDS_BUILD_TYPE "YES")
     ELSE()
          STRING(COMPARE NOTEQUAL "." "${CMAKE_CFG_INTDIR}" CMAKE_GENERATOR_TEST)
          IF(CMAKE_GENERATOR_TEST)
             SET(MAKE_APPENDS_BUILD_TYPE "YES")
          ENDIF()
     ENDIF()
  ENDIF(CMAKE_GENERATOR)
   ORIGIN_ADD_COMMON_LIBRARY_FLAGS()

   # Dynamic vs Static Linking
   OPTION(BUILD_SHARED_LIBS "Set to ON to build ORIGIN for dynamic linking.  Use OFF for static." ON)
   OPTION(BUILD_ORIGIN_FRAMEWORKS "Set to ON to build ORIGIN for framework if BUILD_SHARED_LIBS is on.  Use OFF for dylib if BUILD_SHARED_LIBS is on." OFF)
   IF(BUILD_SHARED_LIBS)
       SET(ORIGIN_USER_DEFINED_DYNAMIC_OR_STATIC "SHARED")
   ELSE ()
       SET(ORIGIN_USER_DEFINED_DYNAMIC_OR_STATIC "STATIC")
   ENDIF()

   IF(MAKE_APPENDS_BUILD_TYPE)
      SET(BUILD_FRAMEWORK_DIR "")
      SET(BUILD_RUNTIME_DIR   "")
      SET(BUILD_LIBRARY_DIR   "")
      SET(BUILD_ARCHIVE_DIR   "")
      SET(BUILD_INCLUDE_DIR   "include")
   ELSE()
      IF(NOT DEFINED BUILD_FRAMEWORK_DIR)
         SET(BUILD_FRAMEWORK_DIR "${CMAKE_BUILD_TYPE}")
      ENDIF()
      IF(NOT DEFINED BUILD_RUNTIME_DIR)
         SET(BUILD_RUNTIME_DIR   "${CMAKE_BUILD_TYPE}")
      ENDIF()
      IF(NOT DEFINED BUILD_LIBRARY_DIR)  
         SET(BUILD_LIBRARY_DIR   "${CMAKE_BUILD_TYPE}")
      ENDIF()
      IF(NOT DEFINED BUILD_ARCHIVE_DIR)
         SET(BUILD_ARCHIVE_DIR   "${CMAKE_BUILD_TYPE}")
      ENDIF()
      IF(NOT DEFINED BUILD_INCLUDE_DIR)
         SET(BUILD_INCLUDE_DIR   "include")
      ENDIF()
   ENDIF()

ENDMACRO(ORIGIN_ADD_COMMON_SETTINGS)

ORIGIN_ADD_COMMON_SETTINGS()

