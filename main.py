"""
The code for the final project.


All data is from 2012.

Considering GDP per capita and Life Expectancy

Only entries in both data sets were used.

Appropriate adjustments were made, e.g. data from the keys
"Iran (Islamic Republic of)" and
"Iran, Islamic Republic of"
were modified to be matched together

GDP data format:
"Country or Area","Year","Item","Value"

Life expectancy data format:
"Country or Area","Year(s)","GENDER","Value","Value Footnotes"
gender is either "Male", "Female", or "Both sexes"
"""


import math
import statistics
import matplotlib

gdp_dict = {}
with open('data/gdp_per_capita.csv') as f:
  for line in f:
    row = line.strip().strip('"').split('","')
    country, year, item, gdp = row
    gdp = float(gdp)
    # print(f'{country} has GDP per capita {gdp}')
    gdp_dict[country] = gdp

countries = []
gdps = []
male = []
female = []
both = []
with open('data/life_expectancy.csv') as f:
  for line in f:
    row = line.strip()[:-3].strip('"').split('","')
    country, year, gender, years = row
    years = int(years)
    if country not in gdp_dict:
      continue
    if len(countries) == 0 or countries[-1] != country:
      countries.append(country)
      gdps.append(gdp_dict[country])
    if gender == 'Male':
      male.append(years)
    elif gender == 'Female':
      female.append(years)
    else:
      assert gender == 'Both sexes'
      both.append(years)

entries = len(countries)
assert len(gdps) == entries
assert len(male) == entries
assert len(female) == entries
assert len(both) == entries

tuples = list(zip(countries, gdps, male, female, both))
# tuples.sort(key=lambda t: t[3])
print('Country, GDP per capita, male exp, female exp, combined exp')
for t in tuples:
  print(t)

