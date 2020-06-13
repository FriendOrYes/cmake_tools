function(pg_makefile_generate modulename targer_source_list shared_libs cpp_flags dir_out)

    file(READ ${PGMakefileTemplate} PG_MAKEFILE)

    string(REPLACE "<modulename>" "${modulename}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<targer_source_list>" "${targer_source_list}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<shared_libs>" "${shared_libs}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<cpp_flags>" "${cpp_flags}" PG_MAKEFILE ${PG_MAKEFILE})

    if ( IS_DIRECTORY ${dir_out} )
        message(dir_out "=${dir_out}")
        file(WRITE ${dir_out}/${modulename}_Makefile ${PG_MAKEFILE})
    else()
        file(WRITE ${modulename}_Makefile ${PG_MAKEFILE})
    endif()

endfunction()