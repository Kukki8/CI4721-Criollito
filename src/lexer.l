// Asume que no hay mas archvos que escanear 
%option noyywrap

// Devuelve el numero de la linea que se esta leyendo
%option yylineno

%{

    // Importamos las librerias que necesitaremos
    #include <iostream>
    #include <string>
    #include <queue>
  
    using namespace std;

    // Utilizaremos colas para guardar los tokens y los errores
    queue<string> errors;

    // Apuntador para el nombre del archivo
    char *filename;

    // Variable para guardar la linea actual
    string line = "";
  
    // Contador de columnas para identificar a los errores
    int yycolumn = 1;

    // Funcion que se encarga de agregar un error a la cola
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
"&&"                          { return TkAnd}
"||"                          { return TkOr}
"nah"                         { return TkNot }
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
"calidad"                     { TkTypeBool }
"lucas"                       { TkTypeInt }
"sencillo"                    { TkTypeFloat }
"beta"                        { TkTypeChar }
"labia"                       { TkTypeLabia }
"porsia"                      { TkIf }
"conchale"                    { TkElse }
"conchale porsia"             { TkElseIf }
"chevere"                     { TkTrue }
"chimbo"                      { TkFalse }
"rotalo"                      { TkRead }
"mientras"                    { TkWhile }
"echale pichon"               { TkDo }
"fuimonos"                    { TkReturn }
"digalo"                      { TkPrint }
"paralo"                      { TkBreak }
"saime"                       { TkRegister }
"cuadre"                      { TkPair }
"pastelero"                   { TkUnion}

// Hay que agregar el pre procesamiento en el main de estos tokens con emojis
[nubecita].*\n                { yycolumn = 1; // Ignora comentarios de una linea }
[nubecita].*                  { yycolumn = 1; // Ignora comentarios de una linea AL FINAL }
"manito"                      { return TkPointer; }
[[:alpha:]_][[:alnum:]_]*     { return TkID; }
[0-9]+                        { yylval.integer = atoi(yytext); return TkInt; }
[0-9]+\.[0-9]+                { yylval.flot = atof(yytext); return TkFloat; }
\'.\'                         { yylval.integer = yytext[1]; return TkChar; }
\"(?:[^"\\\n]|\\.)*\"         { return TkString; }
[\t]                          { yycolumn++; // Ignorar tabular }
[ ]                           { // Ignora espacios en blanco }
\n                            { yycolumn = 1; // Ignorar saltos de linea } 

[[:digit:]][[:alnum:]_]*      { 
                                // Agregamos error de "nombre de variable con numero al principio" a la cola
                                addError(); 
                              }
                              
%%



// Funcion que se encarga de agregar un error a la cola
void addError() {

    // Copia el valor del token con el error
    string token = strdup(yytext);

    // Copia el valor del archivo
    string file = strdup(filename);

    string error = " Esto está malo, chic@. Acomoda ese " + token + 
    " loco que está ahí por la linea " + to_string(yylineno) + " en la columna " + 
    to_string(yycolumn - yyleng) + ", al lado del kiosko. \n"

    // Finalmente, se agrega el error a la cola
    errors.push(error);
}