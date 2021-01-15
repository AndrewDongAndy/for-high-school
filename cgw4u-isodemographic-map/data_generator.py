"""
Code to generate the isodemographic map!

Country shape images: https://www.jetpunk.com/user-quizzes/6121/every-country-shape
Live birth area data: https://data.worldbank.org/indicator/SP.DYN.CBRT.IN
Land area data: https://data.worldbank.org/indicator/AG.LND.TOTL.K2
Position data: https://developers.google.com/public-data/docs/canonical/countries_csv
"""

import csv
import os
from PIL import Image

IMAGE_DIRECTORY = 'images'

REPLACEMENTS = [
    ('Congo, Dem. Rep.', 'Democratic Republic of the Congo'),
    ('Egypt, Arab Rep.', 'Egypt'),
    ('Iran, Islamic Rep.', 'Iran'),
    ('Russian Federation', 'Russia'),
    ('Syrian Arab Republic', 'Syria'),
    ('United States', 'United States of America'),
]

PEOPLE_PER_SQUARE = 7777777


def debug_image(im):
    a = im.load()
    for i in range(0, im.height, 3):
        for j in range(0, im.width, 3):
            print(a[j, i])
            c = '#' if a[j, i][2] > 0 else ' '
            print(c, end='')
        print()

def image_to_array(im):
    a = im.load()
    return [[1 if a[x, y][2] > 0 else 0 for x in range(im.width)] for y in range(im.height)]

def debug_array(a, skip=1):
    for i in range(0, len(a), skip):
        for j in range(0, len(a[i]), skip):
            print(a[i][j], end='')
        print()

def area(im):
    a = image_to_array(im)
    return sum(sum(row) for row in a)


class Country:
    def __init__(self, name):
        self.name = name
        self.pixels = None
        self.x = self.y = None
        self.area = 0  # in km^2
        self.birth_rate = None
        self.squares = None
        pass

    def __repr__(self):
        return repr(self.__dict__)
        # return f'Country(name={repr(self.name)}, birth_rate={repr(self.birth_rate)})'


d = dict()
countries = [s[:-4] for s in os.listdir(IMAGE_DIRECTORY)]
for country in countries:
    d[country] = Country(country)
    im = Image.open(f'{IMAGE_DIRECTORY}/{country}.png')
    d[country].pixels = image_to_array(im)


with open('position.txt') as f:
    for line in f:
        s = line.split()
        s[3] = ' '.join(s[3:])
        _, x, y, c = s[:4]
        if c not in d:
            continue
        x = round(float(x))
        y = round(float(y))
        d[c].x = x
        d[c].y = y
for k, c in d.items():
    if c.x == None:
        print(k)

# BIRTH_DATA_FILE = 'live_birth_data/data.csv'
BIRTH_DATA_FILE = 'birth_rate_data.csv'
with open(BIRTH_DATA_FILE) as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
        # print(row)
        country = row['Country Name']
        for a, b in REPLACEMENTS:
            country = country.replace(a, b)
        if country not in d:
            continue
        birth_rate = float(row['2015'])
        d[country].birth_rate = birth_rate

for k, v in d.items():
    if v.birth_rate is None:
        print(k)
# exit()

clean_f = open('clean_data/shape.txt', 'w')
with open('pop.txt') as f:
    data = f.readlines()
    for i in range(0, len(data), 2):
        country = data[i].strip()
        pop = int(data[i + 1].replace(',', ''))
        squares = round(pop / PEOPLE_PER_SQUARE)
        assert squares > 0
        a = d[country].pixels
        for skip in range(100, 0, -1):
            b = [[a[i][j] for j in range(0, len(a[i]), skip)] for i in range(0, len(a), skip)]
            s = sum(sum(row) for row in b)
            if s >= squares:
                for i in range(len(b)):
                    for j in range(len(b[i])):
                        if s > squares and b[i][j] == 1:
                            b[i][j] = 0
                            s -= 1
                while len(b) > 0 and sum(b[0]) == 0:
                    b.pop(0)
                while len(b) > 0 and sum(b[-1]) == 0:
                    b.pop(-1)
                while len(b[0]) > 0 and sum(row[0] for row in b) == 0 :
                    for i in range(len(b)):
                        b[i].pop(0)
                while len(b[0]) > 0 and sum(row[-1] for row in b) == 0 :
                    for i in range(len(b)):
                        b[i].pop(-1)
                clean_f.write(f'{country}\n')
                if country == 'India':
                    # manual adjustments to avoid overlap
                    d[country].x = 20
                    d[country].y = 77
                clean_f.write(f'{d[country].x} {d[country].y}\n')
                clean_f.write(f'{len(b)} {len(b[0])}\n')
                clean_f.write(f'{d[country].birth_rate}\n')
                for row in b:
                    for i in row:
                        clean_f.write(str(i))
                    clean_f.write('\n')
                break
clean_f.close()
exit()

with open('land_area_data/data.csv') as csv_file:
    reader = csv.DictReader(csv_file)
    for row in reader:
        country = row['Country Name']
        for a, b in REPLACEMENTS:
            country = country.replace(a, b)
        if country not in d:
            continue
        area = -1
        for i in range(2020, 1959, -1):
            s = str(i)
            if len(row[s]) > 0:
                area = float(row[s])
        assert area != -1
        d[country].area = area
