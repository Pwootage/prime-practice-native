# Hanafuda toolchain
set(CMAKE_SYSTEM_NAME powerpc-elf-prime)

set(DEVKITPRO "/opt/devkitpro")
set(DEVKITPPC "/opt/devkitpro/devkitPPC")

# Set toolchain programs
set(CMAKE_C_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-gcc")
set(CMAKE_CXX_COMPILER "${DEVKITPPC}/bin/powerpc-eabi-g++")
#set(CMAKE_C_LINK_EXECUTABLE  "${DEVKITPPC}/bin/powerpc-eabi-ld")
#set(CMAKE_CXX_LINK_EXECUTABLE "${DEVKITPPC}/bin/powerpc-eabi-ld")

# Set triple for CMake's identification
set(triple powerpc-none-unknown-elf)
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})

# Sysroont
#set(CMAKE_SYSROOT "${CMAKE_SOURCE_DIR}")

# Skip test compile (hanafuda has a somewhat unorthodox compiler workflow)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)

# Compile a C file into an object file
set(CMAKE_C_COMPILE_OBJECT "<CMAKE_C_COMPILER> -c <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>")
set(CMAKE_CXX_COMPILE_OBJECT "<CMAKE_CXX_COMPILER> -c <INCLUDES> <FLAGS> -o <OBJECT> <SOURCE>")

# Link object files to an executable
set(CMAKE_C_LINK_EXECUTABLE "${DEVKITPPC}/bin/powerpc-eabi-ld <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <LINK_LIBRARIES> -o <TARGET> <OBJECTS>")
set(CMAKE_CXX_LINK_EXECUTABLE "${DEVKITPPC}/bin/powerpc-eabi-ld <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <LINK_LIBRARIES> -o <TARGET> <OBJECTS>")

# Thing that doesn't work
set(CMAKE_C_OUTPUT_EXTENSION ".o")
set(CMAKE_CXX_OUTPUT_EXTENSION ".o")


#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nostdlib")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -nostdlib")
set(CMAKE_PRIME_C_FLAGS_LIST
        -nostdlib
        #        -nostdinc
        -fno-function-sections
        -fno-data-sections
        -fno-exceptions
        -mno-sdata
        )

set(CMAKE_PRIME_CXX_FLAGS_LIST
        ${CMAKE_PRIME_C_FLAGS_LIST}
        -fno-rtti
        -Wno-delete-incomplete
        )

set(CMAKE_PRIME_LINK_FLAGS_LIST
        "-L${DEVKITPPC}/lib/gcc/powerpc-eabi/10.1.0"
        "-L${DEVKITPPC}/powerpc-eabi/lib"
        -nostdlib
        -nodefaultlibs
        -flto
        -Os
        -lgcc
        -lsysbase
        -r
        -d
        -x
        "-z nocopyreloc"
        -call_shared
        --strip-discarded
        --gc-sections
        "-e _prolog"
        "--unresolved-symbols=ignore-in-object-files"
        "-T ../PrimeAPI/eppc.ld"
        )

list(JOIN CMAKE_PRIME_C_FLAGS_LIST " " CMAKE_PRIME_C_FLAGS)
list(JOIN CMAKE_PRIME_CXX_FLAGS_LIST " " CMAKE_PRIME_CXX_FLAGS)
list(JOIN CMAKE_PRIME_LINK_FLAGS_LIST " " CMAKE_PRIME_LINK_FLAGS)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_PRIME_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_PRIME_CXX_FLAGS}")

include_directories("${DEVKITPRO}/libogc/include/")

# Macro to get the required link arguments in place
macro(add_prime_library name base_dol list_file)
    add_executable(${name}.preplf ${ARGN})
    set_target_properties(${name}.preplf PROPERTIES LINK_FLAGS
        "${CMAKE_PRIME_LINK_FLAGS} -Map ${CMAKE_CURRENT_BINARY_DIR}/${name}.map"
    )
endmacro()