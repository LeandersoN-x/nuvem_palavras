# -*- coding: utf-8 -*-
# Gerado automaticamente pela DSL nuvem-dsl
from wordcloud import WordCloud
import re
from collections import Counter

SOURCE = "feedback.txt"
STOPWORDS = {"de", "para", "com", "o", "a", "os", "as", "e", "é", "em", "um", "uma", "que", "do", "da"}
FREQ_MIN = 2
FREQ_MAX = None
MIN_LEN  = 3
MAX_WORDS = 50
COLORMAP  = "viridis"
OUTPUT    = "nuvem.png"

with open(SOURCE, encoding='utf-8') as fh:
    text = fh.read().lower()

tokens = re.findall(r'[a-z\u00e0-\u00ff]+', text)
tokens = [t for t in tokens
          if t not in STOPWORDS and len(t) >= MIN_LEN]

counter = Counter(tokens)
if FREQ_MIN is not None:
    counter = Counter({k: v for k, v in counter.items() if v >= FREQ_MIN})
if FREQ_MAX is not None:
    counter = Counter({k: v for k, v in counter.items() if v <= FREQ_MAX})

top = dict(counter.most_common(MAX_WORDS))
if not top:
    raise SystemExit('Nenhuma palavra atende aos filtros.')

wc = WordCloud(
    width=1200, height=800, background_color='white',
    colormap=COLORMAP.lower(), prefer_horizontal=0.9,
).generate_from_frequencies(top)
wc.to_file(OUTPUT)
print(f'Nuvem salva em {OUTPUT} ({len(top)} palavras)')
