%{
#include <string.h>
#include "lua2ruby.tab.h"
#include "transpiler.h"
%}

%option noyywrap nounput noinput

%%

[ \t]+          { /* ignorar espaços */ }
\n              { yylineno++; }

"--".*          { /* comentário Lua */ }

"local"         { return LOCAL; }
"print"         { return PRINT; }

"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
"elseif"        { return ELSEIF; }
"end"           { return END; }

"and"           { return AND; }
"or"            { return OR; }
"not"           { return NOT; }

"true"          { yylval.str = strdup("true"); return BOOL; }
"false"         { yylval.str = strdup("false"); return BOOL; }

[0-9]+          { yylval.str = strdup(yytext); return NUM; }
\"[^\"]*\"      { yylval.str = strdup(yytext); return STR; }
\'[^\']*\'      { yylval.str = strdup(yytext); return STR; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

".."            { return CONCAT; }

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

.               { yyerror("Caractere inválido"); }

%%