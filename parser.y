%{
#include <stdio.h>
#include <stdlib.h>
#include "dsl.h"

extern int line_num;
int  yylex(void);
void yyerror(const char *s);
%}

%union {
    int      num;
    char    *str;
    StrList  sl;
}

%token CARREGA IGNORA FREQ_MIN FREQ_MAX MIN_LEN RENDERIZA
%token NUVEM TOP COLORMAP SAIDA SEMI COMMA
%token <num> NUM
%token <str> STRING
%type  <sl>  stop_list

%%

programa:
        comandos              { emit_python(&cfg); }
    ;

comandos:
        comando
      | comandos comando
    ;

comando:
        load_stmt
      | ignore_stmt
      | freq_stmt
      | render_stmt
    ;

load_stmt:
        CARREGA STRING SEMI   { cfg.source = $2; }
    ;

ignore_stmt:
        IGNORA stop_list SEMI { cfg.stopwords = $2; }
    ;

stop_list:
        STRING                {
                                  StrList l = {0};
                                  add_to_list(&l, $1);
                                  $$ = l;
                              }
      | stop_list COMMA STRING {
                                  add_to_list(&$1, $3);
                                  $$ = $1;
                              }
    ;

freq_stmt:
        FREQ_MIN NUM SEMI     { cfg.freq_min = $2; cfg.has_freq_min = 1; }
      | FREQ_MAX NUM SEMI     { cfg.freq_max = $2; cfg.has_freq_max = 1; }
      | MIN_LEN  NUM SEMI     { cfg.min_len  = $2; cfg.has_min_len  = 1; }
    ;

render_stmt:
        RENDERIZA NUVEM TOP NUM
          COLORMAP STRING SAIDA STRING SEMI
        {
            cfg.max_words = $4;
            cfg.colormap  = $6;
            cfg.output    = $8;
        }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintatico (linha %d): %s\n", line_num, s);
}
