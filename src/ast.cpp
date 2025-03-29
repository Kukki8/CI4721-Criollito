#include "ast.h"
#include <iostream>

ASTNode::ASTNode(ASTNodeType t, const string& v)
    : type(t), value(v) {
}

// El destructor ya elimina recursivamente a los hijos.
ASTNode::~ASTNode() {
    for (ASTNode* child : children)
        delete child;
}

void ASTNode::addChild(ASTNode* child) {
    children.push_back(child);
}

#include <string>

#include <string>

std::string getASTNodeTypeName(ASTNodeType type) {
    switch(type) {
        case AST_PROGRAM:                 return "AST_PROGRAM";
        case AST_STATEMENT:               return "AST_STATEMENT";
        case AST_EXPRESSION:              return "AST_EXPRESSION";
        case AST_FUNCTION_CALL:           return "AST_FUNCTION_CALL";
        case AST_ASSIGNMENT:              return "AST_ASSIGNMENT";
        case AST_IF:                      return "AST_IF";
        case AST_IF_EXPR:                 return "AST_IF_EXPR";
        case AST_ELSEIF_LIST:             return "AST_ELSEIF_LIST";
        case AST_ELSEIF:                  return "AST_ELSEIF";
        case AST_ELSE:                    return "AST_ELSE";
        case AST_IF_INIT:                 return "AST_IF_INIT";
        case AST_ELSE_INIT:               return "AST_ELSE_INIT";
        case AST_ELSEIF_INIT:             return "AST_ELSEIF_INIT";
        case AST_DECLARATION:             return "AST_DECLARATION";
        case AST_BASETYPE:                return "AST_BASETYPE";
        case AST_DOT_OPERATOR:            return "AST_DOT_OPERATOR";
        case AST_ID:                      return "AST_ID";
        case AST_TYPE:                    return "AST_TYPE";
        case AST_FUNCTION:                return "AST_FUNCTION";
        case AST_FUNCTION_INIT:           return "AST_FUNCTION_INIT";
        case AST_PARAM_LIST:              return "AST_PARAM_LIST";
        case AST_PARAM:                   return "AST_PARAM";
        case AST_ARG_LIST:                return "AST_ARG_LIST";
        case AST_INT:                     return "AST_INT";
        case AST_FLOAT:                   return "AST_FLOAT";
        case AST_CHAR:                    return "AST_CHAR";
        case AST_STRING:                  return "AST_STRING";
        case AST_BOOL:                    return "AST_BOOL";
        case AST_BIN_OP:                  return "AST_BIN_OP";
        case AST_UN_OP:                   return "AST_UN_OP";
        case AST_ARRAY:                   return "AST_ARRAY";
        case AST_ARRAY_SIZE:              return "AST_ARRAY_SIZE";
        case AST_ARRAY_SIZE_PARAM:        return "AST_ARRAY_SIZE_PARAM";
        case AST_PAIR:                    return "AST_PAIR";
        case AST_PAIR_EXPR:               return "AST_PAIR_EXPR";
        case AST_DEREFERENCE:             return "AST_DEREFERENCE";
        case AST_VARIANT:                 return "AST_VARIANT";
        case AST_VARIANT_LIST:            return "AST_VARIANT_LIST";
        case AST_VARIANT_LIST_ITEM:       return "AST_VARIANT_LIST_ITEM";
        case AST_REGISTER:                return "AST_REGISTER";
        case AST_REGISTER_LIST:           return "AST_REGISTER_LIST";
        case AST_REGISTER_ITEM:           return "AST_REGISTER_ITEM";
        case AST_FOR:                     return "AST_FOR";
        case AST_FOR_INIT:                return "AST_FOR_INIT";
        case AST_WHILE:                   return "AST_WHILE";
        case AST_WHILE_INIT:              return "AST_WHILE_INIT";
        case AST_RANGE:                   return "AST_RANGE";
        case AST_RETURN:                  return "AST_RETURN";
        default:                          return "UNKNOWN";
    }
}


void ASTNode::print(int indent) const {
    for (int i = 0; i < indent; ++i) {
        std::cout << "  ";  // Dos espacios por nivel de indentación.
    }
    
    std::cout << value << " (" << getASTNodeTypeName(type) << ")" << "\n";
    
    // Recorre e imprime recursivamente a los hijos.
    for (const ASTNode* child : children) {
        child->print(indent + 1);
    }
}

