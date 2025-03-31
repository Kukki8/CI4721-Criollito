#include "type_checker.h"
#include <vector>

TypeChecker::TypeChecker(SymTable& symTable) : symTable(symTable) {}

void TypeChecker::check(ASTNode* root) {
    std::vector<int> localScopes;
    localScopes.push_back(1);
    visit(root, localScopes);
}

// Método auxiliar para buscar un símbolo considerando los scopes activos locales.
Symbol local_get_sym(const std::string& id, const std::vector<int>& localScopes, SymTable& symTable) {
    if (symTable.sym_dict.find(id) == symTable.sym_dict.end())
        throw std::runtime_error("Símbolo " + id + " no definido");
    Symbol best("", Variable, -1);
    // Iterar por todas las definiciones del identificador
    for (const Symbol& sym : symTable.sym_dict.at(id)) {
        // Verificar que el scope del símbolo esté en los scopes activos
        if (std::find(localScopes.begin(), localScopes.end(), sym.m_scope) != localScopes.end()) {
            if (sym.m_scope > best.m_scope) best = sym;
        }
    }
    if (best.m_scope == -1)
        throw std::runtime_error("Símbolo " + id + " no disponible en el scope actual");
    return best;
}

SymType TypeChecker::visit(ASTNode* node, std::vector<int>& localScopes) {
    if (!node) return Void;
    switch (node->type) {
        case AST_INT: return Int;
        case AST_FLOAT: return Float;
        case AST_CHAR: return Char;
        case AST_STRING: return Pointer;
        case AST_BOOL: return Bool;
        case AST_ID: {
            Symbol sym = local_get_sym(node->value, localScopes, symTable);
            return sym.m_type;
        }
        case AST_BIN_OP: {
            SymType left = visit(node->children[0], localScopes);
            SymType right = visit(node->children[1], localScopes);
            if (left != right)
                error("¡Epale!, tienes este error: El tipo de " + node->children[0]->value + " (" + symtype_to_str(left) + ") no es el mismo tipo que " + 
                        node->children[1]->value + " (" + symtype_to_str(right) + ")");
            return left;
        }
        case AST_UN_OP: return visit(node->children[0], localScopes);
        case AST_ASSIGNMENT: {
            SymType left = visit(node->children[0], localScopes);
            SymType right = visit(node->children[1], localScopes);
            // Se fuerza a que en la funcion de print no se realice chequeo de tipo
            if (left != right && node->children[1]->value != "rotalo")
                error("¡Epale!, tienes este error: El tipo de " + node->children[0]->value + " (" + symtype_to_str(left) + ") no es el mismo tipo que " + 
                        node->children[1]->value + " (" + symtype_to_str(right) + ")");
            return left;
        }
        case AST_FUNCTION: {
            localScopes.push_back(node->scope);
            visit(node->children[0], localScopes); // Tipo de retorno
            visit(node->children[1], localScopes); // Identificador y apertura de paréntesis
            visit(node->children[2], localScopes); // Lista de parámetros
            SymType retType = visit(node->children[3], localScopes); // Cuerpo
            localScopes.pop_back();
            return retType;
        }
        case AST_FOR:
            localScopes.push_back(node->scope);
            if(node->children[1]->type == AST_ID){
                SymType range = visit(node->children[1], localScopes);
                if(range != Array){
                    error("¡Epale!, tienes este error: El tipo de " + node->children[1]->value + " no es el indicado (bululú)");
                }
                
            }else if(node->children[1]->type == AST_RANGE ){
                SymType init = visit(node->children[0], localScopes);
                SymType end = visit(node->children[1], localScopes);
                if(init != Int || end != Int){
                    error("¡Epale!, tienes este error: Alguno de los límites(o ambos) no es/son el/los indicado/s (lucas)");
                }
            }
            visit(node->children[2], localScopes);
            localScopes.pop_back();
            return Void;
        case AST_WHILE:
            localScopes.push_back(node->scope);
            SymType expression = visit(node->children[1], localScopes);
            if(expression != Bool){
                error("¡Epale!, tienes este error: El tipo de " + node->children[1]->value + " no es el indicado (calidad)");
            }
            visit(node->children[2], localScopes); // Cuerpo del while
            localScopes.pop_back();
            return Void;

        case AST_IF: {
            localScopes.push_back(node->scope);
            for (ASTNode* child : node->children)
                visit(child, localScopes);
            localScopes.pop_back();
            return (node->type == AST_IF ? Bool : Int);
        }
        case AST_FUNCTION_CALL: {
            // Si es la función “rotalo”, se procesa de forma especial.
            if (node->value == "rotalo") {
                if (node->children.size() < 1)
                    error("rotalo: se te olvidó rotarlo, mi pana");
                ASTNode* arg = node->children[0];
                std::string compositeType = "labia[" + arg->value + "]";
                return Array;
            } else {
                if (node->value == "digalo") return Void;
                Symbol funcSym = local_get_sym(node->value, localScopes, symTable);
                return funcSym.m_type;
            }
        }
        case AST_VARIANT: {
            localScopes.push_back(node->scope);
            for (ASTNode* child : node->children[1]->children)
                visit(child, localScopes);
            localScopes.pop_back();
            // Probablemente deba devolver otro tipo
            return Void;
        }
        case AST_REGISTER: {
            localScopes.push_back(node->scope);
            for (ASTNode* child : node->children[1]->children)
                visit(child, localScopes);
            localScopes.pop_back();
            // Probablemente deba devolver otro tipo
            return Void;
        }
        case AST_PAIR_EXPR: {
            localScopes.push_back(node->scope);
            SymType pairType = visit(node->children[0], localScopes);
            visit(node->children[1], localScopes);
            localScopes.pop_back();
            // Devolvemos el tipo del primer hijo, siguiendo la estructura del parser. Sin embargo, esto cambiara para ser su propio tipo en el futuro
            return pairType;
        }
        default:
            for (ASTNode* child : node->children)
                visit(child, localScopes);
            return Int;
    }
}


void TypeChecker::error(const std::string& msg) {
    throw std::runtime_error(msg);
}
