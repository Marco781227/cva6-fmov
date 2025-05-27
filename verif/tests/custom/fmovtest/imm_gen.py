# This file contains functions used as a commodity for converting decimal values to 12bit floating point representation


# ---------------------------------------------------------------------------------------------------------------------
# classic decimal to floating point conversion adapted to 12bit structure
def dec_to_hex(x : float):
    # SUBNORMAL CASES
    if x == 0 : return "000" # 0.0 <=> 000 | same as 32bit
    
    # NORMAL CASES
    # mantisse length is 6 bits
    mantisse = x
    # exponent length is 5 bits
    exponent = 15
    sign = "0" if x >= 0 else "1"
    # rewrite mantisse as 1.xxxxxx
    while mantisse < 1:
        mantisse *= 2
        exponent -= 1
    while mantisse >= 2:
        mantisse /= 2
        exponent += 1
    # remove the integer part of the mantisse which is always 1
    mantisse-=1
    # convert the real part to decimal binary
    b_mant = ""
    for i in range(1,7):
        if 2**(-i) <= mantisse:
            b_mant += '1'
            mantisse -= 2**-i
        else:
            b_mant += '0'
    b_exp = str(format(exponent,'05b'))
    return format(int(sign+b_exp+b_mant,2),'03x')

# decoding from 12bit hexadecimal
def hex_to_dec(x : str):
    # SUBNORMAL CASES
    if x == "000" : return 0.0 # 0.0 <=> 000 | same as 32bit

    # NORMAL CASES
    # convert to binary
    b = format(int(x,16),'012b')
    sign = b[0]
    exp = b[1:6]
    mant = b[6:12]
    res = 1
    # computes float value of mantisse from binary
    for i in range(6):
        res += int(mant[i])*2**-(i+1)
    # multiply by exponent
    res *= 2**(int(exp,2)-15)
    # multiply by sign
    if int(sign) : res *= -1
    return res

# decimal to decimal by coding to 12bit float then decoding. Useful to see how values get approximated
def d2d(x : float):
    return hex_to_dec(dec_to_hex(x))

# WORK IN PROGRESS
all_y = []
for i in range(4096):
    x = format(i,'03x')
    y = hex_to_dec(x)
    all_y.append(y)
    if i > 2920 or i < 3050:
        print(f"{x} -> {y}")

print(f"min:{min(all_y)} | max:{max(all_y)}")
print(d2d(3.1))
print(dec_to_hex(3.5))
print(hex_to_dec("fef"))

# TODO : Write automatic test generator for FMOV