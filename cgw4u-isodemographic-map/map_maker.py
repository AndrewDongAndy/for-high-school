"""
The program that makes the map.
"""


import numpy as np
from PIL import Image, ImageDraw, ImageFont


ARIAL_FONT_PATH = 'C:/Windows/Fonts/arial.ttf'
OUTPUT_FILENAME = 'map.png'

S = 10  # square side length for each population square
OPACITY = 255

RED = (212, 0, 0, OPACITY)
DARK_ORANGE = (212, 120, 15, OPACITY)
LIGHT_ORANGE = (254, 173, 92, OPACITY)
YELLOW = (237, 223, 19, OPACITY)
WHITE = (255, 255, 255, OPACITY)
BLACK = (0, 0, 0, OPACITY)

def get_color(birth_rate):
    if birth_rate > 34.95:
        return RED
    if birth_rate > 29.95:
        return DARK_ORANGE
    if birth_rate > 19.95:
        return LIGHT_ORANGE
    return YELLOW


HEIGHT = 145
WIDTH = 280
SHIFT_X = 120
SHIFT_Y = 90

a = [[-1 for j in range(WIDTH)] for i in range(HEIGHT)]


countries = []
xs = []
ys = []
birth_rates = []
colors = []
shapes = []

with open('clean_data/shape.txt') as f:
    while True:
        c = f.readline().strip()
        if not c:
            break
        y, x = [int(s) for s in f.readline().split()]
        y = -y
        n, m = [int(s) for s in f.readline().split()]
        b = float(f.readline())
        a = []
        blank = 0
        for i in range(n):
            row = [int(c) for c in f.readline().strip()]
            if sum(row) > 0:
                a.append(row)
            else:
                blank += 1
        assert blank == 0
        n -= blank
        countries.append(c)
        xs.append(x + SHIFT_X)
        ys.append(y + SHIFT_Y)
        birth_rates.append(b)
        if b > 34.95:
            colors.append('red')
        elif b > 29.95:
            colors.append('dark orange')
        elif b > 19.95:
            colors.append('light orange')
        else:
            colors.append('yellow')
        shapes.append(a)

with open('submit.txt', 'w') as f:
    for country, a, color, b in zip(countries, shapes, colors, birth_rates):
        squares = sum(sum(row) for row in a)
        f.write(f'{country}\t{squares}\t{color}\t{b}\n')

# print(min(xs), max(xs))
# print(min(ys), max(ys))

n = len(countries)
ids = [[-1 for j in range(WIDTH)] for i in range(HEIGHT)]  # store ids
a = [[WHITE for j in range(WIDTH)] for i in range(HEIGHT)]  # colors


for id, (country, x, y, b, shape) in enumerate(zip(countries, xs, ys, birth_rates, shapes)):
    n = len(shape)
    m = len(shape[0])
    x -= m // 2
    y -= n // 2
    for i in range(len(shape)):
        for j in range(len(shape[i])):
            if shape[i][j] != 1:
                continue
            assert 0 <= y + i and y + i < HEIGHT
            assert 0 <= x + j and x + j < WIDTH
            if ids[y + i][x + j] != -1:
                print(countries[id], countries[ids[y + i][x + j]])  # check for overlap
            ids[y + i][x + j] = id  # store ids
            a[y + i][x + j] = get_color(b)


new_a = []
for row in a:
    new_row = []
    for x in row:
        for j in range(S):
            new_row.append(x)
    for i in range(S):
        new_a.append([x for x in new_row])
a = [[j for j in row] for row in new_a]


for i in range(WIDTH * S):
    if a[SHIFT_Y * S][i] == WHITE:
        a[SHIFT_Y * S][i] = BLACK
for i in range(HEIGHT * S):
    if a[i][SHIFT_X * S] == WHITE:
        a[i][SHIFT_X * S] = BLACK

# Convert the pixels into an array using numpy
array = np.array(a, dtype=np.uint8)

# Use PIL to create an image from the new array of pixels
res = Image.fromarray(array)

# make a blank image for the text, initialized to transparent text color
txt = Image.new("RGBA", res.size, (255, 255, 255, 0))
d = ImageDraw.Draw(txt)


small_arial = ImageFont.truetype(ARIAL_FONT_PATH, 14)
for country, x, y in zip(countries, xs, ys):
    x *= S
    y *= S
    # w, h = d.textsize(country)
    # x -= w // 2
    # y -= h // 2
    d.text((x, y), country, fill=(0, 0, 0, 255), font=small_arial, anchor='mm')

title_arial = ImageFont.truetype(ARIAL_FONT_PATH, 60)
d.text((WIDTH * S // 2, 100), 'Isodemographic Map by Andy Dong',
    fill=(0, 0, 0, 255),
    font=title_arial,
    anchor='mm'
)

res.paste(txt, mask=txt)
res.save(OUTPUT_FILENAME)
# out = Image.alpha_composite(res, txt)
# out.save(OUTPUT_FILENAME)
