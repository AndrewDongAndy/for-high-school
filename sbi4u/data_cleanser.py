order = 'ucag'
with open('data.txt') as f:
    data = f.readline().split()

d = {}
p = 0
for a in order:
    for b in order:
        for c in order:
            d[a + b + c] = data[p]
            p += 1
for k, v in d.items():
    print(k, v)
print(len(d))

with open('map.txt', 'w') as f:
    for k, v in d.items():
        if v != 'stop':
            v = v.title()
        f.write(f'{k} {v}\n')