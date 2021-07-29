
ReMake_ShowIncludeFileName()

add_definitions(-DPLATFORM_WINDOWS)

function(UseWinMain TargetName)
	set_target_properties(${TargetName} PROPERTIES WIN32_EXECUTABLE TRUE)
endfunction()