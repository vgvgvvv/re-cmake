
ReMake_ShowIncludeFileName()

add_definitions(-DPLATFORM_WINDOWS)
set(IS_WINDOWS 1)

function(UseWinMain TargetName)
	set_target_properties(${TargetName} PROPERTIES WIN32_EXECUTABLE TRUE)
endfunction()