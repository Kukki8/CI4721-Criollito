%{
#define YYERROR_VERBOSE 1

#include <iostream>
#include <string>
#include <queue>
#include "sym_table.h"
#include "ast.h"
#include "type_checker.h"

using namespace std;

extern int yylex();
extern int yylineno;
extern int yycolumn;
extern char* yytext;
extern void yyerror(const char*);

ASTNode* root;
SymTable symTable;
%}

%token <str> TkString TkID
%token <str> TkTypeBool TkTypeInt TkTypeFloat TkTypeChar TkTypeString 
%token <integer> TkInt
%token <flotante> TkFloat
%token <character> TkChar

%token TkDot TkComma TkColon TkSemicolon TkOpenPar TkClosePar TkOpenBracket TkCloseBracket TkDereference
%token TkOpenBrace TkCloseBrace TkPlus TkMinus TkPower TkDiv TkModule
%token TkAnd TkOr TkNot TkLessThan TkLessEqThan TkGreaterThan TkGreaterEqThan
%token TkEquiv TkNotEquiv 
%token TkAssignment
%token TkFor TkIn TkOf TkTo
%token TkIf TkElse TkElseIf 
%token TkTrue TkFalse 
%token TkWhile TkDo TkReturn TkBreak TkContinue
%token TkRegister TkPair TkUnion TkPointer

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

%code requires {
  #include "ast.h"
}

%union {
    int integer;
    float flotante;
    char character;
    char* str;
    ASTNode* node;
}

%type <node> program statements statement expression assignment
%type <node> function functionInit functionParameter functionArgument functionCall functionCallVal
%type <node> if for while whileInit declaration pair arrayAssignment
%type <node> boolExpression pairExpression
%type <node> dereference array dotOperator dotOptions type baseType arraySize arraySizeParam
%type <node> ifExpression optionalElse optionalElseIf elseIfList elseInit ifInit elseIfInit
%type <node> forInit range
%type <node> return
%type <node> register registerList variant variantList

%%

// Gramática

program:
    statements { 
        symTable.print();
        root = new ASTNode(AST_PROGRAM, "program");
        root->addChild($1); 
        root->print();
        try {
            TypeChecker checker(symTable);
            checker.check(root);
            std::cout << "Type check: éxito." << std::endl;
        } catch (const std::runtime_error &e) {
            std::cerr << "Error de tipado: " << e.what() << std::endl;
        }
    }
;

statements:
    statement {
        $$ = new ASTNode(AST_STATEMENT, "statements");
        $$->addChild($1);
    }
    | statements statement {
        $$ = $1;
        $$->addChild($2);
    }
;

statement:
    declaration { $$ = $1; }
    | if { $$ = $1; }
    | for { $$ = $1; }
    | while { $$ = $1; }
    | return { $$ = $1; }
    | assignment { $$ = $1; }
    | arrayAssignment { $$ = $1; }
    | functionCall { $$ = $1; }
    | dotOperator TkSemicolon { 
        $$ = new ASTNode(AST_STATEMENT, "dotOperator");
        $$->addChild($1);
    }
    | TkBreak TkSemicolon { 
        $$ = new ASTNode(AST_STATEMENT, "break");
    }
    | TkContinue TkSemicolon { 
        $$ = new ASTNode(AST_STATEMENT, "continue");
    }
;

function:
    type functionInit functionParameter TkClosePar TkOpenBrace statements TkCloseBrace {
        int funcScope = symTable.get_current_scope();
        symTable.pop_scope();
        $$ = new ASTNode(AST_FUNCTION, "function");
        $$->scope = funcScope;
        $$->addChild($1);
        $$->addChild($2);
        $$->addChild($3);
        $$->addChild($6);
    }
    | TkTypeVoid functionInit functionParameter TkClosePar TkOpenBrace statements TkCloseBrace {
        int funcScope = symTable.get_current_scope();
        symTable.pop_scope();
        ASTNode* voidType = new ASTNode(AST_TYPE, "void");
        $$ = new ASTNode(AST_FUNCTION, "function");
        $$->scope = funcScope;
        $$->addChild(voidType);
        $$->addChild($2);
        $$->addChild($3);
        $$->addChild($6);
    }
;

functionInit:
    TkID TkOpenPar {
        Symbol id($1, Function, symTable.get_current_scope());
        symTable.insert_sym(id);
        symTable.push_empty_scope();
        $$ = new ASTNode(AST_FUNCTION_INIT, $1);
    }
