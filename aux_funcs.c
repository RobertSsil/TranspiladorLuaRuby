#include "transpiler.h"

#define IDENT_SPACES 2

int ident_level = 0;

int yyerror(char* error){
	fprintf(stderr, "Error at line %d: %s\nIn: %s\n", yylineno, error, yytext);
    return 1;
}

void print_ident(){
	int i, j;
	for(i=0; i<ident_level; i++)
		for(j=0; j<IDENT_SPACES; j++)
			printf(" ");
}