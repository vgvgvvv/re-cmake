
message(STATUS "include Platform.cmake")

if(NOT RE_TARGET_PLATFORM)
	IF (WIN32)
		MESSAGE(STATUS "Current System WIN32")
		set(RE_TARGET_PLATFORM "Windows")
	ELSEIF (APPLE)
		MESSAGE(STATUS "Current System Apple")
		set(RE_TARGET_PLATFORM "MacOS")
	ELSEIF (UNIX)
		MESSAGE(STATUS "Current System Unix")
		set(RE_TARGET_PLATFORM "Linux")
	ENDIF ()
endif()

set(IS_WINDOWS 	0)
set(IS_MACOS 	0)
set(IS_LINUX 	0)
set(IS_IOS 		0)
set(IS_ANDROID 	0)

function(ReMake_InitPlatform
		RETURN_IS_WINDOWS
		RETURN_IS_MACOS
		RETURN_IS_LINUX
		RETURN_IS_IOS
		RETURN_IS_ANDROID)


	if(${RE_TARGET_PLATFORM} STREQUAL "Windows")
		set(${RETURN_IS_WINDOWS} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/OS/Windows.cmake")
	elseif(${RE_TARGET_PLATFORM} STREQUAL "MacOS")
		set(${RETURN_IS_MACOS} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/OS/MacOS.cmake")
	elseif(${RE_TARGET_PLATFORM} STREQUAL "Linux")
		set(${RETURN_IS_LINUX} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/OS/Linux.cmake" PARENT_SCOPE)
	elseif(${RE_TARGET_PLATFORM} STREQUAL "iOS")
		set(${RETURN_IS_IOS} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/OS/iOS.cmake")
	elseif(${RE_TARGET_PLATFORM} STREQUAL "Android")
		set(${RETURN_IS_ANDROID} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/OS/Android.cmake")
	endif()

endfunction()

ReMake_InitPlatform(
		IS_WINDOWS
		IS_MACOS
		IS_LINUX
		IS_IOS
		IS_ANDROID
)
message(STATUS "IS_WINDOWS=${IS_WINDOWS}")
message(STATUS "IS_MACOS=${IS_MACOS}")
message(STATUS "IS_LINUX=${IS_LINUX}")
message(STATUS "IS_IOS=${IS_IOS}")
message(STATUS "IS_ANDROID=${IS_ANDROID}")


set(CPP_COMPILED_BY_CLANG 	0)
set(CPP_COMPILED_BY_GUN 	0)
set(CPP_COMPILED_BY_INTEL 	0)
set(CPP_COMPILED_BY_MSVC 	0)

function(ReMake_InitCompiler
		COMPILED_BY_CLANG
		COMPILED_BY_GUN
		COMPILED_BY_INTEL
		COMPILED_BY_MSVC)

	if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
		# using Clang
		set(${COMPILED_BY_CLANG} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Compiler/Clang.cmake")
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		# using GCC
		set(${COMPILED_BY_GUN} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Compiler/GCC.cmake")
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
		# using Intel C++
		set(${COMPILED_BY_INTEL} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Compiler/Intel.cmake")
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		# using Visual Studio C++
		set(${COMPILED_BY_MSVC} 1 PARENT_SCOPE)
		include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/Compiler/MSVC.cmake")
	else ()
		message(FATAL_ERROR "unknown compiler !! ${CMAKE_CXX_COMPILER_ID}")
	endif()
endfunction()

ReMake_InitCompiler(
		CPP_COMPILED_BY_CLANG
		CPP_COMPILED_BY_GUN
		CPP_COMPILED_BY_INTEL
		CPP_COMPILED_BY_MSVC)

message(STATUS "CPP_COMPILED_BY_CLANG=${CPP_COMPILED_BY_CLANG}")
message(STATUS "CPP_COMPILED_BY_GUN=${CPP_COMPILED_BY_GUN}")
message(STATUS "CPP_COMPILED_BY_INTEL=${CPP_COMPILED_BY_INTEL}")
message(STATUS "CPP_COMPILED_BY_MSVC=${CPP_COMPILED_BY_MSVC}")

function(ReMake_IsValidPlatformFileOrDir Dir ReturnValue)

	set(${ReturnValue} 1 PARENT_SCOPE)

	get_filename_component(dirName ${Dir} NAME)
	get_filename_component(dirParent ${Dir} PATH)

	if("${dirName}" STREQUAL "")
		return()
	endif()

	if(${dirName} STREQUAL "Windows")
		if(NOT IS_WINDOWS EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif ()
	elseif(${dirName} STREQUAL "Mac")
		if(NOT IS_MACOS EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif ()
	elseif (${dirName} STREQUAL "Linux")
		if(NOT IS_LINUX EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif ()
	elseif(${dirName} STREQUAL "IOS")
		if(NOT IS_IOS EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif ()
	elseif(${dirName} STREQUAL "Android")
		if(NOT IS_ANDROID EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif ()
	else()
		set(isValidSubDir 0)
		ReMake_IsValidPlatformFileOrDir(${dirParent} isValidSubDir)
		if(NOT ${isValidSubDir} EQUAL 1)
			set(${ReturnValue} 0 PARENT_SCOPE)
		endif()
	endif()

endfunction()



