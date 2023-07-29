
macro(ReMake_InitGit)
  ReMake_DefaultLog("----------")
  find_package(Git REQUIRED)
  ReMake_DefaultLog("GIT_FOUND: ${GIT_FOUND}")
  ReMake_DefaultLog("GIT_EXECUTABLE: ${GIT_EXECUTABLE}")
  ReMake_DefaultLog("GIT_VERSION_STRING: ${GIT_VERSION_STRING}")
endmacro()

function(ReMake_UpdateSubModule WorkSpaceDir)
  if(NOT GIT_FOUND)
    ReMake_DefaultFatalError("you should call InitGit() before calling UpdateSubModule()")
  endif()
  execute_process(
    COMMAND ${GIT_EXECUTABLE} submodule init
    #OUTPUT_VARIABLE out
    #OUTPUT_STRIP_TRAILING_WHITESPACE
    #ERROR_QUIET
    WORKING_DIRECTORY ${WorkSpaceDir}
  )
  execute_process(
    COMMAND ${GIT_EXECUTABLE} submodule update
    #OUTPUT_VARIABLE out
    #OUTPUT_STRIP_TRAILING_WHITESPACE
    #ERROR_QUIET
    WORKING_DIRECTORY ${WorkSpaceDir}
  )
endfunction()
