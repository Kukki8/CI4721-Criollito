#include <vector>
#include <utility>
#include <string>
#include <iostream>

# include "AST.h"

using namespace std;


Context::Context(){

}

/*--------------------------  --------------------------------------*/

Program::Program(vector<Statement> statements){
    m_statements = statements;
}

void Program::traverse_ast(Context context){

}

/*--------------------------  --------------------------------------*/

Id::Id(string id, Type type){
    m_id = id;
    m_type = type;
}

// Constructor extra para que c++ no llore
Id::Id(){

}

void Id::traverse_ast(Context context){

}

/*-------------------------- Statements --------------------------------------*/


If::If(Expression condition, Statement successful_cond, Statement fail_cond){
    m_condition = condition;
    m_successful_cond = successful_cond;
    m_fail_cond = fail_cond;
}

void If::traverse_ast(Context context){

}


For::For(Id iterator_id, Id iterable_id, Statement body){
    m_iterator_id = iterator_id;
    m_iterable_id = iterable_id;
    m_body = body;
}

void For::traverse_ast(Context context){

}


While::While(Expression cond, Statement body){
    m_cond = cond;
    m_body = body;
}

void While::traverse_ast(Context context){

}

Return::Return(Expression return_expr, Type type_expr){
    m_return_expr = return_expr;
    m_type_expr = type_expr;
}

void Return::traverse_ast(Context context){

}

Assignment::Assignment(Id id, Expression expression){
    m_id = id;
    m_expression = expression;
}

void Assignment::traverse_ast(Context context){

}

// FALTA!
ArrayAssignment::ArrayAssignment(){

}

void ArrayAssignment::traverse_ast(Context context){

}


FunctionCall::FunctionCall(Id fun_id, vector<Expression> args){
    m_fun_id = fun_id;
    m_args = args;
}

void FunctionCall::traverse_ast(Context context){

}

//FALTA
DotOperator::DotOperator(){

}

void DotOperator::traverse_ast(Context context){

}

//?
Break::Break(){

}
void Break::traverse_ast(Context context){

}

//?
Continue::Continue(){

}
void Continue::traverse_ast(Context context){

}

/*-------------------------- Declarations --------------------------------------*/


Variable::Variable(Id id, Type type){
    m_id = id;
    m_type = type;
}

void Variable::traverse_ast(Context context){

}

Function::Function(Id id, Type return_type, vector<pair<string,Type>> args, Statement body){
    m_id = id;
    m_return_type = return_type;
    m_args = args;
    m_body = body;
}

void Function::traverse_ast(Context context){

}


Register::Register(Id id, vector<pair<Id,Type>> fields){
    m_id = id;
    m_fields = fields;
}

void Register::traverse_ast(Context context){

}


Variant::Variant(Id id, vector<pair<Id,Type>> fields){
    m_id = id;
    m_fields = fields;
}

void Variant::traverse_ast(Context context){

}

Pair::Pair(Id id,Type type0, Type type1){
    m_id = id;
    type0 = type0;
    type1 = type1;

}

void Pair::traverse_ast(Context context){
    
}


/*--------------------------  Expresiones --------------------------------------*/

Int::Int(int val){
    m_val = val;
}
void Int::traverse_ast(Context context){

}

Float::Float(float val){
    m_val = val;
}

void Float::traverse_ast(Context context){

}

Char::Char(char val){
    m_val = val;
}

void Char::traverse_ast(Context context){

}

String::String(string val){
    m_val = val;
}

void String::traverse_ast(Context context){

}


Bool::Bool(bool val){
    m_val = val;
}

void Bool::traverse_ast(Context context){

}

BinOp::BinOp(TypeBinOp op, Expression expression0, Expression expression1){
    m_op = op;
    m_expression0 = expression0; 
    m_expression1 = expression1; 
}

void BinOp::traverse_ast(Context context){

}


UnOp:: UnOp(TypeUnOp op, Expression expression){
    m_op = op;
    m_expression = expression;
}

void UnOp::traverse_ast(Context context){

}
