namespace aoc_2018_take3;

class aoc_2018_11
{
	public static int getPowerLevel(int x, int y, int serial)
	{
		int powerLevel = 0;

		int rackId = (x+1) + 10;
		powerLevel += rackId;
		powerLevel *= (y+1);
		powerLevel += serial;
		powerLevel *= rackId;
		powerLevel = (powerLevel / 100) % 10; // algo for n-th digi: (number // 10**n) % 10
		powerLevel -= 5;

		return powerLevel;
	}

	public static (int[,,], int, int, int) getCellPower(int[,,] grid, int windowSize)
	{
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;

		(int times, int level) = getLargestDivisor(windowSize);

		for (int y=0; y<grid.GetLength(0)-(windowSize-1); y++)
		{
			for (int x=0; x<grid.GetLength(1)-(windowSize-1); x++)
			{
				int power = 0;

				for (int j=0; j<times; j++)
				{
					for (int i=0; i<times; i++)
					{
						int localPower = grid[y+(j*level), x+(i*level),level];
						power += localPower;
					}
				}
				grid[y, x, windowSize] = power;

				if (power > largestPower)
				{
					largestPower = power;
					largestX = x+1;
					largestY = y+1;
				}
			}
		}

		return (grid, largestPower, largestX, largestY);
	}

	public static (int, int) getLargestDivisor(int n)
	{
		for (int i=2; i<=Math.Sqrt(n); i++)
		{
			if (n%i == 0)
			{
				return (i, n/i);
			}
		}

		return (n, 1);
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		int input = 1309;
		int[,,] grid = new int[300, 300, 4];
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;

		// set power levels
		for (int j=0; j<grid.GetLength(0); j++)
		{
			for (int i=0; i<grid.GetLength(1); i++)
			{
				grid[j, i,1] = getPowerLevel(i, j, input);
			}
		}

		(grid, largestPower, largestX, largestY) = getCellPower(grid, 3);

        Console.WriteLine("AoC 11 part1: {0},{1}", largestX, largestY);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		int input = 1309;
		int[,,] grid = new int[300, 300, 301];
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;
		int largestWindowSize = 0;

		// set power levels
		for (int j=0; j<grid.GetLength(0); j++)
		{
			for (int i=0; i<grid.GetLength(1); i++)
			{
				grid[j, i, 1] = getPowerLevel(i, j, input);
			}
		}

		for (int n=1; n<=300; n++)
		{
			(grid, int largestCurrPower, int largestCurrX, int largestCurrY) = getCellPower(grid, n);

			if (largestCurrPower > largestPower)
			{
				largestPower = largestCurrPower;
				largestX = largestCurrX;
				largestY = largestCurrY;
				largestWindowSize = n;
			}

			//Console.WriteLine(n);
		}

		//todo this works but its still very slow (like 5 minutes)
		// one approach is to stop when number start to get smaller (around windowSize = 20)
		// or try another approach

        Console.WriteLine("AoC 11 part1: {0},{1},{2}", largestX, largestY, largestWindowSize);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
