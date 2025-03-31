#ifndef SYM_TABLE
#define SYM_TABLE

#include <unordered_map>
#include <vector>
#include <stack>
#include <string>
#include <stdexcept>
#include <algorithm>
#include "tabulate.h" // Para la impresión mejorada

using namespace tabulate; // Espacio de nombres para tabulate

// Distintas categorías que puede tener un símbolo
enum Category {
    Variable, // Representa variables
    Type,     // Representa tipos de datos
    Struct,   // Representa estructuras
    Union,    // Representa uniones
    Function  // Representa funciones
};

// Tipos que pueden tener las variables
enum SymType {
    Int,      // Entero
    Float,    // Flotante
    Bool,     // Booleano
    Char,     // Carácter
    Array,    // Arreglo
    Pointer,  // Puntero
    Register, // Registros
    Void      // Unitario
};

// Estructura que representa un símbolo dentro de la tabla
struct Symbol {
    std::string m_id;      // Identificador único del símbolo
    Category m_category;   // Categoría del símbolo
    int m_scope;           // Scope (nivel de contexto donde está definido)
    SymType m_type;        // Tipo de variable (solo aplicable si es Variable)
    std::vector<SymType> m_args_types;  // Tipos de los argumentos de una función
    // Campos del registro: cada campo se define por su identificador y su tipo.
    std::vector<std::pair<std::string, SymType>> m_fields;

    // Constructor para inicializar un símbolo
    Symbol(const std::string& id, Category cat, int scope, SymType type = Void)
      : m_id(id), m_category(cat), m_scope(scope), m_type(type) {}
};

// Clase que representa la tabla de símbolos
class SymTable {
private:
    std::stack<int> scp_stk; // Pila de scopes activos
    int next_scp = 1;        // Próximo scope disponible

public:
    SymTable(); // Constructor para inicializar la tabla de símbolos
    std::unordered_map<std::string, std::vector<Symbol>> sym_dict; // Diccionario de símbolos

    // Métodos para gestionar scopes
    int get_current_scope(); // Obtener el scope actual
    void push_empty_scope(); // Crear y entrar en un nuevo scope
    void pop_scope();        // Salir del scope actual

    // Métodos para gestionar símbolos
    void insert_sym(const Symbol& sym);    // Insertar un símbolo en la tabla
    Symbol get_sym(const std::string& id); // Obtener el símbolo más cercano al scope actual

    // Método para imprimir la tabla
    void print() const;
};

SymType str_to_symtype(const std::string& type_str); // Traducir tipos

std::string symtype_to_str(SymType symType); // Conseguir nombres de los tipos
#endif // SYM_TABLE
