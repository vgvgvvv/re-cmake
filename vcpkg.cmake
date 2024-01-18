
ReMake_ShowIncludeFileName()

function(ReMake_VCPkg_GetArch Result)
    if (IS_WINDOWS EQUAL 1)
         set(${Result} "x64-windows" PARENT_SCOPE)
    elseif(IS_MACOS EQUAL 1)
        set(${Result} "arm64-osx" PARENT_SCOPE)
    elseif(IS_LINUX EQUAL 1)
        set(${Result} "x64-linux" PARENT_SCOPE)
    elseif(IS_IOS EQUAL 1)
        set(${Result} "x64-osx" PARENT_SCOPE)
    elseif(IS_ANDROID EQUAL 1)
        set(${Result} "x64-linux" PARENT_SCOPE)
    endif()
endfunction()

macro(ReMake_VCPkg_FindPackage PackageName DownloadName)

    find_package(${PackageName})

    if(NOT ${PackageName}_FOUND)
        ReMake_DefaultWarn("${PackageName} -> ${DownloadName} Not Found Need Download")
        set(ArchType)
        ReMake_VCPkg_GetArch(ArchType)
        ReMake_DefaultLog("Start Download ${DownloadName}:${ArchType}")
        execute_process(COMMAND ${VCPKG_CMD} install ${DownloadName}:${ArchType}
                WORKING_DIRECTORY ${VCPKG_ROOT})
        find_package(${PackageName} REQUIRED)
    else()
        ReMake_DefaultLog("${PackageName} -> ${DownloadName} Found")
    endif()


endmacro()

macro(ReMake_VCPkg_FindPackageWithMode PackageName DownloadName Mode)

    find_package(${PackageName} ${Mode})

    if(NOT ${PackageName}_FOUND)
        ReMake_DefaultWarn("${PackageName} -> ${DownloadName} Not Found Need Download")
        set(ArchType)
        ReMake_VCPkg_GetArch(ArchType)
        ReMake_DefaultLog("Start Download ${DownloadName}:${ArchType}")
        execute_process(COMMAND ${VCPKG_CMD} install ${DownloadName}:${ArchType}
                WORKING_DIRECTORY ${VCPKG_ROOT})
        find_package(${PackageName} ${Mode} REQUIRED)
    else()
        ReMake_DefaultLog("${PackageName} -> ${DownloadName} Found")
    endif()


endmacro()