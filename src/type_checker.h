#ifndef TYPE_CHECKER_H
#define TYPE_CHECKER_H

#include "ast.h"
#include "sym_table.h"
#include <stdexcept>
#include <string>
#include <vector>

class TypeChecker {
public:
    TypeChecker(SymTable& symTable);
    void check(ASTNode* root);
private:
    SymTable& symTable;
    SymType visit(ASTNode* node, std::vector<int>& localScopes);
    void error(const std::string& msg);
};

#endif

