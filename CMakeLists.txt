cmake_minimum_required(VERSION 3.10)
project(Criollito)

# C++ version
set(CMAKE_CXX_STANDARD 23)

# Packages
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

FLEX_TARGET(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lexer.hpp)
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp COMPILE_FLAGS "-Wcex -v")
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Headers
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(include)

# Copy headers to build directory
file(GLOB HEADER_FILES "src/*.h")
file(COPY ${HEADER_FILES} DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

# Source files
add_executable(
  Criollito
  src/main.cpp 
  src/sym_table.cpp
  src/error_manager.cpp
  src/ast.cpp
  src/type_checker.cpp
  ${FLEX_Lexer_OUTPUTS} 
  ${BISON_Parser_OUTPUTS}
)
