import sys
infile = open(sys.argv[1])

# initialize empty outfile and append new machine lines of machine code
outfile = open(sys.argv[2],'w')
outfile.write('')
outfile = open('./verilog/'+sys.argv[2],'a')

func = { 'clr' : '0000',	
         'add' : '0001',	
         'sub' : '0010',
         'and' : '0011',
         'or'  : '0100',
         'ld'  : '0101',
         'st'  : '0110',
         'sl'  : '0111',
         'sr'  : '1000',
         'set' : '1001',
         'bz'  : '1010',
         'bnz' : '1011',
         'inc' : '1100',
         'dec' : '1101',
         'jmp' : '1110',
         'adc' : '1111' }

# get binary value of int in specified number of bits if possible
def twos(bits,value,i):
    if not (0 <= value < (2**bits)):
        print("Value is out of bounds for bits on line " + str(i+1))

    s = bin(value)
    return s[2:].zfill(bits)

for i,l in iter(enumerate(infile)):

    # empty lines and comments are ignored 
    if l == '' or l[0] == '#':
        continue

    # start parsing line of assembly code
    line = ''
    inst = l.lower().split()

    # all 1's is halt as adc r15 is not allowed
    if inst[0] == 'halt':
        outfile.write('111111111\n')
        continue

    # all instructions have opcode followed by reg/immed
    if len(inst) != 2:
        print("Incorrect # of arguments for func on line " + str(i+1))
        continue

    # is instruction a func or assign call
    if inst[0] == 'assign':
        line += '0'
    else:
        line += '1'

    # assign case
    if line[0] == '0':
        # is reg or immed being assigned
        if inst[1][0] == 'r':
            line += '0'
            val = inst[1][1:]
        else:
            line += '1'
            val = inst[1]

        try:
            base = 10
            line += twos(7,int(val,base),i)
        except Exception:
            print("Assign instr. on line " + val + " is invalid")

    # func case
    else:
        # add func code 
        try:
            line += func[inst[0]]
        except Exception:
            print("Func code " + inst[0] + " on line " + str(i+1) + " is invalid")

        # check syntax
        if inst[1][0] != 'r':
            print("Func reg is in invalid format on line " + str(i+1) )
            continue


        # add reg-dest index
        base = 10
        val = inst[1][1:]
        try:
            line += twos(4,int(val,base),i)
        except Exception:
            print("Func reg/immed " + val + " on line " + str(i+1) + " is invalid")
            #print("inst 0 : " + inst[0])
            #print("inst 1 : " + inst[1])
    
    # write to outfile
    outfile.write(line+'\n')

outfile.close()
infile.close()
