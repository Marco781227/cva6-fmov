# This file contains functions used as a commodity for converting decimal values to 12bit floating point representation


# ---------------------------------------------------------------------------------------------------------------------
# classic decimal to floating point conversion adapted to 12bit structure
def dec_to_hex(x : float):
    # SUBNORMAL CASES
    if x == 0 : return "000" # 0.0 <=> 000 | same as 32bit
    if x == float('inf') : return "inf"
    # NORMAL CASES
    # mantisse length is 6 bits
    mantisse = x
    # exponent length is 5 bits
    exponent = 15
    sign = "0" if x >= 0 else "1"
    # rewrite mantisse as 1.xxxxxx
    while mantisse < 1:
        print("quoicou ???")
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
    b_exp = str(format(exponent,'05b')) # format '05b' convert int to binary of length 5 with leading zeros
    return format(int(sign+b_exp+b_mant,2),'03x')

# decoding from 12bit hexadecimal
def hex_to_dec(x : str):
    # SUBNORMAL CASES
    if x == "000" : return 0.0 # 0.0 <=> 000 | same as 32bit
    if x == "inf" : return float('inf')
    # NORMAL CASES
    # convert to binary
    b = format(int(x,16),'012b') # format '012b' convert int to binary of length 12 with leading zeros
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

# returns fmov hexcode via a text interface gathering parameters step by step
def write_fmov_guided():
    # "001110110011 00111 11 1 00010 0001011" : fmovGE x7 f2 0.9
    #    immediat    rs1 cond   rd    fmov
    print("Float Conditional Mov takes this structure : FMOVcond rs1 rd rs2 / FMOVcond rs1 rd imm")
    print("It will put the value of rs2 into rd if rs1 cond 0 is true.")
    rs1 = int(input("What is rs1 : "))
    print("Choose one of these four conditions : (0)-EQ (1)-NE (2)-LT (3)-GE")
    cond = int(input("Select your choice's number : "))
    rd = int(input("What is rd : "))
    if int(input("FMOV Reg/Reg (0) or FMOV Reg/Imm (1) ?")):
        imm = float(input("Enter immediate value (ex: 12.3456) : "))
        return compile_fmov(cond,rs1,rd,imm)
    else:
        rs2 = int(input("What is rs2 : "))
        return compile_fmov(cond,rs1,rd,rs2)
        
    
# returns fmov hexcode
def compile_fmov(cond : int, rs1 : int, rd : int, operand2 : int | float | str):
    if isinstance(operand2,float):
        return dec_to_hex(operand2)+format(int(format(rs1,'05b')+format(cond,'02b')+"1"+format(rd,'05b')+"0001011",2),'05x')
    elif isinstance(operand2,int):
        return format(int(format(operand2,'05b')+format(rs1,'05b')+format(cond,'02b')+"0"+format(rd,'05b')+"0001011",2),'08x')
    elif isinstance(operand2,str):
        return operand2+format(int(format(rs1,'05b')+format(cond,'02b')+"1"+format(rd,'05b')+"0001011",2),'05x')
    else:
        raise Exception("Bad arguments")

# returns fmov hexcode from string like : fmovGE x7 f2 f4 -> 0043e10b
def fmov_from_string(instr : str):
    toks = instr.split()
    d_cond = {"eq" : 0, "ne" : 1, "lt" : 2, "ge" : 3}
    op = toks[0].lower()
    assert(op[0:4] == "fmov" and op[4:6] in d_cond.keys())
    cond = d_cond[op[4:6]]
    assert(toks[1][0] in ['x','r'])
    rs1 = int(toks[1][1:])
    assert(toks[2][0] == 'f')
    rd = int(toks[2][1:])
    operand2 = int(toks[3][1:]) if toks[3][0] == 'f' else float(toks[3])
    return compile_fmov(cond,rs1,rd,operand2)

    

# WORK IN PROGRESS

"""
all_y = []
for i in range(4096):
    x = format(i,'03x') # format '03x' convert int to hex of length 3 with leading zeros
    y = hex_to_dec(x)
    all_y.append(y)
    if i >= 0 and i < 10:
        print(f"{x} -> {y}")

all_y.sort()

min_y = min(all_y)
max_y = max(all_y)
last_y = min_y
max_diff = 0
diff_total = 0
for y in all_y:
    diff = y - last_y
    if diff > max_diff:
        max_diff = diff
    diff_total += diff
    last_y = min_y
print(f"total difference : {diff_total} | average difference : {diff_total/4096} | max difference : {max_diff}")

print(f"min:{min_y} | max:{max_y}")


print(fmov_from_string(input("$")))
print("---------------------------")
print(write_fmov_guided())
"""
# TODO : Write automatic test generator for FMOV
with open("/home/martin/Documents/Master1/TER/cva6-fmov/verif/tests/custom/fmovtest/auto-generated_tests.txt", "w") as f:
    
    for i in range(4096):
        x = format(i,'03x')
        b = format(i,'012b')
        if b[1:6] in ["00000","11111"] : continue
        y = hex_to_dec(x)
        print(f"hex={x},bin={b},float={y},floatf={y:.15f}")
        f.write(f'// fmovLT x5 f2 IMM\nasm volatile("lui x5, 0\\n" ".word 0x{compile_fmov(2,5,2,x)}\\n" "fmv.x.w %0, f2\\n" :"=r"(result)); assert(result!={y:.15f});\n// fmovEQ x5 f2 IMM\nasm volatile("lui x5, 0\\n" ".word 0x{compile_fmov(0,5,2,x)}\\n" "fmv.x.w %0, f2\\n" :"=r"(result)); assert(result=={y:.15f});\n')
print("DONE")