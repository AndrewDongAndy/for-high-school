"""
I don't recommend actually running this script.
"""

from fpdf import FPDF
from pathlib import Path
import requests
from time import sleep

# biology
# URL_BASE = 'http://k12resources.nelson.com/science/9780176939137/student/files/mobile/{}.jpg'

# chemistry
URL_BASE = 'https://k12resources.nelson.com/science/9780176939199/student/files/mobile/{}.jpg'
PAGES_DIRECTORY = 'pages'

UNIT = 'mm'
WIDTH = 210
HEIGHT = 268


def url_for_id(id):
    return URL_BASE.format(id)


def page_to_id(page):
    return page + 8


def download_pdf(start_id, end_id):
    pdf = FPDF(unit=UNIT, format=(WIDTH, HEIGHT))
    for id in range(start_id, end_id + 1):
        image_file = f'{PAGES_DIRECTORY}/{id}.jpg'
        if not Path(image_file).is_file():
            url = url_for_id(id)
            image = requests.get(url)
            open(image_file, 'wb').write(image.content)
            print(f'downloaded id {id}')
            sleep(0.2)
        pdf.add_page()
        pdf.image(image_file, x=0, y=0, w=WIDTH)
    pdf.output(f'ids_{start_id}to{end_id}.pdf', 'F')


HOMEOSTASIS_UNIT_START_PAGE = 422
END_PAGE = 541

download_pdf(
    page_to_id(HOMEOSTASIS_UNIT_START_PAGE),
    page_to_id(480)
)
