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


import statistics

import numpy as np

gdp_dict = {}
with open('data_files/gdp_per_capita.csv') as f:
    for line in f:
        row = line.strip().strip('"').split('","')
        country, year, item, gdp = row
        gdp = float(gdp)
        # print(f'{country} has GDP per capita {gdp}')
        gdp_dict[country] = gdp

pop_dict = {}
with open('data_files/population.csv') as f:
    for line in f:
        row = line.strip().strip('"').split('","')
        # print(row)
        country, year, _, p = row
        p = int(float(p) * 1000)
        pop_dict[country] = p

countries = []
pop = []
gdps = []
male = []
female = []
both = []
with open('data_files/life_expectancy.csv') as f:
    for line in f:
        row = line.strip()[:-3].strip('"').split('","')
        country, year, gender, years = row
        years = int(years)
        if country not in gdp_dict:
            # print(country)
            continue
        if country not in pop_dict:
            # print(country)
            continue
        if len(countries) == 0 or countries[-1] != country:
            countries.append(country)
            gdps.append(gdp_dict[country])
            pop.append(pop_dict[country])
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
print(f'ok total {entries} entries')

data = list(zip(countries, pop, gdps, male, female, both))

mean = statistics.mean(gdps)
sigma = statistics.pstdev(gdps)
print('GDP per capita data:')
print(f'mean: {mean}')
print(f'median: {statistics.median(gdps)}')
print(f'standard deviation: {sigma}')
data.sort(key=lambda t: t[2])
for i, t in enumerate(data):
    if t[0] == 'Canada':
        print(f'percentile of Canada: {i / entries}')
        print(f'z-score of Canada: {(t[2] - mean) / sigma}')
print()

print('Life Expectancy data:')
mean = statistics.mean(both)
sigma = statistics.pstdev(both)
print(f'mean: {mean}')
print(f'median: {statistics.median(both)}')
print(f'standard deviation: {sigma}')
data.sort(key=lambda t: t[5])
for i, t in enumerate(data):
    # print(t)
    if t[0] == 'Canada':
        print(f'percentile of Canada by life expectancy: {i / entries}')
        print(f'z-score of Canada: {(t[5] - mean) / sigma}')


countries = np.array(countries)
pop = np.array(pop)
gdps = np.array(gdps)
male = np.array(male)
female = np.array(female)
both = np.array(both)
