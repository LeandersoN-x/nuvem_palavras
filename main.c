#include <stdio.h>

extern FILE *yyin;
int yyparse(void);

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) { perror(argv[1]); return 1; }
        yyin = f;
    }
    int r = yyparse();
    if (argc > 1) fclose(yyin);
    return r;
}
