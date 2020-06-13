function(read_makefile_template)
    file(READ ${PGMakefileTemplate} PG_MAKEFILE)

    string(REPLACE "<modulename>" "${modulename}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<targer_source_list>" "${targer_source_list}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<shared_libs>" "${shared_libs}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<cpp_flags>" "${cpp_flags}" PG_MAKEFILE ${PG_MAKEFILE})

    if ( IS_DIRECTORY ${dir_out} )
        message(dir_out "=${dir_out}")
        set(makefile_generated ${dir_out}/${modulename}_Makefile PARENT_SCOPE)
    else()
        set(makefile_generated ${modulename}_Makefile PARENT_SCOPE)
    endif()

    set(PG_MAKEFILE_OUT ${PG_MAKEFILE} PARENT_SCOPE)
endfunction()

function(pg_makefile_plugin_generate modulename targer_source_list shared_libs cpp_flags dir_out)

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} ${PG_MAKEFILE_OUT})

endfunction()

function(pg_makefile_extention_generate modulename targer_source_list shared_libs cpp_flags version dir_out)

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} "EXTENSION = ${modulename}\n")
    file(APPEND ${makefile_generated} "DATA = ${modulename}--${version}.sql\n")

    file(APPEND ${makefile_generated} ${PG_MAKEFILE_OUT})

endfunction()


    #cmake_parse_arguments(
    #    COMPLEX_PREFIX
    #    "SINGLE;ANOTHER"
    #    "ONE_VALUE;ALSO_ONE_VALUE"
    #    "MULTI_VALUES"
    #    ${ARGN}
    #)