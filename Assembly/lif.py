import matplotlib.pyplot as plt

tau=5
dt=1
af=(tau-dt)/tau
print(af)
synI = 20
vth = 99

v0=10
vf=[]
while v0>0.0005:
    v0 = v0*af + synI
    vf.append(v0)
    if v0 >= vth:
        v0 = 0



plt.plot(vf, label='forward')

plt.legend()
plt.show()
