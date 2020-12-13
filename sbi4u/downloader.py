"""
I don't recommend actually running this script.
"""


import requests
from time import sleep

url = 'http://k12resources.nelson.com/science/9780176939137/student/files/mobile/{}.jpg'

for i in range(1, 768):
    image = requests.get(url.format(i))
    open(f'textbook/{i}.jpg', 'wb').write(image.content)
    sleep(0.2)