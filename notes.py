from humanize import metric

Vinmax=40
Vout=3.3
Ioutmax=2

def SY8303():
    Rfs=47e3
    R1=100e3
    R2=0.6/(Vout-0.6)*R1
    Fsw=1e11/Rfs
    L = Vout * (1-Vout/Vinmax) / (Fsw * Ioutmax * 0.4)
    Isatmin = Ioutmax + Vout * (1-Vout / Vinmax) / (2*Fsw*L)
    print(f"Fsw={metric(Fsw, 'Hz')}")
    print(f"R2={metric(R2, 'Ohm')}")
    print(f"L={metric(L, 'H')}")
    print(f"Isatmin>={metric(Isatmin, 'A')}")

SY8303()
