%{
#define YYERROR_VERBOSE 1

#include <iostream>
#include <string>
#include <queue>
#include "sym_table.h"

using namespace std;

extern int yylex();
extern int yylineno;
extern int yycolumn;
extern char* yytext;
extern void yyerror(const char*);

extern queue<string> errors;

SymTable symTable;
%}

%token TkDot TkComma TkColon TkSemicolon TkOpenPar TkClosePar TkOpenBracket TkCloseBracket TkDereference
%token TkOpenBrace TkCloseBrace TkPlus TkMinus TkPower TkDiv TkModule
%token TkAnd TkOr TkNot TkLessThan TkLessEqThan TkGreaterThan TkGreaterEqThan
%token TkEquiv TkNotEquiv 
%token TkAssignment
%token TkFor TkIn TkOf TkTo
%token TkTypeBool TkTypeInt TkTypeFloat TkTypeChar TkTypeString TkTypeVoid TkIf TkElse
%token TkElseIf TkTrue TkFalse TkWhile TkDo TkReturn TkBreak TkContinue
%token TkRegister TkPair TkUnion TkPointer TkID TkInt TkFloat TkChar TkString


// Reglas de Precedencia

%left TkOr
%left TkAnd
%left TkEquiv TkNotEquiv
%left TkPlus TkMinus
%left TkDiv TkModule
%left TkPower
%left TkLessThan TkLessEqThan TkGreaterThan TkGreaterEqThan
%left TkTypeBool TkTypeInt TkTypeFloat TkTypeChar TkTypeString TkTypeVoid
%right TkNot
%nonassoc TkTrue TkFalse
%right TkPointer
%precedence TkDot
%precedence TkID

%define parse.error detailed
%define parse.trace

// Definicion de tipos 

%union {
    int integer;
    float flotante;
    char character;
    char* str;
    //T_Expression expression_ptr;
    //T_Pair pair_ptr;
}

%type <integer> TkInt arraySize
%type <flotante> TkFloat
%type <character> TkChar
%type <str> TkString TkID TkTypeVoid
%type <str> dereference array dotOperator functionCallVal type function statements statement
%type <str> assignment for
//%type <expression_ptr> arraySizeParam expression pairExpression

%%

// Gramática

program:
    statements { symTable.print(); }
;

statements:
    statement
    | statements statement
;

statement:
    declaration
    | if
    | for
    | while
    | return
    | assignment
    | arrayAssignment
    | functionCall
    | dotOperator TkSemicolon
    | TkBreak TkSemicolon
    | TkContinue TkSemicolon
;

function:
    type functionInit functionParameter TkClosePar TkOpenBrace statements TkCloseBrace {
        symTable.pop_scope();
    }
    | TkTypeVoid functionInit functionParameter TkClosePar TkOpenBrace statements TkCloseBrace {
        symTable.pop_scope();
    }
;

functionInit:
    TkID TkOpenPar {
        Symbol id($1, Function, symTable.get_current_scope());
        symTable.insert_sym(id);
        symTable.push_empty_scope();
    }
;

