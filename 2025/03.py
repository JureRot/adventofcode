import time
start_time = time.time()

with open("03.txt", "r") as file:
    lines = [line.rstrip() for line in file]


def find_biggest(str, start, stop):
    biggest = 0
    location = None

    for i in range(start, stop):
        char = int(str[i])
        if (char > biggest):
            biggest = char
            location = i

            # small optimization
            if (biggest == 9):
                break

    return (biggest, location)


# part 1
sum = 0

for line in lines:
    joltage = "" 

    (first, location) = find_biggest(line, 0, len(line) - 1)
    joltage += str(first)

    (second, location) = find_biggest(line, location+1, len(line))
    joltage += str(second)

    sum += int(joltage)

print(f"Part 1: {sum}")


# part 2
sum2 = 0

for line2 in lines:
    joltage2 = "" 
    n = 12

    char = None
    location = 0

    for j in range(n):
        (char, location) = find_biggest(line2, location, len(line2) - (n - (j + 1)))

        location += 1 # needed because python is different than lua

        joltage2 += str(char)

    sum2 += int(joltage2)

print(f"Part 2: {sum2}")


end_time = time.time()
time_difference = end_time - start_time
print(f"Elapsed time: {time_difference} seconds")
