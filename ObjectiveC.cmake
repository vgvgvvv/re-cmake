
macro(ReMake_SetupObjectiveC TargetName)
    set(USE_OBJECTIVE_C 1)
    target_compile_options(${TargetName}
            PUBLIC -x
            PUBLIC objective-c)
endmacro()

macro(ReMake_OC_UseFramework TargetName FrameworkName)
    target_link_libraries(
            ${TargetName}
            "-framework ${FrameworkName}"
    )
endmacro()