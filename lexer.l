%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dsl.h"
#include "parser.tab.h"

int line_num = 1;
%}

%option noyywrap

%%
"CARREGA"    { return CARREGA; }
"IGNORA"     { return IGNORA; }
"FREQ_MIN"   { return FREQ_MIN; }
"FREQ_MAX"   { return FREQ_MAX; }
"MIN_LEN"    { return MIN_LEN; }
"RENDERIZA"  { return RENDERIZA; }
"NUVEM"      { return NUVEM; }
"TOP"        { return TOP; }
"COLORMAP"   { return COLORMAP; }
"SAIDA"      { return SAIDA; }
";"          { return SEMI; }
","          { return COMMA; }
[0-9]+       { yylval.num = atoi(yytext); return NUM; }
\"[^\"]*\"   {
                size_t len = strlen(yytext);
                yylval.str = (char *) malloc(len - 1);
                memcpy(yylval.str, yytext + 1, len - 2);
                yylval.str[len - 2] = '\0';
                return STRING;
             }
[ \t\r]+     { /* ignora */ }
\n           { line_num++; }
"#"[^\n]*    { /* comentário de linha */ }
.            { fprintf(stderr, "Erro lexico (linha %d): '%s'\n",
                       line_num, yytext); }
%%
