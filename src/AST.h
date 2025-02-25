#ifndef AST
#define AST

#include <iostream>
#include <vector>
#include <string>
#include <utility>
using namespace std;

/*--------------------------  --------------------------------------*/

class Context{

    public:
        Context();
};


/*--------------------------   --------------------------------------*/

enum Type { Int, Float, Bool, Char, String, Array, Pair};

class Id {

    public:
        string m_id;
        Type m_type;

        Id(string id, Type type);
        Id();
        void traverse_ast(Context context);
        

};

/*--------------------------  Expresiones --------------------------------------*/

class Expression {

};


class Int : public Expression{

    public:
        int m_val;

        Int(int val);
        void traverse_ast(Context context);
};

class Float : public Expression{

    public:
        float m_val;

        Float(float val);
        void traverse_ast(Context context);
};

class Char : public Expression{

    public:
        char m_val;

        Char(char val);
        void traverse_ast(Context context);
};

class String : public Expression{

    public:
        string m_val;

        String(string val);
        void traverse_ast(Context context);
};

class Bool : public Expression{

    public:
        bool m_val;

        Bool(bool val);
        void traverse_ast(Context context);
};


enum TypeBinOp{Sum, Sub, Mult, Div, Mod, Less, LessEq, Greater, GreaterEq, Eq, NotEq, And, Or};

class BinOp : public Expression{

    public:
        TypeBinOp m_op;
        Expression m_expression0;
        Expression m_expression1;

        BinOp(TypeBinOp op, Expression expression0, Expression expression1);
        void traverse_ast(Context context);

};

enum TypeUnOp{Neg, Minus, Def};

class UnOp : public Expression{

    public:
        TypeUnOp m_op;
        Expression m_expression;

        UnOp(TypeUnOp op, Expression expression);
        void traverse_ast(Context context);

};


/*-------------------------- Statements --------------------------------------*/


class Statement{

}; 

class If : public Statement{

    public:
        Expression m_condition;
        Statement m_successful_cond;
        Statement m_fail_cond;

        If(Expression condition, Statement successful_cond, Statement fail_cond);
        void traverse_ast(Context context);

}; 

class For : public Statement{

    public:
        Id m_iterator_id;
        Id m_iterable_id;
        Statement m_body;

        For(Id iterator_id, Id iterable_id, Statement body);
        void traverse_ast(Context context);

};

class While : public Statement{

    public:
        Expression m_cond;
        Statement m_body;

        While(Expression cond, Statement body);
        void traverse_ast(Context context);

}; 

class Return : public Statement{

    public:
        Expression m_return_expr;
        Type m_type_expr;

        Return(Expression return_expr, Type type_expr);
        void traverse_ast(Context context);

}; 

// Falta la asignacion coon dotOp
class Assignment : public Statement{

    public:
        Id m_id;
        Expression m_expression;

        Assignment(Id id, Expression expression);
        void traverse_ast(Context context);

}; 

// Por hacer
class ArrayAssignment : public Statement{

    public:

        ArrayAssignment();
        void traverse_ast(Context context);

}; 

class FunctionCall : public Statement{

    public:
        Id m_fun_id;
        vector<Expression> m_args;

        FunctionCall(Id fun_id, vector<Expression> args);
        void traverse_ast(Context context);

};

// Por hacer
class DotOperator : public Statement{

    public:

        DotOperator();
        void traverse_ast(Context context);

};

//?
class Break : public Statement{

    public:

        Break();
        void traverse_ast(Context context);

};

//?
class Continue : public Statement{

    public:

        Continue();
        void traverse_ast(Context context);

};


/*-------------------------- Declarations --------------------------------------*/

class Declaration : public Statement{

};    


class Variable : public Declaration{

    public:
        Id m_id;
        Type m_type;

        Variable(Id id, Type type);
        void traverse_ast(Context context);

};

class Function: public Declaration{

    public:
        Id m_id;
        Type m_return_type;
        vector<pair<string,Type>> m_args;
        Statement m_body;

        Function(Id id, Type return_type, vector<pair<string,Type>> args, Statement m_body);
        void traverse_ast(Context context);
};

class Register: public Declaration{

    public:
        Id m_id;
        vector<pair<Id,Type>> m_fields;

        Register(Id id, vector<pair<Id,Type>> fields);
        void traverse_ast(Context context);

};

class Variant: public Declaration{

    public:
        Id m_id;
        vector<pair<Id,Type>> m_fields;

        Variant(Id id, vector<pair<Id,Type>> fields);
        void traverse_ast(Context context);

};

class Pair: public Declaration{

    public:
        Id m_id;
        Type m_type0;
        Type m_type1;

        Pair(Id id,Type type0, Type type1);
        void traverse_ast(Context context);

};

/*--------------------------  --------------------------------------*/

class Program{

    public:
        vector<Statement> m_statements; 

        Program(vector<Statement> statements);
        void traverse_ast(Context context);
};

#endif