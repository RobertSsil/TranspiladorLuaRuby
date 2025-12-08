#ifndef TRANSPILER_H
#define TRANSPILER_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;
extern char *yytext;
extern FILE *yyin;
extern int ident_level;

int yyerror(const char *s);
void print_ident();

#endif