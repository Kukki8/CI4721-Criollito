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
    std::vector<std::string> errors;
    SymType visit(ASTNode* node, std::vector<int>& localScopes);
    void error(const std::string& msg);
    Symbol local_get_sym(const std::string& id, const std::vector<int>& localScopes, SymTable& symTable);
};

#endif

