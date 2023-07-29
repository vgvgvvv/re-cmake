
function(Json_ListToJsonString InputList OutString)

	set(StrList "")
	foreach(item ${${InputList}})
		list(APPEND StrList "\"${item}\"")
	endforeach()
	
	string(APPEND Result "[\n")
	set(StrListStr "")
	string(JOIN ",\n" StrListStr ${StrList})
	string(APPEND Result ${StrListStr})
	string(APPEND Result "\n]")

	set(${OutString} ${Result} PARENT_SCOPE)

endfunction()