import sys
infile = open(sys.argv[1])

# initialize empty outfile and append new machine lines of machine code
outfile = open(sys.argv[2],'w')
outfile.write('')
outfile = open(sys.argv[2],'a')

for i,l in iter(enumerate(infile)):

    # empty lines and comments are ignored 
    if len(l.lower().split()) == 0 or l[0] == '#':
        continue

    # write to outfile
    outfile.write(l)

outfile.close()
infile.close()
