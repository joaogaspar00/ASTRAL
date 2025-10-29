# Nome do arquivo .bib
bib_file = "docs/refs.bib"

# Nome do arquivo de saída
output_file = "docs/theory/bibliography.md"

# Lista para armazenar as chaves
keys = []

# Abrir e ler o arquivo .bib
with open(bib_file, 'r', encoding='utf-8') as file:
    for line in file:
        line = line.strip()
        if line.startswith('@'):
            start = line.find('{') + 1
            end = line.find(',')
            key = line[start:end].strip()
            keys.append(key)

# Escrever as chaves no arquivo de saída com contagem
with open(output_file, 'w', encoding='utf-8') as f:
    for i, key in enumerate(keys, start=1):
        f.write(f":memo: @{key}\n\n")

print(f"Keys exported to {output_file} with numbering")
