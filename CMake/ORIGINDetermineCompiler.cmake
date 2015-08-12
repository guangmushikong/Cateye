

IF(MSVC80)
    MESSAGE(STATUS "Checking if compiler has service pack 1 installed...")
    FILE(WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.cxx" "int main() {return 0;}\n")

    TRY_COMPILE(_TRY_RESULT
        ${CMAKE_BINARY_DIR}
        ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.cxx
        CMAKE_FLAGS -D CMAKE_VERBOSE_MAKEFILE=ON
        OUTPUT_VARIABLE OUTPUT
        )

    IF(_TRY_RESULT)
        # parse for exact compiler version
        STRING(REGEX MATCH "Compiler Version [0-9]+.[0-9]+.[0-9]+.[0-9]+" vc_compiler_version "${OUTPUT}")
        IF(vc_compiler_version)
            #MESSAGE("${vc_compiler_version}")
            STRING(REGEX MATCHALL "[0-9]+" CL_VERSION_LIST "${vc_compiler_version}")
            LIST(GET CL_VERSION_LIST 0 CL_MAJOR_VERSION)
            LIST(GET CL_VERSION_LIST 1 CL_MINOR_VERSION)
            LIST(GET CL_VERSION_LIST 2 CL_PATCH_VERSION)
            LIST(GET CL_VERSION_LIST 3 CL_EXTRA_VERSION)
        ENDIF(vc_compiler_version)

        # Standard vc80 is 14.00.50727.42, sp1 14.00.50727.762, sp2?
        # Standard vc90 is 9.0.30729.1, sp1 ?
        IF(CL_EXTRA_VERSION EQUAL 762)
            SET(OSG_COMPILER "vc80sp1")
        ELSE(CL_EXTRA_VERSION EQUAL 762)
            SET(OSG_COMPILER "vc80")
        ENDIF(CL_EXTRA_VERSION EQUAL 762)

        # parse for exact visual studio version
        #IF(MSVC_IDE)
        # string(REGEX MATCH "Visual Studio Version [0-9]+.[0-9]+.[0-9]+.[0-9]+" vs_version "${OUTPUT}")
        # IF(vs_version)
        # MESSAGE("${vs_version}")
        # string(REGEX MATCHALL "[0-9]+" VS_VERSION_LIST "${vs_version}")
        # list(GET VS_VERSION_LIST 0 VS_MAJOR_VERSION)
        # list(GET VS_VERSION_LIST 1 VS_MINOR_VERSION)
        # list(GET VS_VERSION_LIST 2 VS_PATCH_VERSION)
        # list(GET VS_VERSION_LIST 3 VS_EXTRA_VERSION)
        # ENDIF(vs_version)
        #ENDIF(MSVC_IDE)
    ENDIF(_TRY_RESULT)
ENDIF(MSVC80)


# Some compiler options 
# macros that switch flag 'flag_src' on flag 'flag_dest' in compiler flags for ALL configurations 
macro(switch_compiler_flag flag_src flag_dest) 

    foreach(flag 
        CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE 
        CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO) 

        if(${flag} MATCHES "${flag_src}") 
            string(REGEX REPLACE "${flag_src}" "${flag_dest}" ${flag} "${${flag}}") 
        endif(${flag} MATCHES "${flag_src}") 
    endforeach(flag) 

    foreach(flag 
        CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE 
        CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO) 

        if(${flag} MATCHES "${flag_src}") 
            string(REGEX REPLACE "${flag_src}" "${flag_dest}" ${flag} "${${flag}}") 
        endif(${flag} MATCHES "${flag_src}") 
    endforeach(flag) 

endmacro(switch_compiler_flag flag_src flag_dest) 

macro(switch_linker_flag flag_src flag_dest) 
	
	message("________________________${CMAKE_EXE_LINKER_FLAGS_DEBUG}")

    foreach(flag 
        CMAKE_EXE_LINKER_FLAGS_DEBUG CMAKE_EXE_LINKER_FLAGS_RELEASE  CMAKE_EXE_LINKER_RELWITHDEBINFO) 

        if(${flag} MATCHES "${flag_src}") 
            string(REGEX REPLACE "${flag_src}" "${flag_dest}" ${flag} "${${flag}}") 
        endif(${flag} MATCHES "${flag_src}") 
    endforeach(flag) 

endmacro(switch_linker_flag flag_src flag_dest)

IF(MSVC)
	# remove annoying warnings 

	add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS) 
	# enable static run-time linking 
	if (MS_LINK_RUNTIME_STATIC) 
		#switch_compiler_flag("/MD" "/MT") 
		switch_compiler_flag("/MD" "/MT") 
	endif (MS_LINK_RUNTIME_STATIC) 
		
	# set some /NODEFAULT libs 
	#set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:LIBCMT.LIB") 

ENDIF(MSVC)