functionParameter:
    // lambda
    | type TkID {
        Symbol sym($2, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
    | type dereference 
    | functionParameter TkComma type TkID {
        Symbol sym($4, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
    | functionParameter TkComma type dereference
;

functionCall:
    functionCallVal TkSemicolon
;

functionCallVal:
    TkID TkOpenPar functionArgument TkClosePar
;

functionArgument:
    // lambda
    | expression
    | boolExpression
    | functionArgument TkComma expression
    | functionArgument TkComma boolExpression
;

assignment:
    TkID TkAssignment expression TkSemicolon {
        $$ = $1;
    }
    | TkID TkAssignment boolExpression TkSemicolon {
        $$ = $1;
    }
    | dotOperator TkAssignment expression TkSemicolon
    | dotOperator TkAssignment boolExpression TkSemicolon
;

arrayAssignment:
    array TkAssignment expression TkSemicolon
    | array TkAssignment boolExpression TkSemicolon
;

if:
    ifInit ifExpression optionalElseIf optionalElse { symTable.pop_scope(); }
;

ifExpression:
    TkOpenPar boolExpression TkClosePar TkOpenBrace statements TkCloseBrace
;

optionalElseIf:
    // lambda
    | elseIfList { symTable.pop_scope(); }
;

elseIfList:
    elseIfInit ifExpression
    | elseIfList elseIfInit ifExpression
;

optionalElse:
    // lambda
    | elseInit TkOpenBrace statements TkCloseBrace { symTable.pop_scope(); }
;

ifInit:
    TkIf { symTable.push_empty_scope(); }
;

elseInit:
    TkElse { symTable.push_empty_scope(); }
;

elseIfInit:
    TkElseIf { symTable.push_empty_scope(); }
;

for:
    forInit TkIn TkID TkOpenBrace statements TkCloseBrace {
        symTable.pop_scope();
    }
    | forInit TkIn range TkOpenBrace statements TkCloseBrace {
        symTable.pop_scope();
    }
;

forInit:
  TkFor TkID { 
      Symbol sym($2, Variable, symTable.get_current_scope());
      symTable.insert_sym(sym);
      symTable.push_empty_scope();
  }
;

while:
    whileInit TkOpenPar boolExpression TkClosePar TkDo TkOpenBrace statements TkCloseBrace { symTable.pop_scope(); }
;

whileInit:
    TkWhile { symTable.push_empty_scope(); }
;

range:
    expression TkTo expression
;

return:
    TkReturn expression TkSemicolon
    | TkReturn boolExpression TkSemicolon
;

declaration:
    type TkID TkSemicolon { 
      Symbol sym($2, Variable, symTable.get_current_scope());
      symTable.insert_sym(sym);
    }
    | type assignment {
      Symbol sym($2, Variable, symTable.get_current_scope());
      symTable.insert_sym(sym);
    }
    | function
    | register
    | variant
    | pair
;

type:
    baseType
    | array
;

baseType:
    TkID
    | TkTypeBool
    | TkTypeInt
    | TkTypeFloat
    | TkTypeChar
    | TkTypeString
;

array:
    baseType arraySize
;

arraySize:
    TkOpenBracket arraySizeParam TkCloseBracket
    | arraySize TkOpenBracket arraySizeParam TkCloseBracket
;

arraySizeParam:
    // lambda
    | expression
;

pair:
    TkPair TkOpenPar type TkComma type TkClosePar TkID {
        Symbol sym($7, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
;

pairExpression:
    TkOpenPar expression TkComma expression TkClosePar
;

//Se agrego "| TkPointer dotOperator" para satisfacer la linea 88 de kruskal "listaPrioridad aristasOrdenadas = crearListPrioridad(👉grafito.aristas);"
dereference:
    TkPointer TkID {
        Symbol sym($2, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
    | TkPointer array
    | TkPointer dotOperator
    ;

variant:
    TkUnion TkID TkOpenBrace variantList TkCloseBrace {
        Symbol sym($2, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
;

variantList:
    type TkColon type
    | variantList TkComma type TkColon type
;

register:
    TkRegister TkID TkOpenBrace registerList TkCloseBrace {
        Symbol sym($2, Type, symTable.get_current_scope());
        symTable.insert_sym(sym);
    }
;

registerList:
    type TkID TkSemicolon
    | registerList type TkID TkSemicolon
;

expression:
    TkInt
    | TkFloat
    | TkChar
    | TkString
    | TkID
    | functionCallVal
    | dotOperator
    | array
    | dereference
    | pairExpression
    | expression TkPlus expression
    | expression TkMinus expression
    | expression TkPower expression
    | expression TkDiv expression
    | expression TkModule expression
    | TkMinus expression
    | TkOpenPar expression TkClosePar
;

boolExpression:
      TkTrue
    | TkFalse
    | expression TkLessThan expression
    | expression TkLessEqThan expression
    | expression TkGreaterThan expression
    | expression TkGreaterEqThan expression
    | expression TkEquiv expression
    | expression TkNotEquiv expression
    | TkNot boolExpression
    | TkOpenPar boolExpression TkClosePar
    | boolExpression TkAnd boolExpression
    | boolExpression TkOr boolExpression
;

dotOperator:
    TkID TkDot dotOptions {
        $$ = $1;
    }
    | array TkDot dotOptions {
        $$ = $1;
    }
    | dotOperator TkDot dotOptions
;

dotOptions:
    TkID
    | functionCallVal
    | array
;

%%

void yyerror(const char *str) {
    cerr << "¡Epale!, tienes este error: " << str << endl;
    cerr << "en la línea " << yylineno << endl;
    cerr << "en la columna " << yycolumn << endl;
}
