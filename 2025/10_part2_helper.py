# todo to run
# python -m venv venv
# source venv/bin/activate
# pip install z3-solver

INPUT_FILE = "10.txt"

machines = []
with open(INPUT_FILE, "r") as f:
    for parts in [line.strip().split() for line in f]:
        solution = [c == "#" for c in parts[0][1:-1]]
        buttons = [[int(b) for b in button[1:-1].split(",")] for button in parts[1:-1]]
        voltages = [int(v) for v in parts[-1][1:-1].split(",")]
        machines.append([solution, buttons, voltages])
        #print(solution, "\n", buttons, "\n", voltages, "\n")

# Part 1
import itertools

total = 0
for solution, buttons, _ in machines:
    presses = 0
    lights = [False] * len(solution)
    while lights != solution:
        presses += 1
        for combo in itertools.combinations(range(len(buttons)), presses):
            lights = [False] * len(solution)
            for button in combo:
                for b in buttons[button]:
                    lights[b] = not lights[b]
            if lights == solution:
                break
    total += presses
print(total)

# Part 2
from z3 import *

total = 0
for _, buttons, voltages in machines:
    solver = Solver()

    bvars = [Int(f"a{n}") for n in range(len(buttons))]
    for b in bvars:
        solver.add(b >= 0)

    for i,v in enumerate(voltages):
        vvars = [bvars[j] for j,button in enumerate(buttons) if i in button]
        solver.add(Sum(vvars) == v)

    while solver.check() == sat:
        model = solver.model()
        n = sum([model[d].as_long() for d in model])
        solver.add(Sum(bvars) < n)

    print(f"{n} [ ", end="")
    items = [(d.name(), model[d]) for d in model.decls()]
    for k, v in sorted(items):
        print(f"{v} ", end="")
    print("]")
    total += n
print(total)

