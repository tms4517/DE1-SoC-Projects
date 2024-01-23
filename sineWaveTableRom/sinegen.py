# sinegen.py - Generate sinewave table
# ... for use with Altera ROMs
from math import sin, pi

DEPTH = 1024  # Size of ROM
WIDTH = 10   # Size of data in bits
OUTMAX = 2**WIDTH - 1   # Amplitude of sinewave

filename = "rom_data.mif"
f = open(filename, 'w')

# Header for the .mif file
print("-- ROM Initialization file", file=f)
print("DEPTH = %d;" % DEPTH, file=f)
print("WIDTH = %d;" % WIDTH, file=f)
print("ADDRESS_RADIX = HEX;", file=f)
print("DATA_RADIX = HEX;\n", file=f)
print("CONTENT\nBEGIN\n", file=f)

for address in range(DEPTH):
    angle = (address * 2 * pi) / DEPTH
    sine_value = sin(angle)
    data = int((sine_value + 1) * 0.5 * OUTMAX)

    print("%04x : %04x;" % (address, data), file=f)

print("END;\n", file=f)

f.close()
