"""
The scatter plot script.
"""


from project_data import countries, pop, gdps, male, female, both, data

import numpy as np
import matplotlib.pyplot as plt


# color constants
LIGHT_BLUE = '#add8e6'
LIGHT_PINK = '#ffb6c1'
DEEP_PINK = '#ff1493'

PLOT_TITLE = 'Life Expectancy vs. GDP Per Capita'

# data.sort(key=lambda t: t[3])
# print('Country, pop, GDP per capita, male exp, female exp, combined exp')
# for t in data:
#     print(t)


plt.figure(figsize=(10, 7), dpi=200)

# scatter plot
# sizes = None
# edge_color = 'face'
# plt.scatter(gdps, both, s=sizes, c='black', edgecolors=edge_color)  # both
# plt.scatter(gdps, male, s=sizes, c=LIGHT_BLUE, edgecolors=edge_color)  # male
# plt.scatter(gdps, female, s=sizes, c=DEEP_PINK, edgecolors=edge_color)  # female

# bubble chart
# sizes = np.array(pop) / 8e5
sizes = np.interp(pop, (min(pop), max(pop)), (10, 2e3))  # discuss during presentation?
edge_color = 'black'
plt.scatter(gdps, both, s=sizes, c='orange', edgecolors=edge_color)  # light orange
# plt.scatter(gdps, male, s=sizes, c='#add8e6', edgecolors=edge_color)  # light blue
# plt.scatter(gdps, female, s=sizes, c='#ffb6c1', edgecolors=edge_color)  # light pink

plt.xscale('log')
plt.xlabel('GDP per capita (US dollars)')
plt.ylabel('life expectancy (years)')
plt.ylim(bottom=43, top=91)
# plt.ylim(bottom=-1)
plt.title(PLOT_TITLE)
plt.savefig('plots/bubble_interp.png')
