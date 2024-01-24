import numpy as np
import matplotlib.pyplot as plt
import time

v = -65
u = 0
I = 10

a = 0.02
b = 0.2
c = -55
d = 4

vData = [v]
vTime = [time.perf_counter_ns()]
t = time.perf_counter_ns()
for n in range(1000):
    tNew = time.perf_counter_ns()
    dt = tNew - t
    dtsecs = dt*10**-9

    dv = 0.04*v**2 + 5*v + 140 - u + I
    du = a*(b*v -u)
    

    v+=dv
    u+=du

    vData.append(v)
    vTime.append(time.perf_counter_ns())
    if v >= 30:
        v = c
        u+=d
    t = tNew

plt.plot(vTime, vData)
plt.show()