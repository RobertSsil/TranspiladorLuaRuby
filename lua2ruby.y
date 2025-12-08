%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "transpiler.h"

int yylex();
int yyerror(const char *s);
%}

%union {
    char *str;
}

/* Tokens */
%token <str> ID NUM STR BOOL
%token LOCAL PRINT
%token IF THEN ELSE ELSEIF END
%token AND OR NOT CONCAT
%token GE LE EQCOMPARE NOTEQ GT LT
%token EQ PLUS MINUS MULT DIV
%token OP CP
%token ENDOFFILE

/* Tipos não-terminais */
%type <str> program chunk statement
%type <str> expr var_decl assignment print_stmt
%type <str> if_stmt elseif_clauses else_clause block

/* Precedência */
%left OR
%left AND
%left EQCOMPARE NOTEQ
%left GT LT GE LE
%left PLUS MINUS
%left MULT DIV
%left CONCAT
%right NOT
%nonassoc UMINUS

%%

program: chunk ENDOFFILE {
    fprintf(stderr, "\n Transpilação concluída com sucesso!\n");
    return 0;
}
;

chunk: 
    | chunk statement
;

statement: var_decl
    | assignment
    | print_stmt
    | if_stmt
    | error '\n' { yyerrok; }
;

/* 1. DECLARAÇÃO/ATRIBUIÇÃO DE VARIÁVEIS */
var_decl: LOCAL ID EQ expr {
    print_ident();
    printf("%s = %s\n", $2, $4);
    free($2); free($4);
}
| LOCAL ID {
    print_ident();
    printf("%s = nil\n", $2);
    free($2);
}
;

assignment: ID EQ expr {
    print_ident();
    printf("%s = %s\n", $1, $3);
    free($1); free($3);
}
;

/* 2. ENTRADA/SAÍDA */
print_stmt: PRINT OP expr CP {
    print_ident();
    printf("puts %s\n", $3);
    free($3);
}
| PRINT expr {
    print_ident();
    printf("puts %s\n", $2);
    free($2);
}
;

/* 3. & 4. EXPRESSÕES ARITMÉTICAS, LÓGICAS E CONCATENAÇÃO */
expr: NUM { $$ = strdup($1); free($1); }
    | STR { $$ = strdup($1); free($1); }
    | BOOL { $$ = strdup($1); free($1); }
    | ID { $$ = strdup($1); free($1); }
    | expr PLUS expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s + %s", $1, $3);
        free($1); free($3);
    }
    | expr MINUS expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s - %s", $1, $3);
        free($1); free($3);
    }
    | expr MULT expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s * %s", $1, $3);
        free($1); free($3);
    }
    | expr DIV expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s / %s", $1, $3);
        free($1); free($3);
    }
    | expr CONCAT expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s + %s", $1, $3);
        free($1); free($3);
    }
    | MINUS expr %prec UMINUS {
        $$ = malloc(strlen($2) + 2);
        sprintf($$, "-%s", $2);
        free($2);
    }
    | expr AND expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s && %s", $1, $3);
        free($1); free($3);
    }
    | expr OR expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s || %s", $1, $3);
        free($1); free($3);
    }
    | NOT expr {
        $$ = malloc(strlen($2) + 2);
        sprintf($$, "!%s", $2);
        free($2);
    }
    | expr GT expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s > %s", $1, $3);
        free($1); free($3);
    }
    | expr LT expr {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s < %s", $1, $3);
        free($1); free($3);
    }
    | expr GE expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s >= %s", $1, $3);
        free($1); free($3);
    }
    | expr LE expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s <= %s", $1, $3);
        free($1); free($3);
    }
    | expr EQCOMPARE expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s == %s", $1, $3);
        free($1); free($3);
    }
    | expr NOTEQ expr {
        $$ = malloc(strlen($1) + strlen($3) + 5);
        sprintf($$, "%s != %s", $1, $3);
        free($1); free($3);
    }
    | OP expr CP {
        $$ = malloc(strlen($2) + 3);
        sprintf($$, "(%s)", $2);
        free($2);
    }
;

/* 5. COMANDOS CONDICIONAIS */
if_stmt: IF expr THEN {
        print_ident();
        printf("if %s\n", $2);
        free($2);
        ident_level++;
    }
    block
    elseif_clauses
    else_clause
    END {
        ident_level--;
        print_ident();
        printf("end\n");
    }
;

elseif_clauses: 
    | elseif_clauses ELSEIF expr THEN {
        ident_level--;
        print_ident();
        printf("elsif %s\n", $3);
        free($3);
        ident_level++;
    }
    block
;

else_clause: 
    | ELSE {
        ident_level--;
        print_ident();
        printf("else\n");
        ident_level++;
    }
    block
;

/* BLOCO DE CÓDIGO */
block: 
    | block statement
;

%%

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s arquivo.lua\n", argv[0]);
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Erro: Não foi possível abrir %s\n", argv[1]);
        return 1;
    }
    
    if (freopen("output.rb", "w", stdout) == NULL) {
        fprintf(stderr, "Erro ao criar output.rb\n");
        fclose(yyin);
        return 1;
    }
    
    fprintf(stderr, "Transpilando Lua → Ruby...\n");
    
    if (yyparse() == 0) {
        fprintf(stderr, "Arquivo 'output.rb' gerado com sucesso!\n");
    } else {
        fprintf(stderr, " Transpilação falhou\n");
    }
    
    fclose(stdout);
    fclose(yyin);
    
    // Restaura stdout
    freopen("/dev/tty", "w", stdout);
    
    return 0;
}