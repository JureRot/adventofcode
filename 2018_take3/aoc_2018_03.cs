using System.Text.RegularExpressions;

namespace aoc_2018_take3;

class aoc_2018_03
{
	class Claim
	{
		public int id;
		public int x;
		public int y;
		public int h;
		public int w;

		public Claim(string[] values)
		{
			/*
			this.id = Int32.Parse(values[id]);
			this.x = Int32.Parse(values[x]);
			this.y = Int32.Parse(values[y]);
			this.h = Int32.Parse(values[h]);
			this.w = Int32.Parse(values[w]);
			*/
			int[] numValues = Array.ConvertAll(values, x => Int32.Parse(x));
			this.id = numValues[0];
			this.x = numValues[1];
			this.y = numValues[2];
			this.h = numValues[3];
			this.w = numValues[4];
		}
	}

	class Location
	{
		public HashSet<int> claims = new HashSet<int>();
	}

	class Canvas
	{
		public Location[,] canvas = new Location[1,1]{{new Location()}};
		public int x = 1;
		public int y = 1;

		private void expand(int width, int height) {
			Location[,] newCanvas = new Location[height,width];
			int oldWidth = canvas.GetLength(1);
			int oldHeight = canvas.GetLength(0);

			for (int y=0; y<newCanvas.GetLength(0); y++)
			{
				for (int x=0; x<newCanvas.GetLength(1); x++)
				{
					if (x<oldWidth && y<oldHeight)
					{
						newCanvas[y,x] = canvas[y,x];
					} else 
					{
						newCanvas[y,x] = new Location();
					}
				}
			}

			canvas = newCanvas;
			x = canvas.GetLength(1);
			y = canvas.GetLength(0);
		}

		public HashSet<int> add(Claim c)
		{
			HashSet<int> toRemove = new HashSet<int>();

			if ((c.x+c.h > this.x) || (c.y+c.w > this.y))
			{
				expand(Math.Max((c.x+c.h), this.x), Math.Max((c.y+c.w), this.y));
			}

			for (int y=c.y; y<c.y+c.w; y++)
			{
				for (int x=c.x; x<c.x+c.h; x++)
				{
					if (canvas[y,x].claims.Count > 0)
					{
						toRemove.UnionWith(canvas[y,x].claims);
						toRemove.Add(c.id);
					}

					canvas[y,x].claims.Add(c.id);
				}
			}

			return toRemove;
		}
	}

	static Claim parseLine(string line)
	{
		string[] values = Regex.Replace(line.Replace("#", ""), @"(\s@\s|,|:\s|x)", ";").Split(';');
		// remove # at the beginning because ita problem when spliting
		// replace all delimiters (including whitespace) with ;
		// split on ;
		// alternative approach: string[] values = Regex.Replace(line, @"(#|\s)", "").Split(new Char[]{'@', ',', ':', 'x'});

		return new Claim(values);
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		Canvas canvas = new Canvas();
		int overlapCount = 0;

		foreach (var line in lines)
		{
			Claim parsedLine = parseLine(line);
			canvas.add(parsedLine);
		}

		for (int y=0; y<canvas.y; y++)
		{
			for (int x=0; x<canvas.x; x++)
			{
				if (canvas.canvas[y,x].claims.Count > 1)
				{
					overlapCount++;;
				}
			}
		}

        Console.WriteLine("AoC 03 part1: {0}", overlapCount);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		Canvas canvas = new Canvas();
		HashSet<int> untouchedClaims = new HashSet<int>();

		foreach (var line in lines)
		{
			Claim parsedLine = parseLine(line);

			untouchedClaims.Add(parsedLine.id);

			HashSet<int> toRemove = canvas.add(parsedLine);
			foreach(int overlap in toRemove)
			{
				untouchedClaims.Remove(overlap);
			}
		}

        Console.WriteLine("AoC 03 part2: {0}", untouchedClaims.ToArray()[0]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