;

functionParameter:
    // lambda
    { $$ = new ASTNode(AST_PARAM_LIST, "params"); }
    | type TkID {
        SymType typeSym = str_to_symtype($1->value);
        Symbol sym($2, Variable, symTable.get_current_scope(), typeSym);
        symTable.insert_sym(sym);
        ASTNode* param = new ASTNode(AST_PARAM, "param");
        param->addChild($1);
        param->addChild(new ASTNode(AST_ID, $2));
        $$ = new ASTNode(AST_PARAM_LIST, "params");
        $$->addChild(param);
    }
    | type dereference {
        ASTNode* param = new ASTNode(AST_PARAM, "param");
        param->addChild($1);
        param->addChild($2);
        $$ = new ASTNode(AST_PARAM_LIST, "params");
        $$->addChild(param);
    }
    | functionParameter TkComma type TkID {
        SymType typeSym = str_to_symtype($3->value);
        Symbol sym($4, Variable, symTable.get_current_scope(), typeSym);
        symTable.insert_sym(sym);
        ASTNode* param = new ASTNode(AST_PARAM, "param");
        param->addChild($3);
        param->addChild(new ASTNode(AST_ID, $4));
        $$ = $1;
        $$->addChild(param);
    }
    | functionParameter TkComma type dereference {
        $$ = $1;
        ASTNode* param = new ASTNode(AST_PARAM, "param");
        param->addChild($3);
        param->addChild($4);
        $$->addChild(param);
    }
;

functionCall:
    functionCallVal TkSemicolon { $$ = $1; }
;

functionCallVal:
    TkID TkOpenPar functionArgument TkClosePar {
        $$ = new ASTNode(AST_FUNCTION_CALL, $1);
        $$->addChild($3);
    }
;

functionArgument:
    // lambda
    { $$ = new ASTNode(AST_ARG_LIST, "args"); }
    | expression { 
        $$ = new ASTNode(AST_ARG_LIST, "args");
        $$->addChild($1);
    }
    | boolExpression { 
        $$ = new ASTNode(AST_ARG_LIST, "args");
        $$->addChild($1);
    }
    | functionArgument TkComma expression {
        $$ = $1;
        $$->addChild($3);
    }
    | functionArgument TkComma boolExpression {
        $$ = $1;
        $$->addChild($3);
    }
;

assignment:
    TkID TkAssignment expression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, $1); 
        ASTNode* id = new ASTNode(AST_ID, $1);
        $$->addChild(id);
        $$->addChild($3);
    }
    | TkID TkAssignment boolExpression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, $1); 
        ASTNode* id = new ASTNode(AST_ID, $1);
        $$->addChild(id);
        $$->addChild($3);
    }
    | dotOperator TkAssignment expression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, "");
        $$->addChild($1);
        $$->addChild($3);
    }
    | dotOperator TkAssignment boolExpression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, "");
        $$->addChild($1);
        $$->addChild($3);
    }
;

arrayAssignment:
    array TkAssignment expression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, "arrayAssignment");
        $$->addChild($1);
        $$->addChild($3);
    }
    | array TkAssignment boolExpression TkSemicolon {
        $$ = new ASTNode(AST_ASSIGNMENT, "arrayAssignment");
        $$->addChild($1);
        $$->addChild($3);
    }
;

if:
    ifInit ifExpression optionalElseIf optionalElse {
        int ifScope = symTable.get_current_scope();
        symTable.pop_scope();
        $$ = new ASTNode(AST_IF, "if");
        $$->scope = ifScope;
        $$->addChild($2);
        $$->addChild($3);
        $$->addChild($4);
    }
;

ifExpression:
    TkOpenPar boolExpression TkClosePar TkOpenBrace statements TkCloseBrace { $$ = new ASTNode(AST_IF_EXPR, ""); $$->addChild($2); $$->addChild($5); }
;

optionalElseIf:
    // lambda
    { $$ = new ASTNode(AST_ELSEIF_LIST, ""); }
    | elseIfList { symTable.pop_scope(); $$ = $1; }
;

elseIfList:
    elseIfInit ifExpression { $$ = new ASTNode(AST_ELSEIF, ""); $$->addChild($2); }
    | elseIfList elseIfInit ifExpression { $$ = $1; ASTNode* tmp = new ASTNode(AST_ELSEIF, ""); tmp->addChild($3); $$->addChild(tmp); }
