import numpy as np
import matplotlib.pyplot as plt

tau=12
dt=2
af=(tau-dt)/tau
#psc = np.random.random_integers(0,20,100)
psc = np.full((100,1), 11)
vth = 60
n=0

v0=50
vf=[]
while v0>0.0005:

    v0 = v0*af + psc
    print(v0)
    vf.append(v0)
    if v0 > vth or n == 99:
        v0 = 0
    n+=1


plt.plot(vf, label='forward')

plt.legend()
plt.show()
