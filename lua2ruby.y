%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "transpiler.h"

int yyerror(char *s);
extern int yylex();
%}

%union {
    char *str;
}

%token <str> ID NUM STR
%token LOCAL PRINT EQ OP CP ENDOFFILE
%token PLUS MINUS MULT DIV

%type <str> PROGRAM CHUNK COMMANDS COMMAND EXPRESSION PRINT_CALL

%left PLUS MINUS
%left MULT DIV

%%

PROGRAM: CHUNK ENDOFFILE 
    { 
        printf("\n# Transpilação concluída (Variáveis, I/O e Aritmética)\n");
        return 0;
    }
;

CHUNK: COMMANDS
;

COMMANDS: COMMANDS COMMAND
    | /* empty */
    { $$ = ""; } 
;

COMMAND: ID EQ EXPRESSION 
    { 
        print_ident(); 
        printf("%s = %s\n", $1, $3); 
        free($3);
    }
    | LOCAL ID EQ EXPRESSION 
    { 
        print_ident(); 
        printf("%s = %s\n", $2, $4); 
        free($4);
    }
    | PRINT_CALL
;

PRINT_CALL: PRINT OP EXPRESSION CP 
    { 
        print_ident(); 
        printf("puts %s\n", $3); 
        free($3);
    }
;

// --- REQUISITO 3: EXPRESSÕES ARITMÉTICAS REFINADAS ---
EXPRESSION: NUM { 
        $$ = strdup($1); 
        free($1); 
    }
    | ID { 
        $$ = strdup($1); 
        free($1); 
    }
    | STR { 
        $$ = strdup($1); 
        free($1); 
    }
    
    | EXPRESSION PLUS EXPRESSION { 
        char *temp = (char*)malloc(strlen($1) + strlen($3) + 10);
        sprintf(temp, "%s + %s", $1, $3); 
        $$ = temp;
        free($1); free($3); 
    }
    | EXPRESSION MINUS EXPRESSION { 
        char *temp = (char*)malloc(strlen($1) + strlen($3) + 10);
        sprintf(temp, "%s - %s", $1, $3); 
        $$ = temp;
        free($1); free($3); 
    }
    | EXPRESSION MULT EXPRESSION { 
        char *temp = (char*)malloc(strlen($1) + strlen($3) + 10);
        sprintf(temp, "%s * %s", $1, $3); 
        $$ = temp;
        free($1); free($3); 
    }
    | EXPRESSION DIV EXPRESSION { 
        char *temp = (char*)malloc(strlen($1) + strlen($3) + 10);
        sprintf(temp, "%s / %s", $1, $3); 
        $$ = temp;
        free($1); free($3); 
    }
    
    | OP EXPRESSION CP { 
        char *temp = (char*)malloc(strlen($2) + 10);
        sprintf(temp, "(%s)", $2);
        $$ = temp;
        free($2);
    }
;

%%

int main(int argc, char **argv){
    if(argc!=2)
        fprintf(stderr, "Modo de uso: ./transpiler arquivo.lua\n");
    else{
        yyin = fopen(argv[1], "r");
        if(!yyin){
            fprintf(stderr, "Arquivo %s não encontrado!\n", argv[1]);
            return -1;
        }

        if (freopen("output.rb", "w", stdout) == NULL) {
            fprintf(stderr, "Erro ao abrir output.rb para escrita.\n");
            fclose(yyin);
            return -1;
        }

        if( yyparse() == 0 ) {
        }
        
        fclose(stdout); 
        freopen("/dev/tty", "w", stdout); 
        printf("Transpilação concluída! Verifique o arquivo output.rb\n");

        fclose(yyin);
    }
    return 0;
}