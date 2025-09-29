namespace aoc_2018_take3;

class aoc_2018_02
{
	static Dictionary<char, int> parseCounts(string line)
	{
		Dictionary<char, int> result = new Dictionary<char, int>();

		for (int i=0; i<line.Length; i++)
		{
			if (result.ContainsKey(line[i]))
			{
				result[line[i]]++;
			} else
			{
				result[line[i]] = 1;
			}
		}

		return result;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		int twice = 0;
		int thrice = 0;

		foreach (var line in lines)
		{
			bool hasTwice = false;
			bool hasThrice = false;

			Dictionary<char, int> counts = parseCounts(line);
			foreach (char count in counts.Keys)
			{
				if (counts[count] == 2)
				{
					hasTwice = true;
				}

				if (counts[count] == 3)
				{
					hasThrice = true;
				}
			}

			twice += hasTwice ? 1 : 0;
			thrice += hasThrice ? 1 : 0;
		}

        Console.WriteLine("AoC 02 part1: {0}", twice * thrice);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

	static string stringsCompared(string a, string b)
	{
		string result = "";

		for (int i=0; i<a.Length; i++)
		{
			if (a[i] == b[i])
			{
				result += a[i];
			}
		}

		return result;
	}

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		string result = "";

		for (int i=0; i<lines.Length-1; i++)
		{
			int originalLength = lines[i].Length;

			for (int j=i+1; j<lines.Length; j++)
			{
				string compared = stringsCompared(lines[i], lines[j]);
				int comparedLength = compared.Length;
				if (comparedLength == originalLength-1)
				{
					result = compared;
					goto Found;
				}
			}
		}
		Found:

        Console.WriteLine("AoC 02 part2: {0}", result);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
