#include <iostream>
#include "parser.hpp"
#include "lexer.hpp"
#include "sym_table.h"
#include "error_manager.h"
#include "ast.h"
#include "type_checker.h"
#include <vector>

extern FILE* yyin;
extern ASTNode* root;
extern SymTable symTable;

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Uso: " << argv[0] << " <archivo de entrada>" << std::endl;
        return 1;
    }

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

    if (root) {
      std::cout << "Árbol Sintáctico Abstracto (AST):" << std::endl;
      root->print();

      try {
          TypeChecker checker(symTable);
          checker.check(root);
          std::cout << "Chequear tipos: éxito." << std::endl;
      } catch (const std::runtime_error& e) {
          std::cerr << "Error de tipado: " << e.what() << std::endl;
      }
    } else {
        std::cerr << "Error: El árbol sintáctico no se generó correctamente." << std::endl;
    }

    fclose(yyin);
    return 0;
}
