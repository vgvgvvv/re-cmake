
ReMake_ShowIncludeFileName()

# 是否为根工程
function(IsRootProject Result)
    if(${REMAKE_ROOT_PATH} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
        set(${Result} TRUE PARENT_SCOPE)
    else()
        set(${Result} FALSE PARENT_SCOPE)
    endif()
endfunction()

# 添加子文件夹文件
function(ReMake_AddSubDirsRec path)

    set(IsRoot "")
    IsRootProject(IsRoot)

    if(${IsRoot})
	    message(STATUS "IsRoot Project Add Sub Directories")
    else()
	    message(STATUS "Not Root Project Skip Add Sub Directories")
        return()
    endif()

    file(GLOB_RECURSE children LIST_DIRECTORIES true ${CMAKE_CURRENT_SOURCE_DIR}/${path}/*)
    set(dirs "")
    list(APPEND children "${CMAKE_CURRENT_SOURCE_DIR}/${path}")
    foreach(item ${children})
        if(IS_DIRECTORY ${item} AND EXISTS "${item}/CMakeLists.txt")
            set(isVendor -1)
            string(FIND ${item} "vendor" isVendor)
            if(${isVendor} GREATER -1)
                message(STATUS "ignore vendor ${item}")
            else()
                # 加入子文件夹的同时 添加include文件夹
                include_directories(${item})
                list(APPEND dirs ${item})
            endif()
        endif()
    endforeach()
    foreach(dir ${dirs})
    add_subdirectory(${dir})
    endforeach()
endfunction()

# 获取目标名
function(ReMake_GetTargetName rst targetPath)
  file(RELATIVE_PATH targetRelPath "${PROJECT_SOURCE_DIR}/src" "${targetPath}")
  string(REPLACE "/" "_" targetName "${PROJECT_NAME}_${targetRelPath}")
  set(${rst} ${targetName} PARENT_SCOPE)
endfunction()

# 获取源文件
function(ReMake_ExpandSources rst sources)

    set(tmp_rst "")
    foreach(item ${${sources}})
        if(IS_DIRECTORY ${item})
            file(GLOB_RECURSE itemSrcs
                # cmake
                ${item}/*.cmake

                # INTERFACEer files
                ${item}/*.h
                ${item}/*.hpp
                ${item}/*.hxx
                ${item}/*.inl

                # source files
                ${item}/*.c

                ${item}/*.cc
                ${item}/*.cpp
                ${item}/*.cxx
            )
            list(APPEND tmp_rst ${itemSrcs})
            if(USE_OBJECTIVE_C EQUAL 1)
                file(GLOB_RECURSE OCItemSrcs
                        # cmake
                        ${item}/*.m
                        ${item}/*.mm
                        ${item}/*.xib
                        )
                list(APPEND tmp_rst ${OCItemSrcs})
            endif()
        else()
            if(NOT IS_ABSOLUTE "${item}")
                get_filename_component(item "${item}" ABSOLUTE)
            endif()
            list(CMAKE_<LANG>_ARCHIVE_APPEND tmp_rst ${item})
        endif()
    endforeach()
    set(${rst} ${tmp_rst} PARENT_SCOPE)
endfunction()


# [option]
# TEST
#
# [value]
# 目标名
# TARGET_NAME：
# 模式
# MODE: EXE / STATIC / SHARED / INTERFACE / STATIC_AND_SHARED
# 将当前目录源文件加入到
# ADD_CURRENT_TO: PUBLIC / INTERFACE / PRIVATE (default) / NONE
# RET_TARGET_NAME
# CXX_STANDARD: 11/14/17/20, default is global CXX_STANDARD (20)
# PCH_REUSE_FROM
#
# [list] : public, interface, private
# SOURCE: dir(recursive), file, auto add currunt dir | target_sources
# INC: dir                                           | target_include_directories
# LIB: <lib-target>, *.lib                           | target_link_libraries
# DEFINE: #define ...                                | target_compile_definitions
# C_OPTION: compile options                          | target_compile_options
# L_OPTION: link options                             | target_link_options
# PCH: precompile headers                            | target_precompile_headers
function(ReMake_AddTarget)

    message(STATUS "----------")
    message(STATUS "Add Target")
    set(arglist "")
    # public
    list(APPEND arglist
        SOURCE_PUBLIC
        INC
        LIB
        DEFINE
        C_OPTION
        L_OPTION
        PCH_PUBLIC)
    # interface
    list(APPEND arglist
        SOURCE_INTERFACE
        INC_INTERFACE
        LIB_INTERFACE
        DEFINE_INTERFACE
        C_OPTION_INTERFACE
        L_OPTION_INTERFACE
        PCH_INTERFACE)
    # private
    list(APPEND arglist
        SOURCE
        INC_PRIVATE
        LIB_PRIVATE
        DEFINE_PRIVATE
        C_OPTION_PRIVATE
        L_OPTION_PRIVATE
        PCH)

     list(APPEND arglist
        ADD_OPTIONS)

    cmake_parse_arguments(
        "ARG"
        "TEST;USE_OBJECTIVE_C"
        "TARGET_NAME;MODE;ADD_CURRENT_TO;CXX_STANDARD"
        "${arglist}"
        ${ARGN}
    )

    if("${ARG_ADD_CURRENT_TO}" STREQUAL "")
        set(ARG_ADD_CURRENT_TO "PRIVATE")
    endif()

    if(ARG_USE_OBJECTIVE_C)
        set(USE_OBJECTIVE_C 1)
    endif()


    # 当为Interface时需要将private与public加入到interface里面
    # public, private -> interface
    if("${ARG_MODE}" STREQUAL "INTERFACE")
        list(APPEND ARG_SOURCE_INTERFACE   ${ARG_SOURCE_PUBLIC} ${ARG_SOURCE}          )
        list(APPEND ARG_INC_INTERFACE      ${ARG_INC}           ${ARG_INC_PRIVATE}     )
        list(APPEND ARG_LIB_INTERFACE      ${ARG_LIB}           ${ARG_LIB_PRIVATE}     )
        list(APPEND ARG_DEFINE_INTERFACE   ${ARG_DEFINE}        ${ARG_DEFINE_PRIVATE}  )
        list(APPEND ARG_C_OPTION_INTERFACE ${ARG_C_OPTION}      ${ARG_C_OPTION_PRIVATE})
        list(APPEND ARG_L_OPTION_INTERFACE ${ARG_L_OPTION}      ${ARG_L_OPTION_PRIVATE})
        list(APPEND ARG_PCH_INTERFACE      ${ARG_PCH_PUBLIC}    ${ARG_PCH}             )
        set(ARG_SOURCE_PUBLIC    "")
        set(ARG_SOURCE           "")
        set(ARG_INC              "")
        set(ARG_INC_PRIVATE      "")
        set(ARG_LIB              "")
        set(ARG_LIB_PRIVATE      "")
        set(ARG_DEFINE           "")
        set(ARG_DEFINE_PRIVATE   "")
        set(ARG_C_OPTION         "")
        set(ARG_C_OPTION_PRIVATE "")
        set(ARG_L_OPTION         "")
        set(ARG_L_OPTION_PRIVATE "")
        set(ARG_PCH_PUBLIC       "")
        set(ARG_PCH              "")

        if(NOT "${ARG_ADD_CURRENT_TO}" STREQUAL "NONE")
            set(ARG_ADD_CURRENT_TO "INTERFACE")
        endif()
    endif()

    # sources
    if("${ARG_ADD_CURRENT_TO}" STREQUAL "PUBLIC")
        list(APPEND ARG_SOURCE_PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    elseif("${ARG_ADD_CURRENT_TO}" STREQUAL "INTERFACE")
        list(APPEND ARG_SOURCE_INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
    elseif("${ARG_ADD_CURRENT_TO}" STREQUAL "PRIVATE")
        list(APPEND ARG_SOURCE ${CMAKE_CURRENT_SOURCE_DIR})
    elseif(NOT "${ARG_ADD_CURRENT_TO}" STREQUAL "NONE")
        message(FATAL_ERROR "ADD_CURRENT_TO [${ARG_ADD_CURRENT_TO}] is not supported")
    endif()

    ReMake_ExpandSources(sources_public ARG_SOURCE_PUBLIC)
    ReMake_ExpandSources(sources_interface ARG_SOURCE_INTERFACE)
    ReMake_ExpandSources(sources_private ARG_SOURCE)



    # target folder
    file(RELATIVE_PATH targetRelPath "${PROJECT_SOURCE_DIR}/src" "${CMAKE_CURRENT_SOURCE_DIR}/..")
    set(targetFolder "${PROJECT_NAME}/${targetRelPath}")

    if("${ARG_TARGET_NAME}" STREQUAL "")
        ReMake_GetTargetName(coreTargetName ${CMAKE_CURRENT_SOURCE_DIR})
    else()
        set(coreTargetName ${ARG_TARGET_NAME})
    endif()


    if(NOT "${ARG_RETURN_TARGET_NAME}" STREQUAL "")
        set(${ARG_RETURN_TARGET_NAME} ${coreTargetName} PARENT_SCOPE)
    endif()



    # print
    message(STATUS "- name: ${coreTargetName}")
    message(STATUS "- folder : ${targetFolder}")
    message(STATUS "- mode: ${ARG_MODE}")

    REMAKE_LIST_PRINT(STRS ${sources_private}
    TITLE  "- sources (private):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${sources_interface}
    TITLE  "- sources interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${sources_public}
    TITLE  "- sources public:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE}
    TITLE  "- define (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE_PRIVATE}
    TITLE  "- define interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE_INTERFACE}
    TITLE  "- define private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_LIB}
    TITLE  "- lib (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_LIB_INTERFACE}
    TITLE  "- lib interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_LIB_PRIVATE}
    TITLE  "- lib private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_INC}
    TITLE  "- inc (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_INC_INTERFACE}
    TITLE  "- inc interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_INC_PRIVATE}
    TITLE  "- inc private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE}
    TITLE  "- define (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE_INTERFACE}
    TITLE  "- define interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_DEFINE_PRIVATE}
    TITLE  "- define private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_C_OPTION}
    TITLE  "- compile option (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_C_OPTION_INTERFACE}
    TITLE  "- compile option interface:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_C_OPTION_PRIVATE}
    TITLE  "- compile option private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_L_OPTION}
    TITLE  "- link option (public):"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    ReMake_List_Print(STRS ${ARG_L_OPTION_INTERFACE}
    TITLE  "- link option interface:"
    PREFIX "  * ")
    ReMake_List_Print(STRS ${ARG_L_OPTION_PRIVATE}
    TITLE  "- link option private:"
    PREFIX "  * "
    TAG ${ARG_TARGET_NAME})
    if("${ARG_MODE}" STREQUAL "EXE")
        add_executable(${coreTargetName})
        if(MSVC)
			set_target_properties(${ARG_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/bin")
		endif()
        # set_target_properties(${coreTargetName} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
        # set_target_properties(${coreTargetName} PROPERTIES MINSIZEREL_POSTFIX ${CMAKE_MINSIZEREL_POSTFIX})
        # set_target_properties(${coreTargetName} PROPERTIES RELWITHDEBINFO_POSTFIX ${CMAKE_RELWITHDEBINFO_POSTFIX})
        target_compile_definitions(${coreTargetName} PRIVATE COMPILE_AS_EXE)
    elseif("${ARG_MODE}" STREQUAL "STATIC")
        add_library(${coreTargetName} STATIC)
        target_compile_definitions(${coreTargetName} PRIVATE COMPILE_AS_STATIC_LIB)
    elseif("${ARG_MODE}" STREQUAL "SHARED")
        add_library(${coreTargetName} SHARED)
        target_compile_definitions(${coreTargetName} PRIVATE COMPILE_AS_SHARED_LIB)
        GENERATE_EXPORT_HEADER( ${coreTargetName}
             BASE_NAME ${coreTargetName}
             EXPORT_MACRO_NAME ${coreTargetName}_API
             EXPORT_FILE_NAME ${CMAKE_CURRENT_LIST_DIR}/${coreTargetName}_API.h
             STATIC_DEFINE ${coreTargetName}_BUILT_AS_STATIC)
    elseif("${ARG_MODE}" STREQUAL "INTERFACE")
        add_library(${coreTargetName} INTERFACE)
    else()
        message(FATAL_ERROR "mode [${ARG_MODE}] is not supported")
        return()
    endif()

    if(ARG_USE_OBJECTIVE_C)
        ReMake_SetupObjectiveC(${coreTargetName})
    endif()

    set(targetName ${coreTargetName})

    if(NOT "${ARG_CXX_STANDARD}" STREQUAL "")
      set_property(TARGET ${targetName} PROPERTY CXX_STANDARD ${ARG_CXX_STANDARD})
      message(STATUS "- CXX_STANDARD : ${ARG_CXX_STANDARD}")
    endif()

    # folder
    if(NOT ${ARG_MODE} STREQUAL "INTERFACE")
      set_target_properties(${targetName} PROPERTIES FOLDER ${targetFolder})
    endif()

    foreach(src ${sources_public})
        get_filename_component(abs_src ${src} ABSOLUTE)
        target_sources(${targetName} PUBLIC ${abs_src})
    endforeach()

    foreach(src ${sources_private})
        get_filename_component(abs_src ${src} ABSOLUTE)
        target_sources(${targetName} PRIVATE ${abs_src})
    endforeach()

    foreach(src ${sources_interface})
        get_filename_component(abs_src ${src} ABSOLUTE)
        target_sources(${targetName} INTERFACE ${abs_src})
    endforeach()

    foreach(inc ${ARG_INC})
      get_filename_component(abs_inc ${inc} ABSOLUTE)
      target_include_directories(${targetName} PUBLIC ${abs_inc} ".")
    endforeach()
    foreach(inc ${ARG_INC_PRIVATE})
      get_filename_component(abs_inc ${inc} ABSOLUTE)
      target_include_directories(${targetName} PRIVATE ${abs_inc} ".")
    endforeach()
    foreach(inc ${ARG_INC_INTERFACE})
      get_filename_component(abs_inc ${inc} ABSOLUTE)
      target_include_directories(${targetName} INTERFACE ${abs_inc} ".")
    endforeach()

     # target define
    target_compile_definitions(${targetName}
      PUBLIC ${ARG_DEFINE}
      INTERFACE ${ARG_DEFINE_INTERFACE}
      PRIVATE ${ARG_DEFINE_PRIVATE}
    )

     # target lib
    target_link_libraries(${targetName}
      PUBLIC ${ARG_LIB}
      INTERFACE ${ARG_LIB_INTERFACE}
      PRIVATE ${ARG_LIB_PRIVATE}
    )

    # target compile option
    target_compile_options(${targetName}
      PUBLIC ${ARG_C_OPTION}
      INTERFACE ${ARG_C_OPTION_INTERFACE}
      PRIVATE ${ARG_C_OPTION_PRIVATE}
    )

    # target link option
    target_link_options(${targetName}
      PUBLIC ${ARG_L_OPTION}
      INTERFACE ${ARG_L_OPTION_INTERFACE}
      PRIVATE ${ARG_L_OPTION_PRIVATE}
    )

    # target pch
    target_precompile_headers(${targetName}
      PUBLIC ${ARG_PCH_PUBLIC}
      INTERFACE ${ARG_PCH_INTERFACE}
      PRIVATE ${ARG_PCH}
    )

    message(STATUS "----------")

    message(STATUS "generate module info...")

    string(APPEND TargetArgs "{\n")
    string(APPEND TargetArgs "  \"targetName\" : \"${targetName}\",\n" )
    string(APPEND TargetArgs "  \"mode\" : \"${ARG_MODE}\",\n" )

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_INC TempList)
    string(APPEND TargetArgs "  \"public_include\" : ${TempList},\n")
    Json_ListToJsonString(ARG_INC_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_include\" : ${TempList},\n")
    Json_ListToJsonString(ARG_INC_PRIVATE TempList)
    string(APPEND TargetArgs "  \"private_include\" : ${TempList},\n")

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(sources_public TempList)
    string(APPEND TargetArgs "  \"public_source\" : ${TempList},\n")
    Json_ListToJsonString(sources_interface TempList)
    string(APPEND TargetArgs "  \"interface_source\" : ${TempList},\n")
    Json_ListToJsonString(sources_private TempList)
    string(APPEND TargetArgs "  \"private_source\" : ${TempList},\n")

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_C_OPTION TempList)
    string(APPEND TargetArgs "  \"public_compile_options\" : ${TempList},\n")
    Json_ListToJsonString(ARG_C_OPTION_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_compile_options\" : ${TempList},\n")
    Json_ListToJsonString(ARG_C_OPTION_PRIVATE TempList)
    string(APPEND TargetArgs "  \"private_compile_options\" : ${TempList},\n")

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_L_OPTION TempList)
    string(APPEND TargetArgs "  \"public_link_options\" : ${TempList},\n")
    Json_ListToJsonString(ARG_L_OPTION_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_link_options\" : ${TempList},\n")
    Json_ListToJsonString(ARG_L_OPTION_PRIVATE TempList)
    string(APPEND TargetArgs "  \"private_link_options\" : ${TempList},\n")

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_PCH_PUBLIC TempList)
    string(APPEND TargetArgs "  \"public_pch\" : ${TempList},\n")
    Json_ListToJsonString(ARG_PCH_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_pch\" : ${TempList},\n")
    Json_ListToJsonString(ARG_PCH TempList)
    string(APPEND TargetArgs "  \"private_pch\" : ${TempList},\n")

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_LIB TempList)
    string(APPEND TargetArgs "  \"public_lib\" : ${TempList},\n" )
    Json_ListToJsonString(ARG_LIB_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_lib\" : ${TempList},\n" )
    Json_ListToJsonString(ARG_LIB_PRIVATE TempList)
    string(APPEND TargetArgs "  \"private_lib\" : ${TempList},\n" )

    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_DEFINE TempList)
    string(APPEND TargetArgs "  \"public_define\" : ${TempList},\n" )
    Json_ListToJsonString(ARG_DEFINE_INTERFACE TempList)
    string(APPEND TargetArgs "  \"interface_define\" : ${TempList},\n" )
    Json_ListToJsonString(ARG_DEFINE_PRIVATE TempList)
    string(APPEND TargetArgs "  \"private_define\" : ${TempList},\n" )
    string(APPEND TargetArgs "  \n" )

    Json_ListToJsonString(ARG_ADD_OPTIONS TempList)
    string(APPEND TargetArgs "  \"add_options\" : ${TempList}\n" )

    string(APPEND TargetArgs "}\n")

    write_file(${CMAKE_CURRENT_SOURCE_DIR}/${targetName}.Target.json ${TargetArgs})

    message(STATUS "----------")
endfunction()