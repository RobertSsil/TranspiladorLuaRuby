#include "transpiler.h"

#define IDENT_SPACES 2
int ident_level = 0;

int yyerror(const char *error) {
    fprintf(stderr, "Erro na linha %d: %s\n", yylineno, error);
    return 1;
}

void print_ident() {
    for (int i = 0; i < ident_level * IDENT_SPACES; i++) {
        printf(" ");
    }
}