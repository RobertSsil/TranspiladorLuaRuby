#ifndef TRANSPLILER_H
#define TRANSPLILER_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h> 

extern int yylineno;
extern char *yytext;
extern FILE *yyin;

extern int ident_level;

int yyerror(char* error);
void print_ident();

#endif