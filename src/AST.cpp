#include <vector>
#include <utility>
#include <string>
#include <iostream>

# include "AST.h"

using namespace std;



Program::Program(vector<Statement> statements){
    m_statements = statements;
}

Variable::Variable(string id, Type type){
    m_id = id;
    m_type = type;
}

Function::Function(string id, Type return_type, vector<pair<string,Type>> args){
    m_id = id;
    m_return_type = return_type;
    m_args = args;
}

Register::Register(string id, vector<pair<string,Type>> fields){
    m_id = id;
    m_fields = fields;
}

Variant::Variant(string id, vector<pair<string,Type>> fields){
    m_id = id;
    m_fields = fields;
}

BinOp::BinOp(TypeBinOp op, Expression expression0, Expression expression1){
    m_op = op;
    m_expression0 = expression0; 
    m_expression1 = expression1; 
}


UnOp:: UnOp(TypeUnOp op, Expression expression){
    m_op = op;
    m_expression = expression;
}

