#ifndef AST_H
#define AST_H

#include <string>
#include <vector>

using namespace std;

enum ASTNodeType {
    AST_PROGRAM,
    AST_STATEMENT,
    AST_EXPRESSION,
    AST_FUNCTION_CALL,
    AST_ASSIGNMENT,
    AST_IF,
    AST_IF_EXPR,
    AST_ELSEIF_LIST,
    AST_ELSEIF,
    AST_ELSE,
    AST_IF_INIT,
    AST_ELSE_INIT,
    AST_ELSEIF_INIT,
    AST_DECLARATION,
    AST_BASETYPE,
    AST_DOT_OPERATOR,
    AST_ID,
    AST_TYPE,
    AST_FUNCTION,
    AST_FUNCTION_INIT,
    AST_PARAM_LIST,
    AST_PARAM,
    AST_ARG_LIST,
    AST_INT,
    AST_FLOAT,
    AST_CHAR,
    AST_STRING,
    AST_BOOL,
    AST_BIN_OP,
    AST_UN_OP,
    AST_ARRAY,
    AST_ARRAY_SIZE,
    AST_ARRAY_SIZE_PARAM,
    AST_PAIR,
    AST_PAIR_EXPR,
    AST_DEREFERENCE,
    AST_VARIANT,
    AST_VARIANT_LIST,
    AST_VARIANT_LIST_ITEM,
    AST_REGISTER,
    AST_REGISTER_LIST,
    AST_REGISTER_ITEM,
    AST_FOR,
    AST_FOR_INIT,
    AST_WHILE,
    AST_WHILE_INIT,
    AST_RANGE,
    AST_RETURN
};

class ASTNode {
public:
    ASTNodeType type;
    string value;
    vector<ASTNode*> children;

    // Declaración del constructor y del destructor.
    ASTNode(ASTNodeType t, const string& v);
    ~ASTNode();

    // Declaración del método para agregar hijos.
    void addChild(ASTNode* child);

    void print(int indent = 0) const;
};

std::string getASTNodeTypeName(ASTNodeType type);

#endif // AST_H

