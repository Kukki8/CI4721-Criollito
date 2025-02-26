#include <iostream>
#include <unordered_map>
#include <stack>
#include <vector>
#include <string>
#include <stdexcept>
#include <algorithm>
#include "tabulate.h"
#include "sym_table.h"

using namespace std;
using namespace tabulate;

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

string str_sym_category(Category category){

    string str;
    switch (category)
    {
    case 0:
        str = "Variable";
        break;
    
    case 1:
        str = "Type";
        break;
    
    case 2:
        str = "Struct";
        break;
    
    case 3:
        str = "Union";
        break;
    
    case 4:
        str = "Function";
        break;
    
    default:
        str = "";
        break;
    }

    return str;

}

unordered_map<Identifier, vector<Symbol>> init_dict = {
    {"Int",     {Symbol("Int",      Type, 0)}},
    {"Float",   {Symbol("Float",    Type, 0)}},
    {"Bool",    {Symbol("Bool",     Type, 0)}},
    {"Char",    {Symbol("Char",     Type, 0)}},
    {"Array",   {Symbol("Array",    Type, 0)}},
    {"Pointer", {Symbol("Pointer",  Type, 0)}},
    {"Read",    {Symbol("Read",     Type, 0)}},
    {"Print",   {Symbol("Print",    Type, 0)}},
};

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
        // Existe la entrada en el diccionario
        // Revisemos los simbolos
        Scope best_sym_scp;
        try {
            best_sym_scp = get_sym(sym.m_id).m_scope;
        } catch (runtime_error err) {
            // No se encontro un simbolo con scope aun en la pila
            // Por tanto, lo agregamos sin problemas
            sym.m_scope = get_current_scope();
            sym_dict[sym.m_id].push_back(sym);
        };

        // Se encontró un simbolo con scope aun en la pila
        // Revisemos que no esté en el scope actual
        if (best_sym_scp == get_current_scope())
        {
            throw runtime_error("Symbol already declared: " + sym.m_id);
        }

        // Como no se existe este simbolo con el scope actual, se agrega
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
        if (best.m_scope < entry.m_scope && entry.m_scope <= act_scope)
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

// Version de Monascal
// Symbol SymTable::get_sym(Identifier id){

//     Symbol* best = NULL;
//     Symbol* pervasive = NULL;

//     for(Symbol e: sym_dict[id]){
//         if(e.m_id == id){
//             if(e.m_scope == 0){
//                 pervasive = &e;
//             }else{
//                 stack <Scope> cp_stk;
//                 cp_stk = scp_stk;

//                 cout << "He llegado " << id <<  endl;

//                 while(!cp_stk.empty()){
//                     cout << cp_stk.size() << endl;
//                     Scope s = cp_stk.top();
//                     cp_stk.pop();

//                     if(s == e.m_scope){
//                         best = &e;
//                         break;
//                     }else if(best && s == best->m_scope){
//                         break;
//                     }
//                 }
//             }
//         }
//     }

//     if(best){
//         return *best;
//     }

//     if(!pervasive){
//         throw runtime_error("Symbol not found: " + id);
//     }
    
//     return *pervasive;

// };

void Symbol::print() const {
    cout << "Identifier: " << m_id << ", Category: " << str_sym_category(m_category) << ", Scope: " << m_scope << endl;
}

void SymTable::print() const {
    Table table;
    int index = 1;
    std::cout << "Symbol Table:" << std::endl;
    table.add_row({"#", "Identifier", "Category", "Scope"});

    vector<Symbol> symbols;
    for (const auto& entry : sym_dict) {
        for (const auto& symbol : entry.second) {
            symbols.push_back(symbol);
        }
    }

    // Ordenar los símbolos primero por Scope y luego por Category
    std::sort(symbols.begin(), symbols.end(), [](const Symbol& a, const Symbol& b) {
        if (a.m_scope == b.m_scope) {
            return a.m_category < b.m_category;
        }
        return a.m_scope < b.m_scope;
    });

    for (const auto& symbol : symbols) {
        table.add_row(RowStream{} << index << symbol.m_id << str_sym_category(symbol.m_category) << symbol.m_scope);
        index++;
    }

    table.format()
        .font_align(FontAlign::center);
    table[0].format()
        .color(Color::green);
    std::cout << table << std::endl;
}

