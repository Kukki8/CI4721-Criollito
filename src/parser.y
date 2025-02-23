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

%token TkDot TkComma TkColon TkSemicolon TkOpenPar TkClosePar TkOpenBracket TkCloseBracket
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
    | for
    | while
    | return
    | assignment
    | functionCall
    | TkBreak TkSemicolon
    | TkContinue TkSemicolon
;

function:
    type TkID TkOpenPar functionParameter TkClosePar TkOpenBrace statements TkCloseBrace
    | TkTypeVoid TkID TkOpenPar functionParameter TkClosePar TkOpenBrace statements TkCloseBrace
;

functionParameter:
    // lambda
    | type TkID
    | functionParameter TkComma type TkID
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
    | functionArgument TkComma
;

assignment:
    TkID TkAssignment expression TkSemicolon
    | TkID TkAssignment boolExpression TkSemicolon
    | array TkAssignment expression TkSemicolon
    | array TkAssignment boolExpression TkSemicolon
;

if:
    TkIf ifExpression optionalElseIf optionalElse
;

ifExpression:
    TkOpenPar boolExpression TkClosePar TkOpenBrace statements TkCloseBrace
;

optionalElseIf:
    // lambda
    | elseIfList
;

elseIfList:
    elseIfList TkElseIf ifExpression
    | TkElseIf ifExpression
;

optionalElse:
    // lambda
    | TkElse TkOpenBrace statements TkCloseBrace
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
    | TkReturn boolExpression TkSemicolon
;

declaration:
    type TkID TkSemicolon       
    | type assignment
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
    TkPair TkOpenPar type TkComma type TkClosePar TkID 
;

dereference:
    TkPointer TkID 
;

variant:
    TkUnion TkID TkOpenBrace variantList TkCloseBrace
;

variantList:
    type TkColon type
    | variantList TkComma type TkColon type
;

register:
    TkRegister TkID TkOpenBrace registerList TkCloseBrace
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
    | expression TkPlus expression
    | expression TkMinus expression
    | expression TkPower expression
    | expression TkDiv expression
    | expression TkModule expression
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
  TkID TkDot functionCallVal
  | TkID TkDot TkID
  | TkID TkDot array
  | TkID TkDot dotOperator
;
%%

void yyerror(const char *str) {
    cerr << "¡Epale!, tienes este error: " << str << endl;
    cerr << "en la línea " << yylineno << endl;
}

