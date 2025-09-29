namespace aoc_2018_take3;

class aoc_2018_11_take2
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

	public static (int, int, int) getCellPower(int[,] summed, int windowSize)
	{
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;

		for (int j=0; j<summed.GetLength(0)-(windowSize-1); j++)
		{
			for (int i=0; i<summed.GetLength(1)-(windowSize-1); i++)
			{
				int power = 0;
				power += summed[j+(windowSize-1), i+(windowSize-1)];
				if (i > 0)
				{
					power -= summed[j+(windowSize-1), i-1];
				}
				if (j > 0)
				{
					power -= summed[j-1, i+(windowSize-1)];
				}
				if (i>0 && j>0)
				{
					power += summed[j-1, i-1];
				}

				if (power > largestPower)
				{
					largestPower = power;
					largestX = i+1;
					largestY = j+1;
				}
			}
		}

		return (largestPower, largestX, largestY);
	}

    public static void part1()
    {
		//todo try using summed-area table
		// https://en.wikipedia.org/wiki/Summed-area_table

        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		int input = 1309;
		int[,] grid = new int[300, 300];
		int[,] summedAreaTable = new int[300, 300];
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;

		// set power levels and create summed-area table
		for (int j=0; j<grid.GetLength(0); j++)
		{
			for (int i=0; i<grid.GetLength(1); i++)
			{
				int summed = getPowerLevel(i, j, input);
				grid[j, i] = summed;

				if (i > 0)
				{
					summed += summedAreaTable[j, i-1];
				}
				if (j > 0)
				{
					summed += summedAreaTable[j-1, i];
				}
				if (i>0 && j>0)
				{
					summed -= summedAreaTable[j-1, i-1];
				}

				summedAreaTable[j, i] = summed;
			}
		}

		(largestPower, largestX, largestY) = getCellPower(summedAreaTable, 3);

        Console.WriteLine("AoC 11 take2 part1: {0},{1}", largestX, largestY);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		int input = 1309;
		int[,] grid = new int[300, 300];
		int[,] summedAreaTable = new int[300, 300];
		int largestPower = Int32.MinValue;
		int largestX = 0;
		int largestY = 0;
		int largestWindowSize = 0;

		// set power levels and create summed-area table
		for (int j=0; j<grid.GetLength(0); j++)
		{
			for (int i=0; i<grid.GetLength(1); i++)
			{
				int summed = getPowerLevel(i, j, input);
				grid[j, i] = summed;

				if (i > 0)
				{
					summed += summedAreaTable[j, i-1];
				}
				if (j > 0)
				{
					summed += summedAreaTable[j-1, i];
				}
				if (i>0 && j>0)
				{
					summed -= summedAreaTable[j-1, i-1];
				}

				summedAreaTable[j, i] = summed;
			}
		}

		for (int n=1; n<=300; n++)
		{
			(int largestCurrPower, int largestCurrX, int largestCurrY) = getCellPower(summedAreaTable, n);

			if (largestCurrPower > largestPower)
			{
				largestPower = largestCurrPower;
				largestX = largestCurrX;
				largestY = largestCurrY;
				largestWindowSize = n;
			}
		}

		// ok, this is fast enought

        Console.WriteLine("AoC 11 take2 part2: {0},{1},{2}", largestX, largestY, largestWindowSize);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
