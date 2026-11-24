#ifndef DSL_H
#define DSL_H

typedef struct {
    char **items;
    int n;
    int cap;
} StrList;

typedef struct {
    char    *source;
    StrList  stopwords;
    int      freq_min, freq_max, min_len, max_words;
    int      has_freq_min, has_freq_max, has_min_len;
    char    *colormap;
    char    *output;
} Config;

extern Config cfg;

void add_to_list(StrList *l, const char *s);
void emit_python(const Config *c);

#endif
