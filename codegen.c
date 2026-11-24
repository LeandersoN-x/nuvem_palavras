#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dsl.h"

Config cfg = {0};

void add_to_list(StrList *l, const char *s) {
    if (l->n == l->cap) {
        l->cap = l->cap ? l->cap * 2 : 8;
        l->items = (char **) realloc(l->items, l->cap * sizeof(char *));
    }
    l->items[l->n++] = strdup(s);
}

static void py_string(FILE *f, const char *s) {
    fputc('"', f);
    for (; *s; s++) {
        if (*s == '"' || *s == '\\') fputc('\\', f);
        fputc(*s, f);
    }
    fputc('"', f);
}

void emit_python(const Config *c) {
    if (!c->source) {
        fprintf(stderr, "Erro semantico: faltou o comando CARREGA.\n");
        exit(1);
    }
    if (!c->output) {
        fprintf(stderr, "Erro semantico: faltou o comando RENDERIZA.\n");
        exit(1);
    }

    FILE *f = fopen("generated_wordcloud.py", "w");
    if (!f) { perror("fopen"); exit(1); }

    fprintf(f, "# -*- coding: utf-8 -*-\n");
    fprintf(f, "# Gerado automaticamente pela DSL nuvem-dsl\n");
    fprintf(f, "from wordcloud import WordCloud\n");
    fprintf(f, "import re\n");
    fprintf(f, "from collections import Counter\n\n");

    fprintf(f, "SOURCE = ");   py_string(f, c->source);   fprintf(f, "\n");
    fprintf(f, "STOPWORDS = {");
    for (int i = 0; i < c->stopwords.n; i++) {
        if (i) fprintf(f, ", ");
        py_string(f, c->stopwords.items[i]);
    }
    fprintf(f, "}\n");

    if (c->has_freq_min) fprintf(f, "FREQ_MIN = %d\n", c->freq_min);
    else                 fprintf(f, "FREQ_MIN = None\n");
    if (c->has_freq_max) fprintf(f, "FREQ_MAX = %d\n", c->freq_max);
    else                 fprintf(f, "FREQ_MAX = None\n");
    if (c->has_min_len)  fprintf(f, "MIN_LEN  = %d\n", c->min_len);
    else                 fprintf(f, "MIN_LEN  = 1\n");

    fprintf(f, "MAX_WORDS = %d\n", c->max_words > 0 ? c->max_words : 50);
    fprintf(f, "COLORMAP  = "); py_string(f, c->colormap ? c->colormap : "viridis");
    fprintf(f, "\nOUTPUT    = "); py_string(f, c->output); fprintf(f, "\n\n");

    fprintf(f,
        "with open(SOURCE, encoding='utf-8') as fh:\n"
        "    text = fh.read().lower()\n\n"
        "tokens = re.findall(r'[a-z\\u00e0-\\u00ff]+', text)\n"
        "tokens = [t for t in tokens\n"
        "          if t not in STOPWORDS and len(t) >= MIN_LEN]\n\n"
        "counter = Counter(tokens)\n"
        "if FREQ_MIN is not None:\n"
        "    counter = Counter({k: v for k, v in counter.items() if v >= FREQ_MIN})\n"
        "if FREQ_MAX is not None:\n"
        "    counter = Counter({k: v for k, v in counter.items() if v <= FREQ_MAX})\n\n"
        "top = dict(counter.most_common(MAX_WORDS))\n"
        "if not top:\n"
        "    raise SystemExit('Nenhuma palavra atende aos filtros.')\n\n"
        "wc = WordCloud(\n"
        "    width=1200, height=800, background_color='white',\n"
        "    colormap=COLORMAP.lower(), prefer_horizontal=0.9,\n"
        ").generate_from_frequencies(top)\n"
        "wc.to_file(OUTPUT)\n"
        "print(f'Nuvem salva em {OUTPUT} ({len(top)} palavras)')\n"
    );

    fclose(f);
    printf("Codigo Python gerado: generated_wordcloud.py\n");
}
