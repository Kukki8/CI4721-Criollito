#include <iostream>
#include "parser.hpp"
#include "lexer.hpp"
#include "sym_table.h"
#include "error_manager.h"
#include "ast.h"

extern FILE* yyin;
extern ASTNode* root;

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

    // Resetear el contador antes del parse
    yylineno = 1;

    // Parsing
    // yydebug = 1;
    yyin = fopen(argv[1], "r");
    yyparse();

    fclose(yyin);
    printAST(root, 0);
    return 0;
}

void printAST(ASTNode* node, int depth) {
    if (!node) return;
    for (int i = 0; i < depth; i++) std::cout << "  "; 
    std::cout << node->value << std::endl;
    for (ASTNode* child : node->children) {
        printAST(child, depth + 1);
    }
}

