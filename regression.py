"""
The scatter plot script.
"""


from project_data import countries, pop, gdps, male, female, both

import numpy as np
import matplotlib.pyplot as plt


# color constants
LIGHT_BLUE = '#add8e6'
LIGHT_PINK = '#ffb6c1'
DEEP_PINK = '#ff1493'

PLOT_TITLE = 'Life Expectancy vs. GDP Per Capita'


# get fits
f = np.polyfit(gdps, both, 1)
a = f[0] * gdps + f[1]
r_linear = np.corrcoef(a, both)

log_gdps = np.log(gdps)
g = np.polyfit(log_gdps, both, 1)
a = g[0] * np.log(gdps) + g[1]
r_log = np.corrcoef(a, both)


# plot everything!
plt.figure(figsize=(10, 7), dpi=200)

plt.scatter(gdps, both)

# linear x-axis
# x = np.linspace(1, max(gdps), num=1000)

# logarithmic x-axis
plt.xscale('log')
x = np.logspace(np.log10(min(gdps)), np.log10(max(gdps)), num=1000)

# linear fit
y = f[0] * x + f[1]
r = r_linear[0, 1]
plt.plot(x, y, label=f'linear fit: y = {f[0]:.3}x + {f[1]:.3}; r = {r:.3}, r^2 = {r ** 2:.3}')

# logarithmic fit
y = g[0] * np.log(x) + g[1]
r = r_log[0, 1]
plt.plot(x, y, label=f'logarithmic fit: y = {g[0]:.3} ln x + {g[1]:.3}; r = {r:.3}, r^2 = {r ** 2:.3}')

plt.legend(loc='lower right')

plt.xlabel('GDP per capita (US dollars)')
plt.ylabel('life expectancy (years)')
plt.ylim(bottom=43, top=91)
# plt.ylim(bottom=-1)
plt.title(PLOT_TITLE)
plt.savefig('plots/regression.png')
