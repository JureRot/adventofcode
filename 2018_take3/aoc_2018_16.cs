using System.Reflection;

namespace aoc_2018_take3;

class aoc_2018_16
{
	public enum Opps
	{
		addr = 0,
		addi = 1,
		mulr = 2,
		muli = 3,
		banr = 4,
		bani = 5,
		borr = 6,
		bori = 7,
		setr = 8,
		seti = 9,
		gtir = 10,
		gtri = 11,
		gtrr = 12,
		eqir = 13,
		eqri = 14,
		eqrr = 15,
	}

	// addition
	public static int[] addr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] + reg[b];

		return result;
	}
	public static int[] addi(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] + b;

		return result;
	}

	// multiplication
	public static int[] mulr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] * reg[b];

		return result;
	}
	public static int[] muli(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] * b;

		return result;
	}

	// bitwise and
	public static int[] banr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] & reg[b];

		return result;
	}
	public static int[] bani(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] & b;

		return result;
	}

	// bitwise or
	public static int[] borr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] | reg[b];

		return result;
	}
	public static int[] bori(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a] | b;

		return result;
	}

	// assignment
	public static int[] setr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = reg[a];

		return result;
	}
	public static int[] seti(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = a;

		return result;
	}

	// greater-than testing
	public static int[] gtir(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (a > reg[b])
		{
			result[c] = 1;
		}

		return result;
	}
	public static int[] gtri(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (reg[a] > b)
		{
			result[c] = 1;
		}

		return result;
	}
	public static int[] gtrr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (reg[a] > reg[b])
		{
			result[c] = 1;
		}

		return result;
	}

	// equality testing
	public static int[] eqir(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (a == reg[b])
		{
			result[c] = 1;
		}

		return result;
	}
	public static int[] eqri(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (reg[a] == b)
		{
			result[c] = 1;
		}

		return result;
	}
	public static int[] eqrr(int[] reg, int a, int b, int c)
	{
		int[] result = (int[])reg.Clone();

		result[c] = 0;
		if (reg[a] == reg[b])
		{
			result[c] = 1;
		}

		return result;
	}

	public static bool compareRegisters(int[] a, int[] b)
	{
		return a.SequenceEqual(b);
	}

	public static bool[] testAll(int[] registers, int a, int b, int c, int[] after)
	{
		int[] result = new int[4];
		bool[] successful = new bool[16];

		result = addr(registers, a, b, c);
		successful[(int)Opps.addr] = compareRegisters(after, result);

		result = addi(registers, a, b, c);
		successful[(int)Opps.addi] = compareRegisters(after, result);

		result = mulr(registers, a, b, c);
		successful[(int)Opps.mulr] = compareRegisters(after, result);

		result = muli(registers, a, b, c);
		successful[(int)Opps.muli] = compareRegisters(after, result);

		result = banr(registers, a, b, c);
		successful[(int)Opps.banr] = compareRegisters(after, result);

		result = bani(registers, a, b, c);
		successful[(int)Opps.bani] = compareRegisters(after, result);

		result = borr(registers, a, b, c);
		successful[(int)Opps.borr] = compareRegisters(after, result);

		result = bori(registers, a, b, c);
		successful[(int)Opps.bori] = compareRegisters(after, result);

		result = setr(registers, a, b, c);
		successful[(int)Opps.setr] = compareRegisters(after, result);

		result = seti(registers, a, b, c);
		successful[(int)Opps.seti] = compareRegisters(after, result);

		result = gtir(registers, a, b, c);
		successful[(int)Opps.gtir] = compareRegisters(after, result);

		result = gtri(registers, a, b, c);
		successful[(int)Opps.gtri] = compareRegisters(after, result);

		result = gtrr(registers, a, b, c);
		successful[(int)Opps.gtrr] = compareRegisters(after, result);

		result = eqir(registers, a, b, c);
		successful[(int)Opps.eqir] = compareRegisters(after, result);

		result = eqri(registers, a, b, c);
		successful[(int)Opps.eqri] = compareRegisters(after, result);

		result = eqrr(registers, a, b, c);
		successful[(int)Opps.eqrr] = compareRegisters(after, result);

		return successful;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int breakpoint = 0;
		int[] registers = new int[4];
		int numTestWith3orMore = 0;

		// split input in first and second parts
		for (int i=1; i<lines.Length; i++)
		{
			if (lines[i].Equals("") && lines[i-1].Equals(""))
			{
				breakpoint = i;
				break;
			}
		}

		String[] firstPart = new String[breakpoint];
		Array.Copy(lines, 0, firstPart, 0, breakpoint);

		String[] secondPart = new String[(lines.Length-1) - breakpoint-1];
		Array.Copy(lines, breakpoint+2, secondPart, 0, (lines.Length-1) - breakpoint-1);

		// run all tests in first part
		int index = 0;
		while (index < firstPart.Length)
		{
			int[] before = firstPart[index].Split(new Char[]{'[', ']'})[1].Split(", ").Select(n => Convert.ToInt32((n))).ToArray();
			int[] after = firstPart[index+2].Split(new Char[]{'[', ']'})[1].Split(", ").Select(n => Convert.ToInt32((n))).ToArray();

			String[] command = firstPart[index+1].Split(" ");
			int opp = Int32.Parse(command[0]);
			int a = Int32.Parse(command[1]);
			int b = Int32.Parse(command[2]);
			int c = Int32.Parse(command[3]);

			registers = before;

			// test all
			bool[] successes = testAll(registers, a, b, c, after);
			if (successes.Count(s => s) >= 3)
			{
				numTestWith3orMore++;
			}

			index +=4;
		}

        Console.WriteLine("AoC 16 part1: {0}", numTestWith3orMore);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int breakpoint = 0;
		int[] registers = new int[4];
		bool[][] posibilities = new bool[16][];
		for (int b=0; b<posibilities.Length; b++)
		{
			posibilities[b] = new bool[]{
				true, true, true, true,
				true, true, true, true,
				true, true, true, true,
				true, true, true, true
			};
		}

		// split input in first and second parts
		for (int i=1; i<lines.Length; i++)
		{
			if (lines[i].Equals("") && lines[i-1].Equals(""))
			{
				breakpoint = i;
				break;
			}
		}

		String[] firstPart = new String[breakpoint];
		Array.Copy(lines, 0, firstPart, 0, breakpoint);

		String[] secondPart = new String[(lines.Length-1) - breakpoint-1];
		Array.Copy(lines, breakpoint+2, secondPart, 0, (lines.Length-1) - breakpoint-1);

		// run all tests in first part
		int index = 0;
		while (index < firstPart.Length)
		{
			int[] before = firstPart[index].Split(new Char[]{'[', ']'})[1].Split(", ").Select(n => Convert.ToInt32((n))).ToArray();
			int[] after = firstPart[index+2].Split(new Char[]{'[', ']'})[1].Split(", ").Select(n => Convert.ToInt32((n))).ToArray();

			String[] command = firstPart[index+1].Split(" ");
			int opp = Int32.Parse(command[0]);
			int a = Int32.Parse(command[1]);
			int b = Int32.Parse(command[2]);
			int c = Int32.Parse(command[3]);

			registers = before;

			// test all
			bool[] successes = testAll(registers, a, b, c, after);
			// update posibilites
			for (int s=0; s<successes.Length; s++)
			{
				posibilities[opp][s] = posibilities[opp][s] && successes[s];
			}

			index +=4;
		}

		// create reflections from posibilites rules
		// find one that has only one posibility
		// set it
		// remove that posibility from all others
		// repeat
		Dictionary<int, string> reflections = new Dictionary<int, string>();
		while (reflections.Count < 16)
		{
			for (int i=0; i<posibilities.Length; i++)
			{
				if (posibilities[i].Count(t => t) == 1)
				{
					int oppNumber = i;
					int oppEnumNumber = Array.IndexOf(posibilities[i], true);
					Opps oppEnum = (Opps)oppEnumNumber;
					string oppName = oppEnum.ToString();
					reflections.Add(oppNumber, oppName);

					// remove this from all other opps
					for (int j=0; j<posibilities.Length; j++)
					{
						posibilities[j][oppEnumNumber] = false;
					}

					break;
				}
			}
		}

		registers[0] = 0;
		registers[1] = 0;
		registers[2] = 0;
		registers[3] = 0;

		// run all commands in second part
		foreach (string s in secondPart)
		{
			String[] command = s.Split(" ");
			int opp = Int32.Parse(command[0]);
			int a = Int32.Parse(command[1]);
			int b = Int32.Parse(command[2]);
			int c = Int32.Parse(command[3]);

			// this uses reflections to call methods by their names
			// (could also make a switch case)
			string methodName = reflections[opp];
			Type type = typeof(aoc_2018_16);
			MethodInfo? methodInfo = type.GetMethod(methodName);
			if (methodInfo != null)
			{
				Object? result = methodInfo.Invoke(null, new Object[]{registers, a, b, c});

				if (result != null)
				{
					registers = (int[])result;
				}
			}
		}

        Console.WriteLine("AoC 16 part2: {0}", registers[0]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
