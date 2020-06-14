function(read_makefile_template)
    file(READ ${PGMakefileTemplate} PG_MAKEFILE)

    list(REMOVE_DUPLICATES PG_MAKEFILE_TARGET_SOURCE_LIST)
    list(REMOVE_DUPLICATES PG_MAKEFILE_SHARED_LIBS)
    list(REMOVE_DUPLICATES PG_MAKEFILE_INCLUDES_PATH)
    list(REMOVE_DUPLICATES PG_MAKEFILE_CPP_FLAGS)

    foreach(lib ${PG_MAKEFILE_SHARED_LIBS})
        if(NOT ${lib} MATCHES "-l|[.]+(so|a)")
            list(REMOVE_ITEM PG_MAKEFILE_SHARED_LIBS ${lib})
            set(lib "-l${lib}")
            list(APPEND PG_MAKEFILE_SHARED_LIBS ${lib})
        endif()
    endforeach()

    string(REPLACE ".c" ".o" PG_MAKEFILE_TARGET_SOURCE_LIST "${PG_MAKEFILE_TARGET_SOURCE_LIST}")

    string(REPLACE ";" " " PG_MAKEFILE_TARGET_SOURCE_LIST "${PG_MAKEFILE_TARGET_SOURCE_LIST}")
    string(REPLACE ";" " " PG_MAKEFILE_SHARED_LIBS "${PG_MAKEFILE_SHARED_LIBS}")
    string(REPLACE ";" " " PG_MAKEFILE_CPP_FLAGS "${PG_MAKEFILE_CPP_FLAGS}")

    string(REPLACE "<modulename>" "${PG_MAKEFILE_MODULENAME}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<targer_source_list>" "${PG_MAKEFILE_TARGET_SOURCE_LIST}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<shared_libs>" "${PG_MAKEFILE_SHARED_LIBS}" PG_MAKEFILE ${PG_MAKEFILE})
    string(REPLACE "<cpp_flags>" "${PG_MAKEFILE_CPP_FLAGS}" PG_MAKEFILE ${PG_MAKEFILE})

############# PG_MAKEFILE_INCLUDES_PATH
    foreach(include_path ${PG_MAKEFILE_INCLUDES_PATH})
        if(NOT ${include_path} MATCHES "^-I")
            list(REMOVE_ITEM PG_MAKEFILE_INCLUDES_PATH ${include_path})
            set(include_path "-I${include_path}")
            list(APPEND PG_MAKEFILE_INCLUDES_PATH ${include_path})
        endif()
    endforeach()

    if(PG_MAKEFILE_INCLUDES_PATH)
        string(REPLACE ";" " " PG_MAKEFILE_INCLUDES_PATH "${PG_MAKEFILE_INCLUDES_PATH}")
        string(REPLACE "<includes_path>" "${PG_MAKEFILE_INCLUDES_PATH}" PG_MAKEFILE ${PG_MAKEFILE})
    else()
        string(REPLACE "<includes_path>" "" PG_MAKEFILE ${PG_MAKEFILE})
    endif()
############# PG_MAKEFILE_SHARED_LIBS_PATH
    foreach(shared_lib_path ${PG_MAKEFILE_SHARED_LIBS_PATH})
        if(NOT ${shared_lib_path} MATCHES "^-L")
            list(REMOVE_ITEM PG_MAKEFILE_SHARED_LIBS_PATH ${shared_lib_path})
            set(shared_lib_path "-L${shared_lib_path}")
            list(APPEND PG_MAKEFILE_SHARED_LIBS_PATH ${shared_lib_path})
        endif()
    endforeach()

    if(PG_MAKEFILE_SHARED_LIBS_PATH)
        string(REPLACE ";" " " PG_MAKEFILE_SHARED_LIBS_PATH "${PG_MAKEFILE_SHARED_LIBS_PATH}")
        string(REPLACE "<shared_libs_path>" "${PG_MAKEFILE_SHARED_LIBS_PATH}" PG_MAKEFILE ${PG_MAKEFILE})
    else()
        string(REPLACE "<shared_libs_path>" "" PG_MAKEFILE ${PG_MAKEFILE})
    endif()
############# PG_MAKEFILE_LIBS
    foreach(lib ${PG_MAKEFILE_LIBS})
        if(NOT ${lib} MATCHES "-l|[.]+(so|a)")
            list(REMOVE_ITEM PG_MAKEFILE_LIBS ${lib})
            set(lib "-l${lib}")
            list(APPEND PG_MAKEFILE_LIBS ${lib})
        endif()
    endforeach()

    if(PG_MAKEFILE_LIBS)
        string(REPLACE ";" " " PG_MAKEFILE_LIBS "${PG_MAKEFILE_LIBS}")
        string(REPLACE "<libs>" "${PG_MAKEFILE_LIBS}" PG_MAKEFILE ${PG_MAKEFILE})
    else()
        string(REPLACE "<libs>" "" PG_MAKEFILE ${PG_MAKEFILE})
    endif()
############# PG_MAKEFILE_LIBS_PATH
    foreach(lib_path ${PG_MAKEFILE_LIBS_PATH})
        if(NOT ${lib_path} MATCHES "^-L")
            list(REMOVE_ITEM PG_MAKEFILE_LIBS_PATH ${lib_path})
            set(lib_path "-L${lib_path}")
            list(APPEND PG_MAKEFILE_LIBS_PATH ${lib_path})
        endif()
    endforeach()

    if(PG_MAKEFILE_LIBS_PATH)
        string(REPLACE ";" " " PG_MAKEFILE_LIBS_PATH "${PG_MAKEFILE_LIBS_PATH}")
        string(REPLACE "<libs_path>" "${PG_MAKEFILE_LIBS_PATH}" PG_MAKEFILE ${PG_MAKEFILE})
    else()
        string(REPLACE "<libs_path>" "" PG_MAKEFILE ${PG_MAKEFILE})
    endif()
#############
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
        "TARGET_SOURCE_LIST;SHARED_LIBS;SHARED_LIBS_PATH;LIBS;LIBS_PATH;INCLUDES_PATH;CPP_FLAGS"
        ${ARGN}
    )

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} ${PG_MAKEFILE_OUT})

    set(makefile_generated ${makefile_generated} PARENT_SCOPE)
endfunction()

function(pg_makefile_extention_generate)

    cmake_parse_arguments(
        PG_MAKEFILE
        ""
        "MODULENAME;VERSION;DIR_OUT"
        "TARGET_SOURCE_LIST;SHARED_LIBS;SHARED_LIBS_PATH;LIBS;LIBS_PATH;INCLUDES_PATH;CPP_FLAGS"
        ${ARGN}
    )

    unset(PG_MAKEFILE_OUT)

    read_makefile_template()

    file(WRITE ${makefile_generated} "EXTENSION = ${PG_MAKEFILE_MODULENAME}\n")
    file(APPEND ${makefile_generated} "DATA = ${PG_MAKEFILE_MODULENAME}--${PG_MAKEFILE_VERSION}.sql\n")

    file(APPEND ${makefile_generated} ${PG_MAKEFILE_OUT})

    set(makefile_generated ${makefile_generated} PARENT_SCOPE)
endfunction()
