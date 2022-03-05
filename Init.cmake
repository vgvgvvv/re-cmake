
message(STATUS "inlcude init.cmake")

# 包含所有cmake
include (GenerateExportHeader)

include("${CMAKE_CURRENT_LIST_DIR}/Basic.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Tools.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Git.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/ObjectiveC.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Build.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/Json.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/platform/Platform.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/conan.cmake")


macro(ReMake_InitProject)
	set(CMAKE_DEBUG_POSTFIX "")
	set(CMAKE_RELEASE_POSTFIX "")
	set(CMAKE_MINSIZEREL_POSTFIX "")
	set(CMAKE_RELWITHDEBINFO_POSTFIX "")
  
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

	
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/debug/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/release/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/minsizerel/bin")
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/relwithdebinfo/bin")
	

	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/debug/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/release/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/minsizerel/lib")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/relwithdebinfo/lib")
	

	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/debug/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/release/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/minsizerel/bin")
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${REMAKE_ROOT_PATH}/binary/${RE_TARGET_PLATFORM}/relwithdebinfo/bin")
	
	if(${CMAKE_BUILD_TYPE} STREQUAL Debug)

		set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG})
		set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG})
		set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG})

	elseif(${CMAKE_BUILD_TYPE} STREQUAL Release)

		set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE})
		set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE})
		set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE})

	elseif(${CMAKE_BUILD_TYPE} STREQUAL MinSizeRel)

		set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL})
		set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL})
		set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL})

	elseif(${CMAKE_BUILD_TYPE} STREQUAL RelWithDebInfo)
		set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO})
		set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO})
		set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO})
	endif()
endmacro()

macro(ReMake_SetToolChainFile ToolChainFilePath)
set(CMAKE_TOOLCHAIN_FILE ${ToolChainFilePath})
endmacro()