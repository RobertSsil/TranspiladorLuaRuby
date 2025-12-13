%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "transpiler.h"

int yylex();
int yyerror(const char *s);
%}

%union { char *str; }

/* TOKENS */
%token <str> ID NUM STR
%token LOCAL PRINT READ
%token IF THEN ELSE ELSEIF END
%token WHILE DO
%token FUNCTION RETURN
%token AND OR NOT
%token CONCAT
%token GE LE EQCOMPARE NOTEQ GT LT
%token ASSIGN PLUS MINUS MULT DIV MOD
%token OP CP COMMA
%token OCUR CCUR COLON
%token TRUE FALSE NIL
%token ENDOFFILE

%type <str> program statements_optional statements_list statement
%type <str> expr var_decl assignment print_stmt input_stmt
%type <str> if_stmt elseif_clauses else_clause
%type <str> while_loop func_decl func_call arg_list param_list
%type <str> table_decl table_body table_item

%left OR
%left AND
%left EQCOMPARE NOTEQ
%left GT LT GE LE
%left PLUS MINUS
%left MULT DIV MOD
%left CONCAT
%right NOT
%nonassoc UMINUS
%nonassoc THEN
%nonassoc ELSE

%%

program:
    statements_optional ENDOFFILE {
        fprintf(stderr, "\nTranspilação concluída com sucesso!\n");
        return 0;
    }
;

statements_optional:
      { $$ = strdup(""); }
    | statements_list { $$ = $1; }
;

statements_list:
      statement { /* $$ = $1;  Não é necessário, pois o print_ident() já imprime. */ }
    | statements_list statement { /* $$ = $1; */ }
;

statement:
      var_decl
    | assignment
    | print_stmt
    | input_stmt
    | if_stmt
    | while_loop
    | func_decl
    | func_call { free($1); } /* func_call precisa liberar a string alocada para $$ */
    | RETURN expr {
        print_ident();
        printf("return %s\n", $2);
        free($2);
    }
;

