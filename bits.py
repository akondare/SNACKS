def twos(bits,value,signed):
    if signed:
        size = -(2**(bits-1)) <= value < (2**(bits-1))
    else:
        size = 0 <= value < (2**bits)

    if not size:
        print("Value is out of bounds for bits")

    s = bin(value)
    if s[:2] == '0b':
        return s[2:].zfill(bits)
    else:
        value = ( 1<<bits ) + value
        formatstring = '{:0%ib}' % bits
        return formatstring.format(value).zfill(bits)
