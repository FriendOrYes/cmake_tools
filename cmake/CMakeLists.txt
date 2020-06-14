cmake_minimum_required (VERSION 3.15.0)

project (generator LANGUAGES CXX)

if(DEFINED SMAKE_PREFIX_PATH)
    SET(CMAKE_PREFIX_PATH ${SMAKE_PREFIX_PATH};${CMAKE_PREFIX_PATH})
endif()

include(PGMakefileGenerator.cmake)

set(modulename "test_modulename")
set(targer_source_list "src/psql_to_mongo.o src/hello_world.o src/hello_world.c")
set(shared_libs "-lpq -ltest pq")
set(include_path "../;test/")
set(cpp_flags "I../")

set(PGMakefileTemplate "PGMakefileTemplate")

pg_makefile_plugin_generate(
    MODULENAME ${modulename}
    TARGET_SOURCE_LIST ${targer_source_list}
    SHARED_LIBS ${shared_libs}
    INCLUDES_PATH ${include_path}
    CPP_FLAGS ${cpp_flags}
    DIR_OUT "")

pg_makefile_extention_generate(
    MODULENAME ${modulename}
    TARGET_SOURCE_LIST ${targer_source_list}
    SHARED_LIBS ${shared_libs}
    INCLUDES_PATH ${include_path}
    CPP_FLAGS ${cpp_flags}
    VERSION "0.0.1"
    DIR_OUT "")

pg_makefile_extention_generate(
    MODULENAME ${modulename}
    TARGET_SOURCE_LIST ${targer_source_list}
    SHARED_LIBS -lpq -ltest pq
    INCLUDES_PATH ${include_path}
    CPP_FLAGS ${cpp_flags}
    VERSION "0.0.1"
    DIR_OUT "")

add_custom_target(extention_install COMMAND make -f ${modulename}_Makefile install
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/psql_to_mongo)
