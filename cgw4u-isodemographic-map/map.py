"""
Code to generate the isodemographic map!
"""

import csv
import numpy as np
import os
from PIL import Image


IMAGE_DIRECTORY = 'img'


def debug_image(im):
    a = im.load()
    for i in range(0, im.height, 3):
        for j in range(0, im.width, 3):
            print(a[j, i])
            c = '#' if a[j, i][2] > 0 else ' '
            print(c, end='')
        print()


class Country:
    def __init__(self, name):
        self.name = name
        self.pixels = None
        self.x = 0
        self.y = 0
        self.area = 0
        self.birth_rate = None
        pass


d = dict()
countries = [s[:-4] for s in os.listdir(IMAGE_DIRECTORY)]
for country in countries:
    d[country] = Country(country)
    im = Image.open(f'{IMAGE_DIRECTORY}/{country}.png')
    d[country].pixels = im.load()

with open('live_birth_data/data.csv') as csv_file:
    reader = csv.reader(csv_file)
    for row in reader:
        if len(row) >= 4:
            print(row[-4])

countries = [s[:-4] for s in os.listdir(IMAGE_DIRECTORY)]
n = len(countries)



SQUARE_SIZE = 10

pixels = [
    [(54, 54, 54), (232, 23, 93), (71, 71, 71), (168, 167, 167)],
    [(204, 82, 122), (54, 54, 54), (168, 167, 167), (232, 23, 93)],
    [(71, 71, 71), (168, 167, 167), (54, 54, 54), (204, 82, 122)],
    [(168, 167, 167), (204, 82, 122), (232, 23, 93), (54, 54, 54)]
]

# Convert the pixels into an array using numpy
array = np.array(pixels, dtype=np.uint8)

# Use PIL to create an image from the new array of pixels
new_image = Image.fromarray(array)
new_image.save('new.png')