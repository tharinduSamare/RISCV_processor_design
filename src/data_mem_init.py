import random

depth = 4096
width = 32
fill_depth = 100

numbers = '0123456789abcdef012345678'

mem_file = open('data_mem_init.txt', 'w')

for i in range(fill_depth):
    start_idx = random.randint(0,15)
    end_idx = start_idx + int(width/4)
    mem_file.write("@"+str(hex(i))[2:]+"\t"+ numbers[start_idx:end_idx]+'\n')
    # print(i)
for i in range(fill_depth,depth):
    mem_file.write("@"+str(hex(i))[2:]+"\t"+"0"*int(width/4)+'\n')
mem_file.close()