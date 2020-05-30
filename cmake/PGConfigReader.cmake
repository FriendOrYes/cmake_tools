function(pg_config_read)
    execute_process(COMMAND pg_config OUTPUT_VARIABLE PG_CONFIG)
    string(REGEX REPLACE "\n" ";" PG_CONFIG "${PG_CONFIG}")

    foreach(NameAndValue ${PG_CONFIG})
    # Strip leading spaces
    string(REGEX REPLACE "^[ ]+" "" NameAndValue ${NameAndValue})
    # Find variable name
    string(REGEX MATCH "^[^=]+" Name ${NameAndValue})
    # Find the value
    string(REPLACE "${Name}= " "" Value ${NameAndValue})
    # Remove whitespace for names
    string(REGEX REPLACE " " "" Name "${Name}")
    
    message(${Name} "=${Value}")
    # Set the variable
    set(${Name} "${Value}" CACHE INTERNAL "${Value}")
    endforeach()
endfunction()