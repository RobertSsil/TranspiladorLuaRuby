%{
#include <string.h>
#include "lua2ruby.tab.h"
#include "transpiler.h"
%}

%option noyywrap
%option nounput
%option noinput

%%

[ 	]+                  { }
\r                      { }
\n                      { yylineno++; }

"--"[^\n]*              { }

"local"                 { return LOCAL; }
"print"                 { return PRINT; }
"read"                  { return READ; }

"type"                  { yylval.str = strdup("type"); return ID; }
"nil"                   { return NIL; }
"true"                  { return TRUE; }
"false"                 { return FALSE; }

"if"                    { return IF; }
"then"                  { return THEN; }
"else"                  { return ELSE; }
"elseif"                { return ELSEIF; }
"end"                   { return END; }

"while"                 { return WHILE; }
"do"                    { return DO; }

"function"              { return FUNCTION; }
"return"                { return RETURN; }

"and"                   { return AND; }
"or"                    { return OR; }
"not"                   { return NOT; }

[0-9]+(\.[0-9]+)?       { yylval.str = strdup(yytext); return NUM; }


\"[^\"]*\"              { yylval.str = strdup(yytext); return STR; }
\'[^\']*\'              { yylval.str = strdup(yytext); return STR; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

"=="                    { return EQCOMPARE; }
"~="                    { return NOTEQ; }
">="                    { return GE; }
"<="                    { return LE; }

"="                     { return ASSIGN; }
">"                     { return GT; }
"<"                     { return LT; }

"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MULT; }
"/"                     { return DIV; }
"%"                     { return MOD; }

".."                    { return CONCAT; }

"("                     { return OP; }
")"                     { return CP; }
","                     { return COMMA; }
"{"                     { return OCUR; }
"}"                     { return CCUR; }
":"                     { return COLON; }

<<EOF>>                 { return ENDOFFILE; }

.                       { yyerror("Caractere invalido"); }

%%
