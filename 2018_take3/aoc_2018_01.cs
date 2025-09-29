namespace aoc_2018_take3;

class aoc_2018_01
{
	static int parseLine(string line)
	{
		int multiplier;
		switch (line[0])
		{
			case '+':
				multiplier = 1;
				break;
			case '-':
				multiplier = -1;
				break;
			default:
				multiplier = 0;
				break;
		}

		return Int32.Parse(line.Substring(1)) * multiplier;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
        int frequency = 0;
		
		var lines = File.ReadLines(filename);

		foreach (var line in lines)
		{
			frequency += parseLine((line));
		}

        Console.WriteLine("AoC 01 part1: {0}", frequency);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2_01(string filename)
    {
		// trying to first check if exists and than insert if doesnt
        var watch = System.Diagnostics.Stopwatch.StartNew();
		int frequency = 0;
        HashSet<int> frequencies = new HashSet<int>();
		bool found = false;
		
		var lines = File.ReadLines(filename);

		while (!found)
		{
			foreach (var line in lines)
			{
				frequency += parseLine((line));
				if (!frequencies.Contains(frequency))
				{
					frequencies.Add(frequency);
				} else {
					found = true;
					break;
				}
			}
		}

        Console.WriteLine("AoC 01 part2 apprach 1: {0}", frequency);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2_02(string filename)
    {
		// trying to insert it and checking if size changed
        var watch = System.Diagnostics.Stopwatch.StartNew();
		int frequency = 0;
        HashSet<int> frequencies = new HashSet<int>();
		int numFrequencies = 0;
		bool found = false;
		
		var lines = File.ReadLines(filename);

		while (!found)
		{
			foreach (var line in lines)
			{
				frequency += parseLine((line));
				frequencies.Add(frequency);
				int newCount = frequencies.Count;
				if (newCount != numFrequencies)
				{
					numFrequencies = newCount;
				} else {
					found = true;
					break;
				}
			}
		}

        Console.WriteLine("AoC 01 part2 apprach 2: {0}", frequency);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
