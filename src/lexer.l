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

    void addError();

%}

%%
"."                           { return TkDot; }
","                           { return TkComma; }
":"                           { return TkColon; }
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
"labia"                       { return TkTypeString; }
"vacio"                       { return TkTypeVoid; }
"conchale porsia"             { return TkElseIf; }
"porsia"                      { return TkIf; }
"conchale"                    { return TkElse; }
"chevere"                     { return TkTrue; }
"chimbo"                      { return TkFalse; }
"mientras"                    { return TkWhile; }
"echale pichon"               { return TkDo; }
"fuimonos"                    { return TkReturn; }
"paralo"                      { return TkBreak; }
"palante"                     { return TkContinue; }
"saime"                       { return TkRegister; }
"cuadre"                      { return TkPair; }
"pastelero"                   { return TkUnion; }
\xF0\x9F\x93\xAC              { yycolumn = 1;  } /* :speech_balloon: */
\xF0\x9F\x91\x89              { return TkPointer; } /* :point_right: */
[[:alpha:]_][[:alnum:]_]*     { return TkID; }
[0-9]+                        { yylval.integer = atoi(yytext); return TkInt; }
[0-9]+\.[0-9]+                { yylval.flotante = atof(yytext); return TkFloat; }
\'.\'                         { yylval.integer = yytext[1]; return TkChar; }
\"(?:[^"\\\n]|\\.)*\"         { return TkString; }
[\t]                          { yycolumn++; }
[ ]                           { }
\n                            { yycolumn = 1; }
.                             { addError(); }
%%

void addError() {
    std::string token = yytext;
    std::string error = "Esto está malo, chic@. Acomoda ese " + token + " loco que está ahí por la línea " + std::to_string(yylineno) + " en la columna " + std::to_string(yycolumn - yyleng) + ", al lado del kiosko.\n";

    // Imprimir el error en stderr
    fprintf(stderr, "%s", error.c_str());
    
    errors.push(error);
}
