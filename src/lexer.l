%option noyywrap

%option yylineno

%{

    #include <iostream>
    #include <string>
    #include <queue>
    #include "parser.hpp"
    #include "error_manager.h"
  
    using namespace std;

    char *filename;

    string line = "";
  
    int yycolumn = 1;
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
"calidad"                     { yylval.str = strdup(yytext); return TkTypeBool; }
"lucas"                       { yylval.str = strdup(yytext); return TkTypeInt; }
"sencillo"                    { yylval.str = strdup(yytext); return TkTypeFloat; }
"beta"                        { yylval.str = strdup(yytext); return TkTypeChar; }
"labia"                       { yylval.str = strdup(yytext); return TkTypeString; }
"vacio"                       { yylval.str = strdup(yytext); return TkTypeVoid; }
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
[[:alpha:]_][[:alnum:]_]*     { yylval.str = strdup(yytext); return TkID; }
[0-9]+                        { yylval.integer = atoi(yytext); return TkInt; }
[0-9]+\.[0-9]+                { yylval.flotante = atof(yytext); return TkFloat; }
\'.\'                         { yylval.integer = yytext[1]; return TkChar; }
\"(?:[^"\\\n]|\\.)*\"         { return TkString; }
[\t]                          { yycolumn++; }
[ ]                           { }
\n                            { yycolumn = 1; }
.                             { addError("Esto está malo, chic@. Acomoda ese " + std::string(yytext) +
                               " en la línea " + std::to_string(yylineno) +
                               " y columna " + std::to_string(yycolumn - yyleng)); }
%%
