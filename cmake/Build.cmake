
message(STATUS "include Build.cmake")

# 添加子文件夹文件
function(AddSubDirsRec path)
  file(GLOB_RECURSE children LIST_DIRECTORIES true ${CMAKE_CURRENT_SOURCE_DIR}/${path}/*)
  set(dirs "")
  list(APPEND children "${CMAKE_CURRENT_SOURCE_DIR}/${path}")
  foreach(item ${children})
    if(IS_DIRECTORY ${item} AND EXISTS "${item}/CMakeLists.txt")
      list(APPEND dirs ${item})
    endif()
  endforeach()
  foreach(dir ${dirs})
    add_subdirectory(${dir})
  endforeach()
endfunction()

# 获取目标名
function(GetTargetName rst targetPath)
  file(RELATIVE_PATH targetRelPath "${PROJECT_SOURCE_DIR}/src" "${targetPath}")
  string(REPLACE "/" "_" targetName "${PROJECT_NAME}_${targetRelPath}")
  set(${rst} ${targetName} PARENT_SCOPE)
endfunction()