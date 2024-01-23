import numpy as np
import matplotlib.pyplot as plt
import random

v = -65
u = 0
I = 5

a = 0.02
b = 0.2
c = -65
d = 8

vTime = [v]

for n in range(1000):
    vDash = 0.04*v**2 + 5*v + 140 - u + I
    uDash = a*(b*v -u)

    v+=vDash
    u+=uDash
    vTime.append(v)

    if v >= 30:
        v = c
        u+=d

plt.plot(vTime)
plt.show()