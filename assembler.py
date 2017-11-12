import sys
infile = open(sys.argv[1])

# initialize empty midfile and append new machine lines of machine code
midfile = open(sys.argv[2],'w')
midfile.write('')
midfile = open(sys.argv[2],'a')

func = { 'clear' : '0000',
         'add' : '0001',
         'sub' : '0010',
         'and' : '0011',
         'or' : '0100',
         'xor' : '0101',
         'addi' : '0110',
         'load' : '0111',
         'str' : '1000',
         'mod' : '1001',
         'sll' : '1010',
         'sra' : '1011',
         'srl' : '1100',
         'set' : '1101',
         'bz' : '1110',
         'bn' : '1111' }

def twos(bits,value,signed,i):
    if signed:
        size = -(2**(bits-1)) <= value < (2**(bits-1))
    else:
        size = 0 <= value < (2**bits)

    if not size:
        print("Value is out of bounds for bits on line " + str(i))

    s = bin(value)
    if s[:2] == '0b':
        return s[2:].zfill(bits)
    else:
        value = ( 1<<bits ) + value
        formatstring = '{:0%ib}' % bits
        return formatstring.format(value).zfill(bits)

bits = ''

for i,l in iter(enumerate(infile)):
    line = ''
    inst = l.lower().split()

    if inst[0] == 'assign':
        arg1 = ''
        arg2 = ''
        if len(inst) == 3:
            try:
                arg1 = twos(4,int(inst[1]),False,i)
            except ValueError:
                print("RD for FUNC call on line " + str(i) + " is not valid")

            if inst[2][:2] == '0x':
                try:
                    arg2 = twos(4,int(inst[2],16),True,i)
                except ValueError:
                    print("IMM for FUNC call on line " + str(i) + " is not valid")
            else : 
                try:
                    arg2 = twos(4,int(inst[2]),False,i)
                except ValueError:
                    print("RD for FUNC call on line " + str(i) + " is not valid")

        elif len(inst) == 2:
            try:
                arg1 = twos(8,int(inst[1],16),True,i)
            except ValueError:
                print("IMM for FUNC call on line " + str(i) + " is not valid")
        else:
            print("Not enough arguments for assign on line " + str(i))

        line = line+'0'+arg1+arg2

    else:
        if len(inst) != 2:
            print("Incorrect # of arguments for func on line " + str(i))

        if inst[1][:2] == '0x':
            try:
                val = twos(4,int(inst[1],16),True,i)
            except ValueError:
                print("IMM for FUNC call on line " + str(i) + " is not valid")
        else : 
            try:
                val = twos(4,int(inst[1]),False,i)
            except ValueError:
                print("RD for FUNC call on line " + str(i) + " is not valid")

        line = line+'1'+func[inst[0]]+val

    
    
    midfile.write(line+'\n')
    bits = bits + line

midfile.close()
infile.close()

midfile = open(sys.argv[2])

# initialize empty outfile and append new machine lines of machine code
outfile = open(sys.argv[3],'w')
outfile.write('')
outfile = open(sys.argv[3],'wb')

bits = bits + ('0'*abs(len(bits)%(-8)))

listOfInts = []
for i in range(int(len(bits)/8)):
    listOfInts.append(int(bits[(i*8):((i+1)*8)],2))

by = bytes(listOfInts)

outfile.write(by)
outfile.close()


