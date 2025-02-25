#include <iostream>
#include <unordered_map>
#include <stack>
#include <vector>
#include <string>
#include <stdexcept>
#include "sym_table.h"

using namespace std;

Symbol::Symbol(Identifier identifier, Category category, Scope scope){
    m_id = identifier;
    m_category = category;
    m_scope = scope;
}

string str_sym_type(SymType symType){

    string str;
    switch (symType)
    {
    case 0:
        str = "Int";
        break;
    
    case 1:
        str = "Float";
        break;
    
    case 2:
        str = "Bool";
        break;
    
    case 3:
        str = "Char";
        break;
    
    case 4:
        str = "Array";
        break;
    
    case 5:
        str = "Pointer";
        break;

    default:
        str = "";
        break;
    }

    return str;

}

unordered_map<Identifier, vector<Symbol>> init_dict = {};

SymTable::SymTable(){            
    sym_dict = init_dict;
    scp_stk.push(0);
    next_scp = 1;
}

int SymTable::get_current_scope(){      
    return scp_stk.top();        
}

void SymTable::push_empty_scope(){
    scp_stk.push(next_scp);
    next_scp++;
};

void SymTable::pop_scope(){
    if (scp_stk.size() > 2)
    {
        scp_stk.pop();
    }            
};

void SymTable::insert_sym(Symbol sym){

    if (sym_dict.find(sym.m_id) == sym_dict.end() )
    {
        // No hay ninguna entrada con ese identificador

        //Primero le asignamos su scope
        sym.m_scope = get_current_scope();

        // Se crea la nueva entrada y su valor
        vector<Symbol> new_sym_vec = {sym};
        sym_dict[sym.m_id] = new_sym_vec;
    } 
    else 
    {
        // Si ya existe la entrada, revisar que
        // el simbolo no fue creado anteriormente
        Scope best_sym_scp = get_sym(sym.m_id).m_scope;
                
        if (best_sym_scp == get_current_scope())
        {
            throw runtime_error("Symbol already declared: " + sym.m_id);
        }

        // Como no existe otra variable con el mismo nombre 
        // y scope, se agrega al vector
        sym.m_scope = get_current_scope();
        sym_dict[sym.m_id].push_back(sym);
    }
};

Symbol SymTable::get_sym(Identifier id){

    // Iniciamos un simbolo dummy, su scope tendra -1
    Symbol best = Symbol("", Variable);
    Scope act_scope = get_current_scope();

    for (Symbol entry : sym_dict[id])
    {
        if (best.m_scope < entry.m_scope < act_scope)
        {
            // Si el scope del simbolo que vemos es mas 
            // cercano al tope del stack que el scope de best,
            // actualizamos best
            best = entry; 
        }      
    }

    if (best.m_scope == -1)
    {
        // No se encotró el simbolo
        throw runtime_error("Symbol not found: " + id);
    }
            
    return best;
};

void Symbol::print() const {
    cout << "Identifier: " << m_id << ", Category: " << m_category << ", Scope: " << m_scope << endl;
}

void SymTable::print() const {
    cout << "Symbol Table:" << endl;
    for (const auto& entry : sym_dict) {
        cout << "Identifier: " << entry.first << endl;
        for (const auto& symbol : entry.second) {
            symbol.print();
        }
        cout << endl;
    }
}

