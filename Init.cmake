
message(STATUS "inlcude init.cmake")

# 包含所有cmake
include (GenerateExportHeader)

include("${CMAKE_CURRENT_LIST_DIR}/Basic.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Tools.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Git.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Build.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Json.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/platform/Platform.cmake")


macro(ReMake_InitProject)
	# set(CMAKE_DEBUG_POSTFIX "d")
	# set(CMAKE_RELEASE_POSTFIX "")
	# set(CMAKE_MINSIZEREL_POSTFIX "msr")
	# set(CMAKE_RELWITHDEBINFO_POSTFIX "rd")
  
	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED True)

	if(NOT CMAKE_BUILD_TYPE)
		message(NOTICE "No default CMAKE_BUILD_TYPE, so UCMake set it to \"Debug\"")
		set(CMAKE_BUILD_TYPE Debug CACHE STRING
			"Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
	endif()

	if(NOT REMAKE_ROOT_PATH)
		set(REMAKE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
	endif()

	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${REMAKE_ROOT_PATH}/binary/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/debug/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/release/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/minsizerel/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/relwithdebinfo/bin")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${REMAKE_ROOT_PATH}/binary/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/debug/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/release/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/minsizerel/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/relwithdebinfo/lib")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${REMAKE_ROOT_PATH}/binary/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/debug/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/release/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/minsizerel/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/relwithdebinfo/bin")
endmacro()