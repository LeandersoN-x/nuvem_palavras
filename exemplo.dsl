# Entrada de exemplo para a DSL nuvem-dsl
CARREGA "feedback.txt";

IGNORA "de", "para", "com", "o", "a", "os", "as",
       "e", "é", "em", "um", "uma", "que", "do", "da";

FREQ_MIN 2;
MIN_LEN 3;

RENDERIZA NUVEM TOP 50 COLORMAP "viridis" SAIDA "nuvem.png";
