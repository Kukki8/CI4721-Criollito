#include <iostream>
#include "parser.hpp"
#include "lexer.hpp"
#include "sym_table.h"
#include "error_manager.h"

extern FILE* yyin;

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Uso: " << argv[0] << " <archivo de entrada>" << std::endl;
        return 1;
    }

    SymTable symTable = SymTable();

    // Lexical analysis
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        std::cerr << "No se pudo abrir el archivo" << std::endl;
        return 1;
    }
    while(yylex() != 0);
    if (hasErrors()) {
      printErrors();
    }
    fclose(yyin);

    // Reset tracking before parsing
    yylineno = 1;

    // Parsing
    // yydebug = 1;
    yyin = fopen(argv[1], "r");
    yyparse();

    fclose(yyin);
    return 0;
}

