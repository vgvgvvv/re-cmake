
message(STATUS "[Global] include init.cmake")

# 包含所有cmake
include (GenerateExportHeader)
include("${CMAKE_CURRENT_LIST_DIR}/Basic.cmake")

ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/Tools.cmake")
ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/Git.cmake")
ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/ObjectiveC.cmake")
ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/Build.cmake")
ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/Json.cmake")
ReMake_Include("${CMAKE_CURRENT_LIST_DIR}/platform/Platform.cmake")

set(REMAKE_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(REMAKE_TEMP_ROOT ${REMAKE_ROOT}/Temp)
ReMake_DefaultLog("REMAKE Lib ROOT : ${REMAKE_ROOT}")

macro(ReMake_InitProject)

	if(NOT REMAKE_INITED)
		set(REMAKE_INITED 1)
		add_definitions(-DUSE_REMAKE=1)
	else()
		return()
	endif()

	if(NOT REMAKE_ROOT_PATH)
		set(REMAKE_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
	endif()

	ReMake_DefaultLog("start init project root is ${REMAKE_ROOT_PATH}")

	set(CMAKE_DEBUG_POSTFIX "")
	set(CMAKE_RELEASE_POSTFIX "")
	set(CMAKE_MINSIZEREL_POSTFIX "")
	set(CMAKE_RELWITHDEBINFO_POSTFIX "")
  
	set(CMAKE_CXX_STANDARD 23)
	set(CMAKE_CXX_STANDARD_REQUIRED True)

	if(COMPILED_BY_MSVC EQUAL 1)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8")
	endif()
	ReMake_DefaultLog("CMAKE_CXX_FLAGS = ${CMAKE_CXX_FLAGS}")

	if(NOT CMAKE_BUILD_TYPE)
		ReMake_DefaultLog("No default CMAKE_BUILD_TYPE, so UCMake set it to \"Debug\"")
		set(CMAKE_BUILD_TYPE Debug CACHE STRING
			"Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
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

# invoke before project
macro(ReMake_SetToolChainFile ToolChainFilePath)
	set(CMAKE_TOOLCHAIN_FILE ${ToolChainFilePath})
endmacro()

# invoke before project
macro(ReMake_UseVcpkg VcpkgPath)
	ReMake_DefaultLog("Use Vcpkg at ${VcpkgPath}")
	set(USE_VCPKG true)
	set(VCPKG_ROOT ${VcpkgPath})
	if(IS_WINDOWS EQUAL 1)
		set(VCPKG_CMD ${VcpkgPath}/vcpkg.exe)
	else()
		set(VCPKG_CMD ${VcpkgPath}/vcpkg)
	endif()
	set(CMAKE_TOOLCHAIN_FILE "${VcpkgPath}/scripts/buildsystems/vcpkg.cmake")
	set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${VcpkgPath}/packages")
	ReMake_Include(${REMAKE_ROOT}/vcpkg.cmake)
endmacro()

# invoke before project
macro(ReMake_UseConan)
	ReMake_DefaultLog("Use Conan at ${REMAKE_ROOT}/conan.cmake")
	set(USE_CONAN true)
	ReMake_Include(${REMAKE_ROOT}/conan.cmake)
endmacro()

set(CPM_INTERNAL_LOCATION ${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)
# invoke before project
function(ReMake_UseCPM)
	set(USE_CPM true)

	ReMake_DefaultLog("cpm internal location ${CPM_INTERNAL_LOCATION}")

	if(EXISTS ${CPM_INTERNAL_LOCATION})
		ReMake_DefaultLog("Use CPM at ${CPM_INTERNAL_LOCATION}")
		ReMake_Include(${CPM_INTERNAL_LOCATION})
	else()

		add_definitions(-DCPM_SOURCE_CACHE=${REMAKE_TEMP_ROOT}/CMP/deps)

		set(CPM_DOWNLOAD_VERSION 0.35.1)
		if(CPM_SOURCE_CACHE)
			set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
		elseif(DEFINED ENV{CPM_SOURCE_CACHE})
			set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
		else()
			set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
		endif()

		if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
			ReMake_DefaultLog("Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
			file(DOWNLOAD
					https://github.com/cpm-cmake/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
					${CPM_DOWNLOAD_LOCATION}
					)
		endif()
		ReMake_DefaultLog("Use CPM at ${CPM_DOWNLOAD_LOCATION}")
		ReMake_Include(${CPM_DOWNLOAD_LOCATION})
	endif()
endfunction()