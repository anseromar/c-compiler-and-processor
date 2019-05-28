instructions_memory = []
datas_memory = [0] * 256
registers = [0] * 3
instruction_pointer = 0

instructions_memory = [(line.rstrip('\n')).split() for line in open('../assembler/assembly.s', 'r+')]

print(instructions_memory)
while instruction_pointer <= len(instructions_memory):
	if instructions_memory[instruction_pointer][0] == "AFC":
		registers[int(instructions_memory[instruction_pointer][1])] = int(instructions_memory[instruction_pointer][2])
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "LOAD":
		registers[int(instructions_memory[instruction_pointer][1])] = datas_memory[int(instructions_memory[instruction_pointer][2])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "STORE":
		datas_memory[int(instructions_memory[instruction_pointer][1])] = registers[int(instructions_memory[instruction_pointer][2])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "JMPC":
		if(registers[int(instructions_memory[instruction_pointer][2])] == 1):
			instruction_pointer+=1
		else: 
			instruction_pointer = int(instructions_memory[instruction_pointer][2])
	elif instructions_memory[instruction_pointer][0] == "INF":
		if(registers[int(instructions_memory[instruction_pointer][2])] < registers[int(instructions_memory[instruction_pointer][3])]):
			registers[int(instructions_memory[instruction_pointer][1])] = 1 
			instruction_pointer+=1
		else:
			registers[int(instructions_memory[instruction_pointer][1])] = 0 
			instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "INFE":
		if(registers[int(instructions_memory[instruction_pointer][2])] <= registers[int(instructions_memory[instruction_pointer][3])]):
			registers[int(instructions_memory[instruction_pointer][1])] = 1 
			instruction_pointer+=1
		else:
			registers[int(instructions_memory[instruction_pointer][1])] = 0 
			instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "SUP":
		if(registers[int(instructions_memory[instruction_pointer][2])] > registers[int(instructions_memory[instruction_pointer][3])]):
			registers[int(instructions_memory[instruction_pointer][1])] = 1 
			instruction_pointer+=1
		else:
			registers[int(instructions_memory[instruction_pointer][1])] = 0 
			instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "SUPE":
		if(registers[int(instructions_memory[instruction_pointer][2])] >= registers[int(instructions_memory[instruction_pointer][3])]):
			registers[int(instructions_memory[instruction_pointer][1])] = 1 
			instruction_pointer+=1
		else:
			registers[int(instructions_memory[instruction_pointer][1])] = 0 
			instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "EQU":
		if(registers[int(instructions_memory[instruction_pointer][2])] == registers[int(instructions_memory[instruction_pointer][3])]):
			registers[int(instructions_memory[instruction_pointer][1])] = 1 
			instruction_pointer+=1
		else:
			registers[int(instructions_memory[instruction_pointer][1])] = 0 
			instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "ADD":
		registers[int(instructions_memory[instruction_pointer][1])] = registers[int(instructions_memory[instruction_pointer][2])] + registers[int(instructions_memory[instruction_pointer][3])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "SUB":
		registers[int(instructions_memory[instruction_pointer][1])] = registers[int(instructions_memory[instruction_pointer][2])] - registers[int(instructions_memory[instruction_pointer][3])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "MULT":
		registers[int(instructions_memory[instruction_pointer][1])] = registers[int(instructions_memory[instruction_pointer][2])] * registers[int(instructions_memory[instruction_pointer][3])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "DIV":
		registers[int(instructions_memory[instruction_pointer][1])] = registers[int(instructions_memory[instruction_pointer][2])] / registers[int(instructions_memory[instruction_pointer][3])]
		instruction_pointer+=1
	elif instructions_memory[instruction_pointer][0] == "JUMP":
		instruction_pointer = instructions_memory[instruction_pointer][1]

print("*****************************")
print(instructions_memory)
print("*****************************")
print(datas_memory)
print("*****************************")
print(registers)
print("*****************************")
print(instruction_pointer)
print("*****************************")
