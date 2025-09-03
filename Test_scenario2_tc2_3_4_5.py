def parse_float(binary_str):
    """Analyze floating point numbers in 12 bit IEEE754 format (symbol 1-bit, exponent 3-bit, tail 8-bit)"""
    if len(binary_str) != 12:
        return 0.0
    
    sign_bit = int(binary_str[0])
    exponent_bits = binary_str[1:4]
    mantissa_bits = binary_str[4:] + '0000'  # Fill in the lower 4 bits with 4'b0000
    
    sign = -1 if sign_bit == 1 else 1
    exponent = int(exponent_bits, 2) - 3  # minus bias ：3 (2^(3-1)-1)
    mantissa = 1 + sum(int(b) * 2**(-i-1) for i, b in enumerate(mantissa_bits))
    
    return sign * mantissa * (2 ** exponent)

def crc4_encode(data_bits):
    """CRC-4  (X^4 + X + 1)"""
    if len(data_bits) != 4:
        return "0000"
    
    poly = 0b10011  # X^4 + X + 1 
    data = int(data_bits, 2) << 4  # shift left 4 bits
    
    for i in range(4):
        if data & (1 << (7 - i)):
            data ^= (poly << (3 - i))
    
    crc = (data & 0b1111)
    return f"{crc:04b}"

def crc4_check(data_bits):
    """CRC-4 (X^4 + X + 1)"""
    if len(data_bits) != 8:
        return False
    
    poly = 0b10011  # X^4 + X + 1
    data = int(data_bits, 2)
    
    for i in range(4):
        if data & (1 << (7 - i)):
            data ^= (poly << (3 - i))
    
    return (data & 0b1111) == 0

def main():
    mode = input("input 3bit for testcase index：").strip()
    
    if mode == "010":
        # floating process
        float1 = input("input the higher 8 bits of the 1st 12bit floating number：").strip() + "0000"
        float2 = input("input the higher 8 bits of the 2nd 12bit floating number：").strip() + "0000"
        
        a = parse_float(float1)
        b = parse_float(float2)
        
        print(a)
        print(b)
        print(int(a))
        print(int(b))
        print(int(a + b))
    
    elif mode == "100":
        # CRC4, generate Check Code
        data = input("input 4bit orignal binary data：").strip()
        if len(data) != 4 or any(c not in '01' for c in data):
            print("input data MUST be 4bit binary data")
            return
        
        crc = crc4_encode(data)
        print(data + crc)  # combin orignal data with CRC check code
    
    elif mode == "101":
        # CRC4, check 
        data = input("input 8bit binary data：").strip()
        if len(data) != 8 or any(c not in '01' for c in data):
            print("input data MUST be 8bit binary data")
            return
        
        if crc4_check(data):
            print("Check PASS")
        else:
            print("Check Faild")
    
    else:
        print("invalid")

if __name__ == "__main__":
    main()