;

optionalElse:
    // lambda
    { $$ = new ASTNode(AST_ELSE, ""); }
    | elseInit TkOpenBrace statements TkCloseBrace { symTable.pop_scope(); $$ = new ASTNode(AST_ELSE, ""); $$->addChild($3); }
;

ifInit:
    TkIf { symTable.push_empty_scope(); $$ = new ASTNode(AST_IF_INIT, "if"); }
;

elseInit:
    TkElse { symTable.push_empty_scope(); $$ = new ASTNode(AST_ELSE_INIT, "else"); }
;

elseIfInit:
    TkElseIf { symTable.push_empty_scope(); $$ = new ASTNode(AST_ELSEIF_INIT, "elseif"); }
;

for:
    forInit TkIn TkID TkOpenBrace statements TkCloseBrace {
        int forScope = symTable.get_current_scope();
        symTable.pop_scope();
        $$ = new ASTNode(AST_FOR, "for");
        $$->scope = forScope;
        $$->addChild($1);
        $$->addChild(new ASTNode(AST_ID, $3));
        $$->addChild($5);
    }
    | forInit TkIn range TkOpenBrace statements TkCloseBrace {
        int forScope = symTable.get_current_scope();
        symTable.pop_scope();
        $$ = new ASTNode(AST_FOR, "for");
        $$->scope = forScope;
        $$->addChild($1);
        $$->addChild($3);
        $$->addChild($5);
    }
;

forInit:
  TkFor TkID { 
      Symbol sym($2, Variable, symTable.get_current_scope());
      symTable.insert_sym(sym);
      symTable.push_empty_scope();
      $$ = new ASTNode(AST_FOR_INIT, $2);
  }
;

while:
    whileInit TkOpenPar boolExpression TkClosePar TkDo TkOpenBrace statements TkCloseBrace {
        int whileScope = symTable.get_current_scope();
        symTable.pop_scope();
        $$ = new ASTNode(AST_WHILE, "while");
        $$->scope = whileScope;
        $$->addChild($1);
        $$->addChild($3);
        $$->addChild($7);
    }
;

whileInit:
    TkWhile { symTable.push_empty_scope(); $$ = new ASTNode(AST_WHILE_INIT, "while"); }
;

range:
    expression TkTo expression {
        $$ = new ASTNode(AST_RANGE, "range");
        $$->addChild($1);
        $$->addChild($3);
    }
;

return:
    TkReturn expression TkSemicolon {
        $$ = new ASTNode(AST_RETURN, "return");
        $$->addChild($2);
    }
    | TkReturn boolExpression TkSemicolon {
        $$ = new ASTNode(AST_RETURN, "return");
        $$->addChild($2);
    }
;

declaration:
    type TkID TkSemicolon { 
      SymType type = str_to_symtype($1->value);
      Symbol sym($2, Variable, symTable.get_current_scope(), type);
      symTable.insert_sym(sym);
      $$ = new ASTNode(AST_DECLARATION, "declaration");
      $$->addChild($1);
      $$->addChild(new ASTNode(AST_ID, $2));
    }
    | type assignment {
      SymType type = str_to_symtype($1->value);
      Symbol sym($2->value, Variable, symTable.get_current_scope(), type);
      symTable.insert_sym(sym);
      $$ = new ASTNode(AST_DECLARATION, "declaration");
      $$->addChild($1);
      $$->addChild($2);
    }
    | function { $$ = $1; }
    | register { $$ = $1; }
    | variant { $$ = $1; }
    | pair { $$ = $1; }
;

type:
    baseType { $$ = $1; }
    | array { $$ = $1; }
;

baseType:
    TkID { $$ = new ASTNode(AST_BASETYPE, $1); }
    | TkTypeBool { $$ = new ASTNode(AST_BASETYPE, $1); }
    | TkTypeInt { $$ = new ASTNode(AST_BASETYPE, $1); }
    | TkTypeFloat { $$ = new ASTNode(AST_BASETYPE, $1); }
    | TkTypeChar { $$ = new ASTNode(AST_BASETYPE, $1); }
    | TkTypeString { $$ = new ASTNode(AST_BASETYPE, $1); }
;

array:
    baseType arraySize {
         $$ = new ASTNode(AST_ARRAY, $1->value+$2->value);
         $$->addChild($1);
         $$->addChild($2);
    }
