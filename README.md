# Dependências (uma vez)
sudo apt install flex bison gcc
pip install wordcloud matplotlib

# Compilar a DSL
make

# Transpilar e executar
./nuvem-dsl exemplo.dsl
python3 generated_wordcloud.py
