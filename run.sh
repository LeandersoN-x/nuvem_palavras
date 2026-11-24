#!/bin/bash
set -e
make
./nuvem-dsl "${1:-exemplo.dsl}"
python3 generated_wordcloud.py
