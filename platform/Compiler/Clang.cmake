ReMake_ShowIncludeFileName()

if (CPP_COMPILED_BY_CLANG EQUAL 1)

    add_definitions(-DCOMPILED_BY_CLANG=1)

endif ()