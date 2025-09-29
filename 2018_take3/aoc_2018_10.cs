namespace aoc_2018_take3;

class aoc_2018_10
{
	public class Star
	{
		public int posX;
		public int posY;
		public int velX;
		public int velY;

		public Star(int posX, int posY, int velX, int velY)
		{
			this.posX = posX;
			this.posY = posY;
			this.velX = velX;
			this.velY = velY;
		}
	}

	public static Dictionary<int, Dictionary<int, int>> setupSky(Dictionary<int, Dictionary<int, int>> sky, int x, int y)
	{
		if (!sky.ContainsKey(y))
		{
			sky[y] = new Dictionary<int, int>();
		}
		if (!sky[y].ContainsKey(x))
		{
			sky[y][x] = 0;
		}

		return sky;
	}
	
	public static (Dictionary<int, Dictionary<int, int>>, List<Star>, int, int, int, int) iterate (Dictionary<int, Dictionary<int, int>> sky, List<Star> stars, int direction = 1)
	{
		int minX = Int32.MaxValue;
		int maxX = Int32.MinValue;
		int minY = Int32.MaxValue;
		int maxY = Int32.MinValue;

		foreach (Star s in stars)
		{
			int newX = s.posX + (s.velX * direction);
			int newY = s.posY + (s.velY * direction);

			if (newX < minX)
			{
				minX = newX;
			}
			if (newX > maxX)
			{
				maxX = newX;
			}
			if (newY < minY)
			{
				minY = newY;
			}
			if (newY > maxY)
			{
				maxY = newY;
			}

			// change in sky (--, ++)
			sky[s.posY][s.posX]--;
			sky = setupSky(sky, newX, newY);
			sky[newY][newX]++;

			// update pos for star
			s.posX = newX;
			s.posY = newY;
		}

		return (sky, stars, minX, maxX, minY, maxY);
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		Dictionary<int, Dictionary<int, int>> sky = new Dictionary<int, Dictionary<int, int>>();
		List<Star> stars = new List<Star>();
		int minX = Int32.MaxValue;
		int maxX = Int32.MinValue;
		int minY = Int32.MaxValue;
		int maxY = Int32.MinValue;
		double area = 0;
		bool smallest = false;

		foreach (var line in lines)
		{
			string[] parsed = line.Replace(" ", "").Split(new Char[]{'<', ',', '>'});
			int posX = Int32.Parse(parsed[1]);
			int posY = Int32.Parse(parsed[2]);
			int velX = Int32.Parse(parsed[4]);
			int velY = Int32.Parse(parsed[5]);

			if (posX < minX)
			{
				minX = posX;
			}
			if (posX > maxX)
			{
				maxX = posX;
			}
			if (posY < minY)
			{
				minY = posY;
			}
			if (posY > maxY)
			{
				maxY = posY;
			}
			sky = setupSky(sky, posX, posY);

			Star star = new Star(posX, posY, velX ,velY);
			sky[posY][posX] = 1;
			stars.Add(star);
		}

		area = Convert.ToDouble(maxX-minX) * Convert.ToDouble(maxY-minY);

		while (!smallest)
		{
			Dictionary<int, Dictionary<int, int>> newSky;
			List<Star> newStars;
			int newMinX;
			int newMaxX;
			int newMinY;
			int newMaxY;
			double newArea;

			(newSky, newStars, newMinX, newMaxX, newMinY, newMaxY) = iterate(sky, stars);

			newArea = Convert.ToDouble(newMaxX-newMinX) * Convert.ToDouble(newMaxY-newMinY);

			if (newArea < area)
			{
				sky = newSky;
				stars = newStars;
				minX = newMinX;
				maxX = newMaxX;
				minY = newMinY;
				maxY = newMaxY;
				area = newArea;
			} else {
				smallest = true;
				break;
			}
		}

		// dictionary is a reference type so the original object is changed within a function
		iterate(sky, stars, -1);

		Console.WriteLine();
		for (int j=minY; j<=maxY; j++)
		{
			for (int i=minX; i<=maxX; i++)
			{
				if (sky.ContainsKey(j) && sky[j].ContainsKey(i) && sky[j][i] > 0)
				{
					Console.Write('#');
				} else
				{
					Console.Write('.');
				}
			}
			Console.WriteLine();
		}
		Console.WriteLine();

        Console.WriteLine("AoC 10 part1: {0}", "buhtk");

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		Dictionary<int, Dictionary<int, int>> sky = new Dictionary<int, Dictionary<int, int>>();
		List<Star> stars = new List<Star>();
		int minX = Int32.MaxValue;
		int maxX = Int32.MinValue;
		int minY = Int32.MaxValue;
		int maxY = Int32.MinValue;
		double area = 0;
		bool smallest = false;
		int counter = 0;

		foreach (var line in lines)
		{
			string[] parsed = line.Replace(" ", "").Split(new Char[]{'<', ',', '>'});
			int posX = Int32.Parse(parsed[1]);
			int posY = Int32.Parse(parsed[2]);
			int velX = Int32.Parse(parsed[4]);
			int velY = Int32.Parse(parsed[5]);

			if (posX < minX)
			{
				minX = posX;
			}
			if (posX > maxX)
			{
				maxX = posX;
			}
			if (posY < minY)
			{
				minY = posY;
			}
			if (posY > maxY)
			{
				maxY = posY;
			}
			sky = setupSky(sky, posX, posY);

			Star star = new Star(posX, posY, velX ,velY);
			sky[posY][posX] = 1;
			stars.Add(star);
		}

		area = Convert.ToDouble(maxX-minX) * Convert.ToDouble(maxY-minY);

		while (!smallest)
		{
			Dictionary<int, Dictionary<int, int>> newSky;
			List<Star> newStars;
			int newMinX;
			int newMaxX;
			int newMinY;
			int newMaxY;
			double newArea;

			(newSky, newStars, newMinX, newMaxX, newMinY, newMaxY) = iterate(sky, stars);

			newArea = Convert.ToDouble(newMaxX-newMinX) * Convert.ToDouble(newMaxY-newMinY);

			if (newArea < area)
			{
				sky = newSky;
				stars = newStars;
				minX = newMinX;
				maxX = newMaxX;
				minY = newMinY;
				maxY = newMaxY;
				area = newArea;
				counter++;
			} else {
				smallest = true;
				break;
			}
		}

		//iterate(sky, stars, -1);
		// no need to iterate once reverse since we only want the number

        Console.WriteLine("AoC 10 part1: {0}", counter);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
