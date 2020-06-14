function(read_makefile_template)
    file(READ ${PGMakefileTemplate} PG_MAKEFILE)

    string(REPLACE ";" " " PG_MAKEFILE_TARGET_SOURCE_LIST "${PG_MAKEFILE_TARGET_SOURCE_LIST}")
    string(REPLACE ";" " " PG_MAKEFILE_SHARED_LIBS "${PG_MAKEFILE_SHARED_LIBS}")
    string(REPLACE ";" " " PG_MAKEFILE_CPP_FLAGS "${PG_MAKEFILE_CPP_FLAGS}")

    string(REPLACE "<modulename>" "${PG_MAKEFILE_MODULENAME}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<targer_source_list>" "${PG_MAKEFILE_TARGET_SOURCE_LIST}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<shared_libs>" "${PG_MAKEFILE_SHARED_LIBS}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<cpp_flags>" "${PG_MAKEFILE_CPP_FLAGS}" PG_MAKEFILE ${PG_MAKEFILE})

    if ( IS_DIRECTORY ${PG_MAKEFILE_DIR_OUT} )
        message(PG_MAKEFILE_DIR_OUT "=${PG_MAKEFILE_DIR_OUT}")
        set(makefile_generated ${PG_MAKEFILE_DIR_OUT}/${PG_MAKEFILE_MODULENAME}_Makefile PARENT_SCOPE)
    else()
        set(makefile_generated ${PG_MAKEFILE_MODULENAME}_Makefile PARENT_SCOPE)
    endif()

    set(PG_MAKEFILE_OUT ${PG_MAKEFILE} PARENT_SCOPE)
endfunction()

function(pg_makefile_plugin_generate)

    cmake_parse_arguments(
        PG_MAKEFILE
        ""
        "MODULENAME;DIR_OUT"
        "TARGET_SOURCE_LIST;SHARED_LIBS;CPP_FLAGS"
        ${ARGN}
    )

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} ${PG_MAKEFILE_OUT})

endfunction()

function(pg_makefile_extention_generate)

    cmake_parse_arguments(
        PG_MAKEFILE
        ""
        "MODULENAME;VERSION;DIR_OUT"
        "TARGET_SOURCE_LIST;SHARED_LIBS;CPP_FLAGS"
        ${ARGN}
    )

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} "EXTENSION = ${PG_MAKEFILE_MODULENAME}\n")
    file(APPEND ${makefile_generated} "DATA = ${PG_MAKEFILE_MODULENAME}--${PG_MAKEFILE_VERSION}.sql\n")

    file(APPEND ${makefile_generated} ${PG_MAKEFILE_OUT})

endfunction()
