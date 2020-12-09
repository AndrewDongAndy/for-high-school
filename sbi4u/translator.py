dna_to_rna = {
    'a': 'u',
    'c': 'g',
    'g': 'c',
    't': 'a',
}

rna_to_amino = {}
with open('map.txt') as f:
    for line in f:
        codon, amino = line.split()
        rna_to_amino[codon] = amino


def transcribe(s):
    try:
        res = [dna_to_rna[c] for c in s]
        return ''.join(res)
    except KeyError as e:
        print(f'invalid string to transcribe: one of the bases is {e.args[0]}')
        return '[invalid input]'

def translate(s):
    if len(s) % 3 != 0:
        print(f'invalid string to translate: length is not a multiple of 3')
        return '[invalid input]'
    try:
        res = [rna_to_amino[s[3 * i : 3 * (i + 1)]] for i in range(len(s) // 3)]
        return ' '.join(res)
    except KeyError as e:
        print(f'invalid string to translate: one of the codons is {e.args[0]}')
        return '[invalid input]'



with open('result.txt', 'w') as f:
    def output(s):
        print(s)
        f.write(f'{s}\n')
    
    while True:
        print('Select option:')
        print('1 - transcribe DNA to RNA')
        print('2 - translate RNA to proteins')
        print('3 - go from DNA to proteins')
        print('4 - quit')
        op = int(input())
        if op == 4:
            break
        print('Enter a string.')
        s = input().lower()
        if op == 1:
            output('DNA to RNA:\n')
            output(f'{s} -> {transcribe(s)}\n\n')
        elif op == 2:
            output('RNA to amino acid:\n')
            output(f'{s} -> {translate(s)}\n\n')
        else:
            output('DNA to amino acid:\n')
            output(f'{s} -> {translate(transcribe(s))}\n\n')

print('The results are saved in result.txt.')
print('Good luck with the rest of the course!')