;

arraySize:
    TkOpenBracket arraySizeParam TkCloseBracket {
         $$ = new ASTNode(AST_ARRAY_SIZE, "["+$2->value+"]");
         $$->addChild($2);
    }
    | arraySize TkOpenBracket arraySizeParam TkCloseBracket {
         $$ = $1;
         ASTNode* tmp = new ASTNode(AST_ARRAY_SIZE, $1->value+"["+$3->value+"]");
         tmp->addChild($3);
         $$->addChild(tmp);
    }
;

arraySizeParam:
    // lambda
    { $$ = new ASTNode(AST_ARRAY_SIZE_PARAM, ""); }
    | expression { $$ = $1; }
;

pair:
    TkPair TkOpenPar type TkComma type TkClosePar TkID {
        SymType type = str_to_symtype($3->value);
        Symbol sym($7, Variable, symTable.get_current_scope(), type);
        symTable.insert_sym(sym);
        $$ = new ASTNode(AST_PAIR, "pair");
        $$->addChild($3);
        $$->addChild($5);
        $$->addChild(new ASTNode(AST_ID, $7));
    }
;

pairExpression:
    TkOpenPar expression TkComma expression TkClosePar {
         $$ = new ASTNode(AST_PAIR_EXPR, "pairExpr");
         $$->addChild($2);
         $$->addChild($4);
    }
;

//Se agrego "| TkPointer dotOperator" para satisfacer la linea 88 de kruskal "listaPrioridad aristasOrdenadas = crearListPrioridad(👉grafito.aristas);"
dereference:
    TkPointer TkID {
        SymType type = str_to_symtype("apuntador");
        Symbol sym($2, Variable, symTable.get_current_scope(), type);
        symTable.insert_sym(sym);
        $$ = new ASTNode(AST_DEREFERENCE, "dereference");
        $$->addChild(new ASTNode(AST_ID, $2));
    }
    | TkPointer array {
        $$ = new ASTNode(AST_DEREFERENCE, "dereference");
        $$->addChild($2);
    }
    | TkPointer dotOperator {
        $$ = new ASTNode(AST_DEREFERENCE, "dereference");
        $$->addChild($2);
    }
;

variant:
    TkUnion TkID TkOpenBrace variantList TkCloseBrace {
        Symbol sym($2, Variable, symTable.get_current_scope());
        symTable.insert_sym(sym);
        $$ = new ASTNode(AST_VARIANT, "variant");
        $$->addChild(new ASTNode(AST_ID, $2));
        $$->addChild($4);
    }
;

variantList:
    type TkColon type {
        $$ = new ASTNode(AST_VARIANT_LIST, "variantList");
        $$->addChild($1);
        $$->addChild($3);
    }
    | variantList TkComma type TkColon type {
        $$ = $1;
        ASTNode* tmp = new ASTNode(AST_VARIANT_LIST_ITEM, "");
        tmp->addChild($3);
        tmp->addChild($5);
        $$->addChild(tmp);
    }
;

register:
    TkRegister TkID TkOpenBrace registerList TkCloseBrace {
        Symbol sym($2, Type, symTable.get_current_scope(), Register);
        symTable.insert_sym(sym);
        $$ = new ASTNode(AST_REGISTER, "register");
        $$->addChild(new ASTNode(AST_ID, $2));
        $$->addChild($4);
        {
            std::vector<std::pair<std::string, SymType>> fields;
            if ($4->children.size() >= 2) {
                fields.push_back(std::make_pair($4->children[1]->value, str_to_symtype($4->children[0]->value)));
            }
            for (size_t i = 2; i < $4->children.size(); i++) {
                ASTNode* item = $4->children[i];
                if (item->children.size() >= 2) {
                    fields.push_back(std::make_pair(item->children[1]->value, str_to_symtype(item->children[0]->value)));
                }
            }
            auto& vec = symTable.sym_dict[$2];
            for (Symbol& s : vec) {
                if (s.m_scope == symTable.get_current_scope()) {
                    s.m_fields = fields;
                    break;
                }
            }
        }
    }
;

registerList:
    type TkID TkSemicolon {
        $$ = new ASTNode(AST_REGISTER_LIST, "registerList");
        $$->addChild($1);
        $$->addChild(new ASTNode(AST_ID, $2));
    }
    | registerList type TkID TkSemicolon {
        $$ = $1;
        ASTNode* tmp = new ASTNode(AST_REGISTER_ITEM, "");
        tmp->addChild($2);
        tmp->addChild(new ASTNode(AST_ID, $3));
        $$->addChild(tmp);
    }
