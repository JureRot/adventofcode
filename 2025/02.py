import time
start_time = time.time()

with open("02.txt", "r") as file:
    lines = [line.rstrip() for line in file]  # can be just strip()

# only one line
line = lines[0]


def is_valid_id(n):
    id = str(n)

    # odd number of digits cant be invalid
    if (len(id) % 2 != 0):
        return False

    first_half = id[:len(id) // 2]
    second_half = id[len(id) // 2:]

    if (first_half == second_half):
        return True

    return False


def is_valid_id2(n):
    id = str(n)

    # build the numbers from the head from 1 to len/2 characters -> compare with original string
    for i in range(1, len(id) // 2 + 1):
        if (len(id) % i == 0):
            # build string
            # get head
            head = id[:i]

            # create string body
            body = ""
            for j in range(1, len(id) // i + 1):
                body += head

            if (id == body):
                return True

    return False


# part 1
ranges = line.split(',')
sum = 0

for r in ranges:
    split = r.split('-')

    start = int(split[0])
    stop = int(split[1]) + 1

    for i in range(start, stop):
        if (is_valid_id(i)):
            sum += i

print(f"Part 1: {sum}")


# part 2
ranges2 = line.split(',')
sum2 = 0

for r in ranges2:
    split = r.split('-')

    start = int(split[0])
    stop = int(split[1]) + 1

    for i in range(start, stop):
        if (is_valid_id2(i)):
            sum2 += i

print(f"Part 2: {sum2}")


end_time = time.time()
time_differnece = end_time - start_time
print(f"Elapsed time: {time_differnece} seconds")
