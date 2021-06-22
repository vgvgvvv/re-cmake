
message(STATUS "inlcude init.cmake")

# °üº¬ËùÓÐcmake
include("${CMAKE_CURRENT_LIST_DIR}/Basic.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Tools.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Git.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Build.cmake")


macro(Ubpa_InitProject)
	set(CMAKE_DEBUG_POSTFIX "d")
	set(CMAKE_RELEASE_POSTFIX "")
	set(CMAKE_MINSIZEREL_POSTFIX "msr")
	set(CMAKE_RELWITHDEBINFO_POSTFIX "rd")
  
	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED True)

	if(NOT CMAKE_BUILD_TYPE)
		message(NOTICE "No default CMAKE_BUILD_TYPE, so UCMake set it to \"Debug\"")
		set(CMAKE_BUILD_TYPE Debug CACHE STRING
			"Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
	endif()


	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${Ubpa_RootProjectPath}/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${Ubpa_RootProjectPath}/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${Ubpa_RootProjectPath}/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${Ubpa_RootProjectPath}/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${Ubpa_RootProjectPath}/lib")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${Ubpa_RootProjectPath}/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${Ubpa_RootProjectPath}/bin")
endmacro()