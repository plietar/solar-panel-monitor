from humanize import metric
from math import sqrt
from pint import UnitRegistry

ureg = UnitRegistry(auto_reduce_dimensions = True)
ureg.default_format = "0.2f~P"
P = [
    ureg.V,
    ureg.A,
    ureg.kohm,
    ureg.uF,
    ureg.uH,
    ureg.kHz,
    ureg.percent
]

Q = ureg.Quantity

def SY8303(
    Vinmax=Q('40V'),
    Vout=Q('3.3V'),
    Ioutmax=Q('1A'),
    Fsw=Q('400kHz'),
    deltaVoutmax=Q('10mV'),
):

    Vref = Q('0.8V')
    Rfbb = Q('22.1kohm')
    Rfbt = Rfbb * (Vout - Vref) / Vref

    eta=0.90
    DC = Vout / (Vinmax * eta) # Duty cycle
    Kind = 0.3
    Lmin = (Vinmax - Vout) / (Ioutmax * Kind) * Vout / (Vinmax * Fsw)

    deltaIl = (Vinmax - Vout) * DC / (Fsw * Lmin)

    print(f"Rfbb={Rfbb.to_preferred(P)}")
    print(f"Rfbt={Rfbt.to_preferred(P)}")
    print(f"Lmin={Lmin.to_preferred(P)}")
    print(f"ΔIl={deltaIl.to_preferred(P)}")

    #Vpmax = Q('75mV') # Maximum input ripple voltage
    #Cinmin = Ioutmax * DC * (1-DC) / (Fsw * Vpmax) # Input capacitor capacitance

    #Icinrms = Ioutmax * sqrt(DC * (1-DC))

    #L = Vout * (1-Vout/Vinmax) / (Fsw * Ioutmax * 0.4)
    #Isatmin = Ioutmax + deltaIl / 2

    #Coutmin = deltaIl / (8 * Fsw * deltaVoutmax)

    #print(f"R2={R2.to_preferred(P)}")
    #print(f"Fsw={Fsw.to_preferred(P)}")
    #print(f"DC={DC.to_preferred(P)}")
    #print(f"Rfs={Rfs.to_preferred(P)}")
    #print(f"Cimin={Cinmin.to_preferred(P)}")
    #print(f"Icinrms={Icinrms.to_preferred(P)}")
    #print(f"L={L.to_preferred(P)}")
    #print(f"Isatmin>={Isatmin.to_preferred(P)}")
    #print(f"Coutmin={Coutmin.to_preferred(P)}")

SY8303()
