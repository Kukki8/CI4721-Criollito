#include <cstdio>
#include <cstdlib>

int yyparse(void);

int main(void) {
    if (yyparse() == 0) {
        printf("Parsing completado exitosamente.\n");
    } else {
        printf("Error en el parsing.\n");
    }
    return 0;
}

