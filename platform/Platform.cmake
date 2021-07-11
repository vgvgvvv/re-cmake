
message(STATUS "include Platform.cmake")

if(NOT RE_TARGET_PLATFORM)
	set(RE_TARGET_PLATFORM "Windows")
endif()

if(${RE_TARGET_PLATFORM} STREQUAL "Windows")
	include("${CMAKE_CURRENT_LIST_DIR}/Windows.cmake")
elseif(${RE_TARGET_PLATFORM} STREQUAL "MacOS")
	include("${CMAKE_CURRENT_LIST_DIR}/MacOS.cmake")
elseif(${RE_TARGET_PLATFORM} STREQUAL "Linux")
	include("${CMAKE_CURRENT_LIST_DIR}/Linux.cmake")
elseif(${RE_TARGET_PLATFORM} STREQUAL "iOS")
	include("${CMAKE_CURRENT_LIST_DIR}/iOS.cmake")
elseif(${RE_TARGET_PLATFORM} STREQUAL "Android")
	include("${CMAKE_CURRENT_LIST_DIR}/Android.cmake")
endif()