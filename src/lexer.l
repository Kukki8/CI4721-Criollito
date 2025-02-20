%option noyywrap

%option yylineno

%{

    #include <iostream>
    #include <string>
    #include <queue>
    #include "parser.hpp"
  
    using namespace std;

    queue<string> errors;

    char *filename;

    string line = "";
  
    int yycolumn = 1;

    void addError(void);

%}

%%
","                           { return TkComma; }
";"                           { return TkSemicolon; }
"("                           { return TkOpenPar; }
")"                           { return TkClosePar; }
"["                           { return TkOpenBracket; }
"]"                           { return TkCloseBracket; }
"{"                           { return TkOpenBrace; }  
"}"                           { return TkCloseBrace; }
"+"                           { return TkPlus; }
"-"                           { return TkMinus; }
"*"                           { return TkPower; }
"/"                           { return TkDiv; }
"%"                           { return TkModule; }
"&&"                          { return TkAnd;}
"||"                          { return TkOr;}
"nah"                         { return TkNot; }
"menolke"                     { return TkLessThan; }
"menol=ke"                    { return TkLessEqThan; }
"mayolke"                     { return TkGreaterThan; }
"mayol=ke"                    { return TkGreaterEqThan; }
"separeceigualito"            { return TkEquiv; }
"nosepareceigualito"          { return TkNotEquiv; }
"="                           { return TkAssignment; } 
"para"                        { return TkFor; } 
"en"                          { return TkIn; } 
"de"                          { return TkOf; } 
"a"                           { return TkTo; } 
"calidad"                     { return TkTypeBool; }
"lucas"                       { return TkTypeInt; }
"sencillo"                    { return TkTypeFloat; }
"beta"                        { return TkTypeChar; }
"labia"                       { return TkTypeLabia; }
"porsia"                      { return TkIf; }
"conchale"                    { return TkElse; }
"conchale porsia"             { return TkElseIf; }
"chevere"                     { return TkTrue; }
"chimbo"                      { return TkFalse; }
"rotalo"                      { return TkRead; }
"mientras"                    { return TkWhile; }
"echale pichon"               { return TkDo; }
"fuimonos"                    { return TkReturn; }
"digalo"                      { return TkPrint; }
"paralo"                      { return TkBreak; }
"saime"                       { return TkRegister; }
"cuadre"                      { return TkPair; }
"pastelero"                   { return TkUnion; }

[nubecita].*\n                { yycolumn = 1; }
[nubecita].*                  { yycolumn = 1; }
"manito"                      { return TkPointer; }
[[:alpha:]_][[:alnum:]_]*     { return TkID; }
[0-9]+                        { yylval.integer = atoi(yytext); return TkInt; }
[0-9]+\.[0-9]+                { yylval.flotante = atof(yytext); return TkFloat; }
\'.\'                         { yylval.integer = yytext[1]; return TkChar; }
\"(?:[^"\\\n]|\\.)*\"         { return TkString; }
[\t]                          { yycolumn++; }
[ ]                           { }
\n                            { yycolumn = 1; } 

[[:digit:]][[:alnum:]_]*      { 
                                addError(); 
                              }
                              
%%


void addError() {

    string token = strdup(yytext);

    string file = strdup(filename);

    string error = " Esto está malo, chic@. Acomoda ese " + token + 
    " loco que está ahí por la linea " + to_string(yylineno) + " en la columna " + 
    to_string(yycolumn - yyleng) + ", al lado del kiosko. \n";

    errors.push(error);
    
}
