%{
#define YYERROR_VERBOSE 1

#include <iostream>
#include <string>
#include <queue>
using namespace std;

extern int yylex();
extern int yylineno;
extern char* yytext;
extern void yyerror(const char*);

extern queue<string> errors;

%}

%token TkComma TkSemicolon TkOpenPar TkClosePar TkOpenBracket TkCloseBracket
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
%left TkLessThan TkLessEqThan TkGreaterThan TkGreaterEqThan
%left TkPlus TkMinus
%left TkDiv TkModule
%left TkPower
%left TkTypeBool TkTypeInt TkTypeFloat TkTypeChar TkTypeString TkTypeVoid
%right TkNot
%nonassoc TkTrue TkFalse

%define parse.error detailed

// Definicion de tipos 

%union {
    int integer;
    float flotante;
    char character;
    char* str;
}

%type <integer> TkInt
%type <flotante> TkFloat
%type <character> TkChar
%type <str> TkString
%type <str> TkID 

%%

// Gramática

program:
    statements 
;

statements:
    statement
    | statements statement
;

statement:
    declaration
    | if
    | ifElse
    | for
    | while
    | return
    | assignment
    | functionCall
    | TkBreak TkSemicolon
    | TkContinue TkSemicolon
;

function:
    returnType TkID TkOpenPar functionParameter TkClosePar TkOpenBrace statements TkCloseBrace
;

functionParameter:
    // lambda
    | type TkID
    | functionParameter TkComma
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
    | functionArgument TkComma
;

assignment:
    TkID TkAssignment expression TkSemicolon
;

if:
    TkIf ifExpression optionalIfElse optionalElse
;

ifExpression:
    TkOpenPar boolExpression TkClosePar TkOpenBrace statements TkCloseBrace
;

optionalIfElse:
    // lambda
    | TkElseIf ifExpression
;

optionalElse:
    // lambda
    | TkElse ifExpression
;

for:
    TkFor TkID TkIn TkID TkOpenBrace statements TkCloseBrace
    | TkFor TkID TkIn range TkOpenBrace statements TkCloseBrace
;

while:
    TkWhile TkOpenPar boolExpression TkClosePar TkDo TkOpenBrace statements TkCloseBrace
;

range:
     TkInt TkTo TkInt
;

return:
    TkReturn expression TkSemicolon
;

declaration:
    type TkID TkSemicolon       
    | type assignment
    | function
;

type:
    baseType
    | arrayType
;

baseType:
    TkTypeBool
    | TkTypeInt
    | TkTypeFloat
    | TkTypeChar
    | TkTypeString
;

returnType:
    type
    | TkTypeVoid
;

arrayType:
     baseType arraySize
     | arrayType arraySize
;

arraySize:
    TkOpenBracket TkID TkCloseBracket
    | TkOpenBracket TkInt TkCloseBracket
;

expression:
    TkInt
    | TkFloat
    | TkChar
    | TkString
    | TkID
    | functionCallVal
    | expression TkPlus expression
    | expression TkMinus expression
    | expression TkPower expression
    | expression TkDiv expression
    | expression TkModule expression
    | TkOpenPar expression TkClosePar
    | boolExpression
;

boolExpression:
      TkTrue
    | TkFalse
    | primitive TkLessThan primitive
    | primitive TkLessEqThan primitive
    | primitive TkGreaterThan primitive
    | primitive TkGreaterEqThan primitive
    | primitive TkEquiv primitive
    | primitive TkNotEquiv primitive
    | TkNot boolExpression
    | TkOpenPar boolExpression TkClosePar
    | boolExpression TkAnd boolExpression
    | boolExpression TkOr boolExpression
;

primitive:
  TkInt
  | TkFloat
  | TkID
  | TkChar
;
%%

void yyerror(const char *str) {
    cerr << "¡Epale!, tienes este error: " << str << endl;
    cerr << "En la línea " << yylineno << endl;
}

