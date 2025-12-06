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

// Tokens com valor semântico <str>
%token <str> ID NUM STR
// Tokens sem valor semântico
%token LOCAL PRINT EQ OP CP ENDOFFILE

// Tipos de retorno das regras
%type <str> PROGRAM CHUNK COMMANDS COMMAND EXPRESSION PRINT_CALL

%%

PROGRAM: CHUNK ENDOFFILE 
    { 
        printf("\n# Transpilação concluída (Variáveis e I/O)\n");
        return 0;
    }
;

CHUNK: COMMANDS
;

COMMANDS: COMMANDS COMMAND
    | /* empty */
    { $$ = ""; } 
;

// --- REGRAS DE COMANDO ---

COMMAND: ID EQ EXPRESSION 
    { 
        print_ident(); 
        printf("%s = %s\n", $1, $3); 
    }
    | LOCAL ID EQ EXPRESSION 
    { 
        print_ident(); 
        printf("%s = %s\n", $2, $4); 
    }
    | PRINT_CALL
;

// --- REQUISITO 2: COMANDO PARA ENTRADA E SAÍDA PADRÃO ---
PRINT_CALL: PRINT OP EXPRESSION CP 
    { 
        // print(EXPRESSION) (Lua) -> puts EXPRESSION (Ruby)
        print_ident(); 
        printf("puts %s\n", $3); 
        free($3); // Limpeza de memória
    }
;

// --- EXPRESSÕES (SUPORTA NUM, ID, STR) ---
EXPRESSION: NUM { $$ = strdup($1); free($1); }
    | ID { $$ = strdup($1); free($1); }
    | STR { $$ = strdup($1); free($1); }
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
            // Sucesso
        }
        
        fclose(stdout); 
        freopen("/dev/tty", "w", stdout); 
        printf("Transpilação concluída! Verifique o arquivo output.rb\n");

        fclose(yyin);
    }
    return 0;
}