%{
#include <string.h>
#include "lua2ruby.tab.h"
#include "transpiler.h"
%}

%option noyywrap nounput

%%
[ \t]+          { /* Ignora espaços e tabs */ }
--[^\n]* { /* Ignora comentários de linha (Lua) */ }
\n              { yylineno++; }

"local"         { return LOCAL; }
"print"         { return PRINT; }

"and"           { return AND; }
"or"            { return OR; }
"not"           { return NOT; }

[0-9]+          { yylval.str = strdup(yytext); return NUM; }
\"[^\"]*\"      { yylval.str = strdup(yytext); return STR; }
\'[^\']*\'      { yylval.str = strdup(yytext); return STR; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

"="             { return EQ; }
"+"             { return PLUS; } 
"-"             { return MINUS; } 
"*"             { return MULT; } 
"/"             { return DIV; } 

">="            { return GE; }
"<="            { return LE; }
"=="            { return EQCOMPARE; }
"~="            { return NOTEQ; }
">"             { return GT; }
"<"             { return LT; }

"("             { return OP; }
")"             { return CP; }

<<EOF>>         { return ENDOFFILE; }

.               { yyerror("Token desconhecido."); }
%%