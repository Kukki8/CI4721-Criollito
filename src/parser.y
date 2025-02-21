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
%token TkAssignment "="
%token TkFor TkIn TkOf TkTo
%token TkTypeBool TkTypeInt TkTypeFloat TkTypeChar TkTypeLabia TkIf TkElse
%token TkElseIf TkTrue TkFalse TkRead TkWhile TkDo TkReturn TkPrint TkBreak
%token TkRegister TkPair TkUnion TkPointer TkID TkInt TkFloat TkChar TkString


%define parse.error detailed

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
    assignment
    | if
    | for
    | while
    | return
    | print
    | declaration
;

assignment:
    TkID TkAssignment expression TkSemicolon
;

if:
    TkIf expression TkOpenBrace statements TkCloseBrace
    | TkIf expression TkOpenBrace statements TkCloseBrace elseOrElseIf TkOpenBrace statements TkCloseBrace
;

elseOrElseIf:
    TkElse
    | TkElseIf expression

for:
    TkFor TkID TkIn TkID TkOpenBrace statements TkCloseBrace
    | TkFor TkID TkIn range TkOpenBrace statements TkCloseBrace
;

while:
    TkWhile expression TkDo TkOpenBrace statements TkCloseBrace
;

range:
     TkInt TkTo TkInt
;

return:
    TkReturn expression TkSemicolon
;

print:
    TkPrint expression TkSemicolon
;

declaration:
    type TkID TkSemicolon       
    | type assignment
;

type:
    TkTypeBool
    | TkTypeInt
    | TkTypeFloat
    | TkTypeChar
    | TkTypeLabia

typeArray:
     type arraySize
     | typeArray arraySize

arraySize:
    TkOpenBracket TkID TkCloseBracket
    | TkOpenBracket TkInt TkCloseBracket

expression:
    TkInt
    | TkFloat
    | TkChar
    | TkString
    | TkID
    | expression TkPlus expression
    | expression TkMinus expression
    | expression TkPower expression
    | expression TkDiv expression
    | expression TkModule expression
    | TkOpenPar expression TkClosePar
;

%%

void yyerror(const char *str) {
    cerr << "¡Epale!, tienes este error: " << str << endl;
    cerr << "En la línea " << yylineno << endl;
}

