
message(STATUS "include Basic.cmake")

macro(ReMake_Include FileName)
  ReMake_DefaultLog("include ${FileName}")
  include(${FileName})
endmacro()

# 输出列表
function(ReMake_List_Print)
  cmake_parse_arguments("ARG" "" "TITLE;PREFIX" "STRS" ${ARGN})
  list(LENGTH ARG_STRS strsLength)
  if(NOT strsLength)
    return()
  endif()
  if(NOT ${ARG_TITLE} STREQUAL "")
    ReMake_DefaultLog(${ARG_TITLE})
  endif()
  foreach(str ${ARG_STRS})
    ReMake_DefaultLog("${ARG_PREFIX}${str}")
  endforeach()
endfunction()

# 获取目录名
function(ReMake_GetDirName dirName)
  string(REGEX MATCH "([^/]*)$" TMP ${CMAKE_CURRENT_SOURCE_DIR})
  set(${dirName} ${TMP} PARENT_SCOPE)
endfunction()

# 往回数目录名
function(ReMake_Path_Back rst path times)
  math(EXPR stop "${times}-1")
  set(curPath ${path})
  foreach(index RANGE ${stop})
    string(REGEX MATCH "(.*)/" _ ${curPath})
    set(curPath ${CMAKE_MATCH_1})
  endforeach()
  set(${rst} ${curPath} PARENT_SCOPE)
endfunction()

set(ReMake_GlobalTargetName "GLOBAL")

function(ReMake_ShowIncludeFileName)
    get_filename_component(file_name ${CMAKE_CURRENT_LIST_FILE} NAME)
    ReMake_Log(ReMake_GlobalTargetName "include ${file_name}")
endfunction()

function(ReMake_Log TargetName Msg)
  message(STATUS "[${TargetName}] ${Msg}")
endfunction()

function(ReMake_Warn TargetName Msg)
  message(WARNING "[${TargetName}] ${Msg}")
endfunction()

function(ReMake_Error TargetName Msg)
  message(SEND_ERROR "[${TargetName}] ${Msg}")
endfunction()

function(ReMake_FatalError TargetName Msg)
  message(FATAL_ERROR "[${TargetName}] ${Msg}")
endfunction()

function(ReMake_DefaultLog Msg)
  message(STATUS "[${ReMake_GlobalTargetName}] ${Msg}")
endfunction()

function(ReMake_DefaultWarn Msg)
  message(WARNING "[${ReMake_GlobalTargetName}] ${Msg}")
endfunction()

function(ReMake_DefaultError Msg)
  message(SEND_ERROR "[${ReMake_GlobalTargetName}] ${Msg}")
endfunction()

function(ReMake_DefaultFatalError Msg)
  message(FATAL_ERROR "[${ReMake_GlobalTargetName}] ${Msg}")
endfunction()