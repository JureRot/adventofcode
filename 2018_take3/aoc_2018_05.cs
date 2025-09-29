namespace aoc_2018_take3;

class aoc_2018_05
{
	public static bool canUnitsReact(char a, char b)
	{
		return Math.Abs((int)a - (int)b) == 32;
	}

	public static string reactUnits(string str)
	{
		int i = 0;
		while (i<str.Length-1)
		{
			if (canUnitsReact(str[i], str[i+1]))
			{
				//str = str.Substring(0, i) + (str.Substring(Math.Min(i+2, str.Length-1)));
				str = str.Remove(i, 2);
				i = Math.Max(i-2, 0);
			} else
			{
				i++;
			}
		}

		return str;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var line = File.ReadAllLines(filename)[0];

		string result = reactUnits(line);

        Console.WriteLine("AoC 05 part1: {0}", result.Length);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var line = File.ReadAllLines(filename)[0];
		int minLength = Int32.MaxValue;
		char bestTrimmer = '@';

		for (int i=65; i<=90; i++)
		{
			string trimmed = line.Replace(Convert.ToChar(i).ToString(), "").Replace(Convert.ToChar(i+32).ToString(), "");

			var result = reactUnits(trimmed);

			if (result.Length < minLength){
				minLength = result.Length;
				bestTrimmer = Convert.ToChar(i);
			}
		}

        Console.WriteLine("AoC 05 part1: {0}", minLength);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
