cmake_minimum_required(VERSION 2.8)
SET(THIS_EXE_NAME OrgDataComm)
Project(${THIS_EXE_NAME})

INCLUDE(../../CMake/ORIGIN.cmake)

########################################### BEGIN: GRAB SOURCE FILES ##########################################
FILE(GLOB THIS_EXE_SRCS RELATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} 

								"${CMAKE_CURRENT_SOURCE_DIR}/*.cpp" )

############################### GRAB HEADERS #####################################
FILE(GLOB THIS_EXE_HEADERS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" 
							"${CMAKE_CURRENT_SOURCE_DIR}/*.h")


include_directories(${INSTALL_ROOT}/sqlite3/include)
Message("${INSTALL_ROOT}/sqlite3/include")

SET(DependentLibs sqlite3)
SET(TARGET_COMMON_LIBRARIES ${DependentLibs} 
							)



ORIGIN_SETUP_APPLICATION(${THIS_EXE_NAME} 
						INSTALL
						PACKAGE
						COMMAND_LINE 
						COMPONENT_NAME	${THIS_EXE_NAME} 
						SOURCE_FILES	${THIS_EXE_SRCS} 
						HEADERS			${THIS_EXE_HEADERS})

	
INCLUDE(../../CMake/ORIGINCPackSetup.cmake)								


