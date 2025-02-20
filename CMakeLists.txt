cmake_minimum_required(VERSION 3.10)
project(Criollito)

# C++ version
set(CMAKE_CXX_STANDARD 11)

# Packages
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

FLEX_TARGET(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp COMPILE_FLAGS -Wcex)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Headers
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(include)

# Source files
add_executable(Criollito src/main.cpp ${FLEX_Lexer_OUTPUTS} ${BISON_Parser_OUTPUTS})

