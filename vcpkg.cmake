
ReMake_ShowIncludeFileName()

function(ReMake_VCPkg_GetArch Result)
    if (IS_WINDOWS EQUAL 1)
         set(${Result} "x64-windows" PARENT_SCOPE)
    elseif(IS_MACOS EQUAL 1)
        # TODO
    elseif(IS_LINUX EQUAL 1)
        # TODO
    elseif(IS_MACOS EQUAL 1)
        # TODO
    elseif(IS_IOS EQUAL 1)
        # TODO
    elseif(IS_ANDROID EQUAL 1)
        # TODO
    endif()
endfunction()

macro(ReMake_VCPkg_FindPackage PackageName DownloadName)

    find_package(${PackageName} CONFIG)

    if(NOT ${PackageName}_FOUND)
        message(WARNING "${PackageName} -> ${DownloadName} Not Found Need Download")
        set(ArchType)
        ReMake_VCPkg_GetArch(ArchType)
        message(STATUS "Start Download ${DownloadName}:${ArchType}")
        execute_process(COMMAND ${VCPKG_CMD} install ${DownloadName}:${ArchType}
                WORKING_DIRECTORY ${VCPKG_ROOT})
        find_package(${PackageName} CONFIG REQUIRED)
    else()
        message(STATUS "${PackageName} -> ${DownloadName} Found")
    endif()

endmacro()