;

expression:
    TkInt { $$ = new ASTNode(AST_INT, std::to_string($1)); }
    | TkFloat { $$ = new ASTNode(AST_FLOAT, std::to_string($1)); }
    | TkChar { $$ = new ASTNode(AST_CHAR, std::string(1, $1)); }
    | TkString { $$ = new ASTNode(AST_STRING, $1); }
    | TkID { $$ = new ASTNode(AST_ID, $1); }
    | functionCallVal { $$ = $1; }
    | dotOperator { $$ = $1; }
    | array { $$ = $1; }
    | dereference { $$ = $1; }
    | pairExpression { $$ = $1; }
    | expression TkPlus expression { $$ = new ASTNode(AST_BIN_OP, "+"); $$->addChild($1); $$->addChild($3); }
    | expression TkMinus expression { $$ = new ASTNode(AST_BIN_OP, "-"); $$->addChild($1); $$->addChild($3); }
    | expression TkPower expression { $$ = new ASTNode(AST_BIN_OP, "^"); $$->addChild($1); $$->addChild($3); }
    | expression TkDiv expression { $$ = new ASTNode(AST_BIN_OP, "/"); $$->addChild($1); $$->addChild($3); }
    | expression TkModule expression { $$ = new ASTNode(AST_BIN_OP, "%"); $$->addChild($1); $$->addChild($3); }
    | TkMinus expression { $$ = new ASTNode(AST_UN_OP, "-"); $$->addChild($2); }
    | TkOpenPar expression TkClosePar { $$ = $2; }
;

boolExpression:
      TkTrue { $$ = new ASTNode(AST_BOOL, "true"); }
    | TkFalse { $$ = new ASTNode(AST_BOOL, "false"); }
    | expression TkLessThan expression { $$ = new ASTNode(AST_BIN_OP, "<"); $$->addChild($1); $$->addChild($3); }
    | expression TkLessEqThan expression { $$ = new ASTNode(AST_BIN_OP, "<="); $$->addChild($1); $$->addChild($3); }
    | expression TkGreaterThan expression { $$ = new ASTNode(AST_BIN_OP, ">"); $$->addChild($1); $$->addChild($3); }
    | expression TkGreaterEqThan expression { $$ = new ASTNode(AST_BIN_OP, ">="); $$->addChild($1); $$->addChild($3); }
    | expression TkEquiv expression { $$ = new ASTNode(AST_BIN_OP, "=="); $$->addChild($1); $$->addChild($3); }
    | expression TkNotEquiv expression { $$ = new ASTNode(AST_BIN_OP, "!="); $$->addChild($1); $$->addChild($3); }
    | TkNot boolExpression { $$ = new ASTNode(AST_UN_OP, "not"); $$->addChild($2); }
    | TkOpenPar boolExpression TkClosePar { $$ = $2; }
    | boolExpression TkAnd boolExpression { $$ = new ASTNode(AST_BIN_OP, "and"); $$->addChild($1); $$->addChild($3); }
    | boolExpression TkOr boolExpression { $$ = new ASTNode(AST_BIN_OP, "or"); $$->addChild($1); $$->addChild($3); }
;

dotOperator:
    TkID TkDot dotOptions {
        ASTNode* idNode = new ASTNode(AST_ID, $1);
        $$ = new ASTNode(AST_DOT_OPERATOR, ".");
        $$->addChild(idNode);
        $$->addChild($3);
    }
    | array TkDot dotOptions {
        $$ = new ASTNode(AST_DOT_OPERATOR, ".");
        $$->addChild($1);
        $$->addChild($3);
    }
    | dotOperator TkDot dotOptions {
        $$ = new ASTNode(AST_DOT_OPERATOR, ".");
        $$->addChild($1);
        $$->addChild($3);
    }
;

dotOptions:
    TkID {
        $$ = new ASTNode(AST_ID, $1);
    }
    | functionCallVal {
        $$ = $1;
    }
    | array {
        $$ = $1;
    }
;


%%

void yyerror(const char *str) {
    cerr << "¡Epale!, tienes este error: " << str << endl;
    cerr << "en la línea " << yylineno << endl;
    cerr << "en la columna " << yycolumn << endl;
}
