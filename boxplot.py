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

PLOT_TITLE = 'Life Expectancy'

figs, axs = plt.subplots(nrows=1, ncols=2, figsize=(9, 3), dpi=200)
axs[0].boxplot(gdps, labels=('World',))
axs[0].set_title('GDP Per Capita')
axs[0].set_ylabel('GDP per capita (US dollars)')
axs[0].set_yscale('log')

axs[1].boxplot(both, labels=('World',))
axs[1].set_title('Life Expectancy')
axs[1].set_ylabel('life expectancy (years)')

plt.subplots_adjust(wspace=0.4)

# plt.yscale('log')
# plt.ylim(bottom=-1, top=91)
# plt.ylim(bottom=-1)
# plt.title(PLOT_TITLE)
plt.savefig('plots/boxplots.png')

