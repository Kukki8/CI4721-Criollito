#ifndef AST
#define AST

#include <iostream>
#include <vector>
#include <string>
#include <utility>
using namespace std;


class Statement{

};  


class Declaration : public Statement{

};    

class Expression {

};

class Program{

    public:
        vector<Statement> m_statements; 

        Program(vector<Statement> statements);
};

// Revisar si faltan
enum Type { Int, Float, Bool, Char, String, Array, Pair};

class Variable : public Declaration{

    public:
        string m_id;
        Type m_type;

        Variable(string id, Type type);

};

class Function: public Declaration{

    public:
        string m_id;
        Type m_return_type;
        vector<pair<string,Type>> m_args;

        Function(string id, Type return_type, vector<pair<string,Type>> args);

};

class Register: public Declaration{

    public:
        string m_id;
        vector<pair<string,Type>> m_fields;

        Register(string id, vector<pair<string,Type>> fields);

};

class Variant: public Declaration{

    public:
        string m_id;
        vector<pair<string,Type>> m_fields;

        Variant(string id, vector<pair<string,Type>> fields);

};

enum TypeBinOp{Sum, Sub, Mult, Div, Mod, Less, LessEq, Greater, GreaterEq, Eq, NotEq, And, Or};

class BinOp : public Expression{

    public:
        TypeBinOp m_op;
        Expression m_expression0;
        Expression m_expression1;

        BinOp(TypeBinOp op, Expression expression0, Expression expression1);

};

enum TypeUnOp{Neg, Minus, Def};

class UnOp : public Expression{

    public:
        TypeUnOp m_op;
        Expression m_expression;

        UnOp(TypeUnOp op, Expression expression);

};



#endif