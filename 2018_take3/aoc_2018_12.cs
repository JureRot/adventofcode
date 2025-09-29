namespace aoc_2018_take3;

class aoc_2018_12
{
	public static (string, int, int) iteration(string state, Dictionary<string, char> rules)
	{
		// extend
		state = "...." + state + "....";

		Char[] newState = state.ToCharArray();
		int newLeft = -4;
		int newRight = 4;

		// iterate
		for (int i=2; i<newState.Length-2; i++)
		{
			string key = state.Substring(i-2, 5);
			newState[i] = rules[key];
		}

		// adjust newLeft and newRight
		bool found = false;
		int n = 0;
		while (!found)
		{
			if (newState[n] == '#')
			{
				found = true;
				break;
			}
			n++;
			newLeft++;
		}
		int front = (-4 - newLeft) * -1;
		newState = newState[front..]; // removes first item
		// same as newState = newState.Skip(1).ToArray();
		// same as newState = newState.ToList().RemoveAt(0).ToArray();

		found = false;
		n = newState.Length-1;
		while (!found)
		{
			if (newState[n] == '#')
			{
				found = true;
				break;
			}
			n--;
			newRight--;
		}
		int back = 4 - newRight;
		newState = newState[..^back]; // removes last item
		// same as newState = newState.Take(newState.Count() - 1).ToArray();
		// same as Array.Resize(ref newState, newState.Length - 1);

		return (new string(newState), newLeft, newRight);
	}

	public static double getSum(string state, int left)
	{
		double sum = 0;
		for (int i=0; i<state.Length; i++)
		{
			if (state[i] == '#')
			{
				sum += i + left; // same as sum += i - Math.Abs(left);
			}
		}

		return sum;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int iterations = 20;
		string state = lines[0].Split(": ")[1];
		int left = 0;
		int right = state.Length-1;
		Dictionary<string, char> rules = new Dictionary<string, char>();

		for (int i=2; i<lines.Length; i++)
		{
			string[] split = lines[i].Split(" => ");
			rules[split[0]] = char.Parse(split[1]);
		}

		for (int i=0; i<iterations; i++)
		{
			(state, int newLeft, int newRight) = iteration(state, rules);
			left += newLeft;
			right += newRight;
		}

		double sum = getSum(state, left);

        Console.WriteLine("AoC 12 part1: {0}", sum);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		long iterations = 50000000000;
		string state = lines[0].Split(": ")[1];
		int left = 0;
		int right = state.Length-1;
		Dictionary<string, char> rules = new Dictionary<string, char>();
		double prevSum;
		int consistency = 0;
		double iter = 0;
		double increase = 0;

		for (int i=2; i<lines.Length; i++)
		{
			string[] split = lines[i].Split(" => ");
			rules[split[0]] = char.Parse(split[1]);
		}

		prevSum = getSum(state, left);

		// approach:
		// iterate until 100 iterations increase by the same increase between iterations
		// after that just multiply current sum by the increase*remaining iterations

		while (consistency<100 && iter<iterations)
		{
			(state, int newLeft, int newRight) = iteration(state, rules);
			left += newLeft;
			right += newRight;

			double sum = getSum(state, left);

			double diff = sum - prevSum;

			if (diff == increase)
			{
				consistency++;
			} else {
				consistency = 0;
				increase = diff;
			}

			prevSum = sum;
			iter++;
		}

        Console.WriteLine("AoC 12 part2: {0}", prevSum + ((iterations-iter)*increase));

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
