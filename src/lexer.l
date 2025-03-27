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
"."                           { yycolumn += yyleng; return TkDot; }
","                           { yycolumn += yyleng; return TkComma; }
":"                           { yycolumn += yyleng; return TkColon; }
";"                           { yycolumn += yyleng; return TkSemicolon; }
"("                           { yycolumn += yyleng; return TkOpenPar; }
")"                           { yycolumn += yyleng; return TkClosePar; }
"["                           { yycolumn += yyleng; return TkOpenBracket; }
"]"                           { yycolumn += yyleng; return TkCloseBracket; }
"{"                           { yycolumn += yyleng; return TkOpenBrace; }
"}"                           { yycolumn += yyleng; return TkCloseBrace; }
"+"                           { yycolumn += yyleng; return TkPlus; }
"-"                           { yycolumn += yyleng; return TkMinus; }
"*"                           { yycolumn += yyleng; return TkPower; }
"/"                           { yycolumn += yyleng; return TkDiv; }
"%"                           { yycolumn += yyleng; return TkModule; }
"&&"                          { yycolumn += yyleng; return TkAnd;}
"||"                          { yycolumn += yyleng; return TkOr;}
"nah"                         { yycolumn += yyleng; return TkNot; }
"menolke"                     { yycolumn += yyleng; return TkLessThan; }
"menol=ke"                    { yycolumn += yyleng; return TkLessEqThan; }
"mayolke"                     { yycolumn += yyleng; return TkGreaterThan; }
"mayol=ke"                    { yycolumn += yyleng; return TkGreaterEqThan; }
"separeceigualito"            { yycolumn += yyleng; return TkEquiv; }
"nosepareceigualito"          { yycolumn += yyleng; return TkNotEquiv; }
"="                           { yycolumn += yyleng; return TkAssignment; }
"para"                        { yycolumn += yyleng; return TkFor; }
"en"                          { yycolumn += yyleng; return TkIn; }
"de"                          { yycolumn += yyleng; return TkOf; }
"a"                           { yycolumn += yyleng; return TkTo; }
"calidad"                     { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeBool; }
"lucas"                       { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeInt; }
"sencillo"                    { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeFloat; }
"beta"                        { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeChar; }
"labia"                       { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeString; }
"vacio"                       { yycolumn += yyleng; yylval.str = strdup(yytext); return TkTypeVoid; }
"conchale porsia"             { yycolumn += yyleng; return TkElseIf; }
"porsia"                      { yycolumn += yyleng; return TkIf; }
"conchale"                    { yycolumn += yyleng; return TkElse; }
"chevere"                     { yycolumn += yyleng; return TkTrue; }
"chimbo"                      { yycolumn += yyleng; return TkFalse; }
"mientras"                    { yycolumn += yyleng; return TkWhile; }
"echale pichon"               { yycolumn += yyleng; return TkDo; }
"fuimonos"                    { yycolumn += yyleng; return TkReturn; }
"paralo"                      { yycolumn += yyleng; return TkBreak; }
"palante"                     { yycolumn += yyleng; return TkContinue; }
"saime"                       { yycolumn += yyleng; return TkRegister; }
"cuadre"                      { yycolumn += yyleng; return TkPair; }
"pastelero"                   { yycolumn += yyleng; return TkUnion; }
\xF0\x9F\x93\xAC              { yycolumn = 1;  } /* :speech_balloon: */
\xF0\x9F\x91\x89              { yycolumn += yyleng; return TkPointer; } /* :point_right: */
[[:alpha:]_][[:alnum:]_]*     { yycolumn += yyleng; yylval.str = strdup(yytext); return TkID; }
[0-9]+                        { yycolumn += yyleng; yylval.integer = atoi(yytext); return TkInt; }
[0-9]+\.[0-9]+                { yycolumn += yyleng; yylval.flotante = atof(yytext); return TkFloat; }
\'.\'                         { yycolumn += yyleng; yylval.integer = yytext[1]; return TkChar; }
\"(?:[^"\\\n]|\\.)*\"         { yycolumn += yyleng; return TkString; }
[\t]                          { yycolumn++; }
[ ]                           { yycolumn++; }
\n                            { yycolumn = 1; }
.                             { addError("Esto está malo, chic@. Acomoda ese " + std::string(yytext) +
                               " en la línea " + std::to_string(yylineno) +
                               " y columna " + std::to_string(yycolumn - yyleng)); }
%%