var_decl:
      LOCAL ID ASSIGN expr {
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

assignment:
      ID ASSIGN expr {
        print_ident();
        printf("%s = %s\n", $1, $3);
        free($1); free($3);
      }
;

input_stmt:
      LOCAL ID ASSIGN READ OP CP { 
        print_ident();
        printf("%s = gets.chomp.to_i\n", $2);
        free($2);
      }
    | ID ASSIGN READ OP CP { 
        print_ident();
        printf("%s = gets.chomp.to_i\n", $1);
        free($1);
      }
;

print_stmt:
      PRINT OP arg_list CP {
        print_ident();
        printf("puts %s\n", $3);
        free($3);
      }
    | PRINT arg_list {
        print_ident();
        printf("puts %s\n", $2);
        free($2);
      }
;

expr:
      NUM { $$ = strdup($1); free($1); }
    | STR { $$ = strdup($1); free($1); }
    | TRUE { $$ = strdup("true"); }
    | FALSE { $$ = strdup("false"); }
    | NIL { $$ = strdup("nil"); }
    | ID { $$ = strdup($1); free($1); }
    | func_call { $$ = $1; }
    | table_decl { $$ = $1; }
    | expr PLUS expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s + %s", $1,$3); free($1);free($3); }
    | expr MINUS expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s - %s", $1,$3); free($1);free($3); }
    | expr MULT expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s * %s", $1,$3); free($1);free($3); }
    | expr DIV expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s / %s", $1,$3); free($1);free($3); }
    | expr MOD expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s %% %s", $1,$3); free($1);free($3); }
   | expr CONCAT expr {
    // Aloca espaço para (operando1) + (operando2.to_s)
    $$=malloc(strlen($1)+strlen($3)+8); 
    // Garante que o segundo operando seja sempre uma string (usando .to_s)
    sprintf($$, "%s + %s.to_s", $1,$3); 
    free($1);free($3);
}
    | MINUS expr %prec UMINUS { $$=malloc(strlen($2)+2); sprintf($$, "-%s", $2); free($2); }
    | expr AND expr { $$=malloc(strlen($1)+strlen($3)+6); sprintf($$, "%s && %s", $1,$3); free($1);free($3); }
    | expr OR expr { $$=malloc(strlen($1)+strlen($3)+6); sprintf($$, "%s || %s", $1,$3); free($1);free($3); }
    | NOT expr { $$=malloc(strlen($2)+2); sprintf($$, "!%s", $2); free($2); }
    | expr GT expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s > %s", $1,$3); free($1);free($3); }
    | expr LT expr { $$=malloc(strlen($1)+strlen($3)+4); sprintf($$, "%s < %s", $1,$3); free($1);free($3); }
    | expr GE expr { $$=malloc(strlen($1)+strlen($3)+5); sprintf($$, "%s >= %s", $1,$3); free($1);free($3); }
    | expr LE expr { $$=malloc(strlen($1)+strlen($3)+5); sprintf($$, "%s <= %s", $1,$3); free($1);free($3); }
    | expr EQCOMPARE expr { $$=malloc(strlen($1)+strlen($3)+5); sprintf($$, "%s == %s", $1,$3); free($1);free($3); }
    | expr NOTEQ expr { $$=malloc(strlen($1)+strlen($3)+5); sprintf($$, "%s != %s", $1,$3); free($1);free($3); }
    | OP expr CP { $$=malloc(strlen($2)+3); sprintf($$, "(%s)", $2); free($2); }
;

/* IF */
if_stmt:
    IF expr THEN {
        print_ident();
        printf("if %s\n", $2);
        free($2);
        ident_level++;
    }
    statements_optional
    elseif_clauses
    else_clause
    END {
        ident_level--;
        print_ident();
        printf("end\n");
    }
;

elseif_clauses:
      { }
    | elseif_clauses ELSEIF expr THEN {
        ident_level--;
        print_ident();
        printf("elsif %s\n", $3);
        free($3);
        ident_level++;
      }
      statements_optional
;

else_clause:
      { $$ = strdup(""); }
    | ELSE {
        ident_level--;
        print_ident();
        printf("else\n");
        ident_level++;
      }
      statements_optional { $$ = strdup(""); } 
;

/* WHILE */
while_loop:
    WHILE expr DO {
        print_ident();
        printf("while %s\n", $2);
        free($2);
        ident_level++;
    }
    statements_optional
    END {
        ident_level--;
        print_ident();
        printf("end\n");
    }
;

/* FUNÇÕES */
func_decl:
    FUNCTION ID OP param_list CP {
        print_ident();
        printf("def %s(%s)\n", $2, $4);
        free($2); free($4);
        ident_level++;
    }
    statements_optional
    END {
        ident_level--;
        print_ident();
        printf("end\n");
    }
;

param_list:
      { $$=strdup(""); }
    | ID { $$=strdup($1); free($1); }
    | param_list COMMA ID {
        $$=malloc(strlen($1)+strlen($3)+3);
        sprintf($$, "%s, %s", $1, $3);
        free($1); free($3);
    }
;

/* CALLS */
func_call:
    ID OP arg_list CP {
        $$=malloc(strlen($1)+strlen($3)+3);
        sprintf($$, "%s(%s)", $1, $3);
        free($1); free($3);
    }
;

arg_list:
      { $$=strdup(""); }
    | expr { $$=strdup($1); free($1); }
    | arg_list COMMA expr {
        $$=malloc(strlen($1)+strlen($3)+3);
        sprintf($$, "%s, %s", $1, $3);
        free($1); free($3);
    }
;

/* TABLE */
table_decl:
    OCUR table_body CCUR {
        $$=strdup("nil");
    }
;

table_body:
      { $$=strdup(""); }
    | table_body table_item { $$=strdup(""); }
    | table_body COMMA table_item { $$=strdup(""); }
;

table_item:
      ID ASSIGN expr { free($1); free($3); $$=strdup(""); }
    | expr { free($1); $$=strdup(""); }
;

%%
int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    freopen("output.rb", "w", stdout);
    yyparse();
    return 0;
}