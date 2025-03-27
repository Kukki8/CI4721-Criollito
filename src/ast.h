#ifndef AST_H
#define AST_H

#include <string>
#include <vector>

enum ASTNodeType {
    AST_PROGRAM,
    AST_STATEMENT,
    AST_EXPRESSION,
    AST_FUNCTION_CALL,
    AST_ASSIGNMENT,
    AST_IF,
    // Creo que faltan mas para el resto de las producciones
};

class ASTNode {
    public:
        ASTNodeType type;
        std::string value; // For literal values or identifiers
        std::vector<ASTNode*> children; // Child nodes

        ASTNode(ASTNodeType t, const std::string& v) : type(t), value(v) {}
        ~ASTNode() {
            for (ASTNode* child : children) {
                delete child;
            }
        }

        void addChild(ASTNode* child) {
            children.push_back(child);
        }
};

#endif
