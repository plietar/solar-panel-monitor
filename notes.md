https://github.com/stuartpittaway/diyBMS-CurrentShunt
https://www.analog.com/en/analog-dialogue/articles/optimize-high-current-sensing-accuracy.html

## Solar panel spec
- Datasheet: https://www.bimblesolar.com/docs/Updated_Perlight_PLM-295MB-54_Black-Plus-Series.pdf
- Open-circuit voltage: 37.18V
- Short-circuit current: 10.08A

## Power monitor IC
### INA260
- Datasheet: https://www.ti.com/lit/ds/symlink/ina260.pdf
- Package: TSSOP16
- Integrated Shunt
- 15A Continous
- 36V Bus (Absolute Maximum Ratings for VBUS is 40V)
- I2C output

### INA232
- Package: SOT-23
- External Shunt
- 48V Bus
- I2C output

### INA236
Same as INA232, but "ultra-precise"

### INA228
- Package: VSSOP10
- External Shunt
- 85V Bus
- I2C output
- Energy/Charge accumulator

### INA229
Same as INA228 but with SPI output

### INA233
Just an older version of INA228, with smaller voltage range

## Power supply
### SY8303
- Package: TSOT23 
- 3A
- 4.5V to 40V input range
- Adjustable output

Vout=3.3V
R1=100k
R2=22.1k

L = Vout * (1-Vout/Vinmax) / (Fsw * Ioutmax * 0.4)

## LMR51420
## LMR51430

## Shunt

- 15A current
- INA228 range: ±163.84 mV / ±40.96 mV
- 10.92 mOhm or 2.73mOhm
- Power dissipation: RI^2: 0.61W
- 2512 Package?
- eg. https://www.vishay.com/docs/30122/wslp.pdf
