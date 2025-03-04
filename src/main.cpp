#include <iostream>
#include "parser.hpp"
#include "sym_table.h"

extern FILE* yyin;

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Uso: " << argv[0] << " <archivo de entrada>" << std::endl;
        return 1;
    }

    SymTable symTable = SymTable();

    // Abrir el archivo de entrada
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        std::cerr << "No se pudo abrir el archivo" << std::endl;
        return 1;
    }

    // yydebug = 1;

    // Parsing
    yyparse();

    fclose(yyin);
    return 0;
}

