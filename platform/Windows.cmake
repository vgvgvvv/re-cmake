
ReMake_ShowIncludeFileName()

if (IS_WINDOWS EQUAL 1)

	add_definitions(-DPLATFORM_WINDOWS)

endif ()

function(UseWinMain TargetName)
	set_target_properties(${TargetName} PROPERTIES WIN32_EXECUTABLE TRUE)
endfunction()