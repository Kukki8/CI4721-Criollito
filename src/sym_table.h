#ifndef SYM_TABLE
#define SYM_TABLE

#include <vector>
#include <string>
#include <unordered_map>
#include <vector>
#include <stack>

using namespace std;

// El scope de un simbolo es un int
typedef int Scope; 

// El identificador de un simbolo es un string
typedef string Identifier; 

// Distintas categorias que puede tener un simbolo
enum Category {Variable, Type, Struct, Union, Function};

// Tipos que pueden tener las variables
enum SymType {Int, Float, Bool, Char, Array, Pointer};

// Clase para representar un simbolo
class Symbol{

    public:
        Identifier m_id;
        Category m_category;
        Scope m_scope;
        SymType type;
        // Falta informacion extra que necesita cada simbolo

        // Constructor
        Symbol(Identifier identifier, Category category, Scope scope = -1);
};

// Clase que representa la tabla de simbolos
class SymTable{

    public:
        unordered_map<Identifier, vector<Symbol>> sym_dict;
        stack<Scope> scp_stk;    
        Scope next_scp;

        SymTable();

        int get_current_scope();

        void push_empty_scope();

        void pop_scope();

        void insert_sym(Symbol sym);

        Symbol get_sym(Identifier id);

};

#endif