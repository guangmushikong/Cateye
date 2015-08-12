cmake_minimum_required(VERSION 2.8)

SET(THIS_LIB_NAME sqlite3)

Project(${THIS_LIB_NAME})
INCLUDE(../../CMake/ORIGINDetermineCompiler.cmake)
INCLUDE(../../CMake/ORIGINUtilities.cmake)
INCLUDE(../../CMake/ORIGINDevelopmentEnvironment.cmake)


ADD_DEFINITIONS("-DSQLITE_API=__declspec(dllexport)")

########################################### BEGIN: GRAB SOURCE FILES ##########################################
FILE(GLOB THIS_LIB_SRCS RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} 
									"${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"	
									"${CMAKE_CURRENT_SOURCE_DIR}/*.c"
									"${CMAKE_CURRENT_SOURCE_DIR}/*.cxx")		

############################### GRAB HEADERS #####################################
FILE(GLOB THIS_LIB_HEADERS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" 
									"${CMAKE_CURRENT_SOURCE_DIR}/*.h"
									)

SET(DependentLibs )


ORIGIN_LINK_LIBRARY(${THIS_LIB_NAME} 
                   TYPE ${USER_DEFINED_DYNAMIC}
                   LIBRARIES 	${DependentLibs} 	
                   HEADERS "${THIS_LIB_HEADERS}" 
                   PUBLIC_HEADERS "${THIS_LIB_HEADERS}"
                   SOURCE_FILES "${THIS_LIB_SRCS}" 
				   				 INSTALL_LIB
				   				 INSTALL_HEADERS
                   )




