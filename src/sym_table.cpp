#include <cstdio>
#include <iostream>
#include "sym_table.h"
#include <algorithm>
#include <stdexcept>

SymTable::SymTable() {
    next_scp = 2; // Comenzamos el siguiente scope en 2 para mantener 1 como el global
    scp_stk.push(1); // Scope global es 1

    std::unordered_map<std::string, std::vector<Symbol>> init_dict = {
        {"Int",     {Symbol("Int",      Type, 0)}},
        {"Float",   {Symbol("Float",    Type, 0)}},
        {"Bool",    {Symbol("Bool",     Type, 0)}},
        {"Char",    {Symbol("Char",     Type, 0)}},
        {"Array",   {Symbol("Array",    Type, 0)}},
        {"Pointer", {Symbol("Pointer",  Type, 0)}},
        {"Read",    {Symbol("Read",     Type, 0)}},
        {"Print",   {Symbol("Print",    Type, 0)}},
    };

    for (const auto& entry : init_dict) {
        sym_dict[entry.first] = entry.second;
    }
}

int SymTable::get_current_scope() {
    return scp_stk.top(); // Scope actual
}

void SymTable::push_empty_scope() {
    scp_stk.push(next_scp++);
}

void SymTable::pop_scope() {
    if (scp_stk.size() > 1) {
        scp_stk.pop();
    } else {
        throw std::runtime_error("No se puede eliminar el scope global.");
    }
}

void SymTable::insert_sym(const Symbol& sym) {
    int current_scope = get_current_scope();

    if (sym_dict.find(sym.m_id) == sym_dict.end()) {
        // Si el identificador es nuevo, creamos una entrada
        sym_dict[sym.m_id] = {sym};
    } else {
        // Verificar duplicados en el mismo scope
        for (const Symbol& entry : sym_dict[sym.m_id]) {
            if (entry.m_scope == current_scope) {
                throw std::runtime_error("Epale! tienes que mejorar la memoria, ya definiste " + sym.m_id);
            }
        }
        // Insertar el símbolo en el scope actual
        sym_dict[sym.m_id].push_back(sym);
    }
}

Symbol SymTable::get_sym(const std::string& id) {
    if (sym_dict.find(id) == sym_dict.end()) {
        throw std::runtime_error("Ey, hermanit@, el símbolo " + id + " no se ha definido");
    }

    int current_scope = get_current_scope();
    Symbol best("", Variable, -1);

    for (const Symbol& entry : sym_dict[id]) {
        if (entry.m_scope <= current_scope && entry.m_scope > best.m_scope) {
            best = entry;
        }
    }

    if (best.m_scope == -1) {
        throw std::runtime_error("Ey, hermanit@, el símbolo " + id + " no se ha definido");
    }

    return best;
}

SymType str_to_symtype(const std::string& type_str) {
    if (type_str == "calidad") return Bool;
    if (type_str == "lucas") return Int;
    if (type_str == "sencillo") return Float;
    if (type_str == "beta") return Char;
    
    if (type_str.substr(0,6) == "labia[") {
        if (type_str.back() == ']') {
            std::string numStr = type_str.substr(6, type_str.size() - 7);
            int arrSize = std::stoi(numStr);
            return Array;
        }
    }
    
    if (type_str == "labia") return Array;
    if (type_str == "apuntador") return Pointer;
    if (type_str == "vacio") return Void;
    if (type_str == "register") return Register;
    
    return Int;
}

std::string symtype_to_str(SymType symType) {
    switch (symType) {
    case Int:
        return "lucas";
    case Float:
        return "sencillo";
    case Bool:
        return "calidad";
    case Char:
        return "beta";
    case Array:
        return "bululu";
    case Pointer:
        return "👉";
    case Void:
        return "vacio";
    case Register:
        return "Register";
    default:
        return "vacio";
    }
}

void SymTable::print() const {
    Table table;
    int index = 1;
    std::cout << "Symbol Table:" << std::endl;
    table.add_row({"#", "Identifier", "Category", "Scope", "Type"});

    std::vector<Symbol> symbols;
    for (const auto& entry : sym_dict) {
        for (const auto& symbol : entry.second) {
            symbols.push_back(symbol);
        }
    }

    std::sort(symbols.begin(), symbols.end(), [](const Symbol& a, const Symbol& b) {
        if (a.m_scope == b.m_scope) {
            return a.m_category < b.m_category;
        }
        return a.m_scope < b.m_scope;
    });

    auto str_category = [](Category category) {
        switch (category) {
            case Variable: return "Variable";
            case Type:     return "Type";
            case Struct:   return "Struct";
            case Union:    return "Union";
            case Function: return "Function";
        }
        return "Unknown";
    };

    auto str_type = [](SymType type) {
        switch (type) {
            case Int:     return "Int";
            case Float:   return "Float";
            case Bool:    return "Bool";
            case Char:    return "Char";
            case Array:   return "Array";
            case Pointer: return "Pointer";
            case Void:    return "Void";
            case Register:return "Register";
        }
        return "Unknown";
    };

    for (const auto& symbol : symbols) {
        table.add_row({
            std::to_string(index++),
            symbol.m_id,
            str_category(symbol.m_category),
            std::to_string(symbol.m_scope),
            symbol.m_category == Variable || symbol.m_category == Type || symbol.m_category == Function ? str_type(symbol.m_type) : "-"
        });
    }

    table.format().font_align(FontAlign::center);
    table[0].format().font_style({FontStyle::bold}).color(Color::green);
    std::cout << table << std::endl;
}
