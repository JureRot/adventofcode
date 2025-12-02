import time
start_time = time.time()

with open("01.txt", "r") as file:
    lines = [line.rstrip() for line in file]  # can be just strip()


def parse_line(line):
    command = line[0]
    count = int(line[1:])

    if (command == 'L'):
        count *= -1

    return count


# part 1
dial = 50
num_zeros = 0

for line in lines:
    count = parse_line(line)

    dial += count
    dial %= 100

    # landing on zero check
    if (dial == 0):
        num_zeros += 1

print(f"Part 1: {num_zeros}")


# part 2
dial2 = 50
num_any_zeros = 0

for line in lines:
    count = parse_line(line)

    temp_dial2 = dial2 + count

    # multiple zero crossings check
    crosses = abs(dial2 - temp_dial2) // 100
    if (crosses > 0):
        num_any_zeros += crosses

        if (temp_dial2 < 0):
            temp_dial2 += 100 * crosses
        else:
            temp_dial2 -= 100 * crosses

    # ending across zero check
    if (dial2 != 0 and (temp_dial2 > 100 or temp_dial2 < 0)):
        num_any_zeros += 1

    temp_dial2 %= 100

    # landing on zero check
    if (dial2 == 0):
        num_any_zeros += 1

    dial2 = temp_dial2


print(f"Part 2: {num_any_zeros}")


end_time = time.time()
time_differnece = end_time - start_time
print(f"Elapsed time: {time_differnece} seconds")
