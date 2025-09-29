namespace aoc_2018_take3;

class aoc_2018_06
{
	public class GridNode
	{
		public int? closest;
		public int? distance;

		public GridNode(int? closest, int? distance)
		{
			this.closest = closest;
			this.distance = distance;
		}
		
		public GridNode(int? distance)
		{
			this.distance = distance;
		}
	}

	public static GridNode[][] setupGrid(GridNode[][] grid, int x, int y)
	{
		// just creates a big enough grid so nodes can be set

		if (grid.Length < y)
		{
			Array.Resize(ref grid, y+1);
		}

		if (grid[y] == null)
		{
			grid[y] = new GridNode[x+1];
		} else
		{
			if (grid[y].Length < x)
			{
				Array.Resize(ref grid[y], x+1);
			}
		}

		return grid;
	}

	public static GridNode[][] resizeGrid(GridNode[][] grid)
	{
		// extends grid in all directions by 1/2 of size and makes it non-jagged

		// find maxX
		int maxX = 0;
		for (int y=0; y<grid.Length; y++)
		{
			if (grid[y]?.Length > maxX)
			{
				maxX = grid[y].Length;
			}
		}

		// increase y size
		int maxY = grid.Length;
		GridNode[][] temp = new GridNode[Convert.ToInt32(maxY*1.5)][];
		GridNode[][] top = new GridNode[maxY/2][];
		//grid = top.Concat(grid).ToArray(); //concat is slow for big arrays
		top.CopyTo(temp, 0);
		grid.CopyTo(temp, maxY/2);
		grid = temp;
		Array.Resize(ref grid, maxY*2);

		// than  resize x and make array non-jagged at the same time
		for (int y=0; y<grid.Length; y++)
		{
			Array.Resize(ref grid[y], Convert.ToInt32(maxX*1.5));
			grid[y] = new GridNode[Convert.ToInt32(maxX/2)].Concat(grid[y]).ToArray();
		}

		return grid;
	}

	public static GridNode[][] gridFlood(GridNode[][] grid)
	{
		int yLenght = grid.Length;
		int xLenght = grid[0].Length;

		// pass 1
		for (int y=0; y<yLenght; y++)
		{
			for (int x=0; x<xLenght; x++)
			{
				// create node if not exists
				//grid[y][x] = grid[y][x] ?? new GridNode(Int32.MaxValue);
				if (grid[y][x] == null)
 				{
					grid[y][x] =  new GridNode(Math.Max(yLenght, xLenght));
				}

				int?[] neighbors;
				int?[] ranges;
				if (x>0 && y>0) // update both
				{
					// top, left, self
					neighbors = new int?[]{
						grid[y-1][x].closest,
						grid[y][x-1].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y-1][x].distance+1,
						grid[y][x-1].distance+1,
						grid[y][x].distance};

				} else if (x > 0) // update x only
				{
					// left, self
					neighbors = new int?[]{
						grid[y][x-1].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y][x-1].distance+1,
						grid[y][x].distance};

				} else if (y > 0) // update y only
				{
					// top, left, self
					neighbors = new int?[]{
						grid[y-1][x].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y-1][x].distance+1,
						grid[y][x].distance};

				} else { // else we cant update
					neighbors = new int?[0];
					ranges = new int?[0];
				}

				int? newMin = Math.Max(yLenght, xLenght);
				HashSet<int?> newClosests = new HashSet<int?>();
				for (int i=0; i<ranges.Length; i++)
				{
					if (ranges[i] < newMin){
						newMin = ranges[i];
						newClosests.Clear();
						newClosests.Add(neighbors[i]);

					} else if (ranges[i] == newMin)
					{
						newClosests.Add(neighbors[i]);
					}
				}

				if (newClosests.Count == 1) {
					grid[y][x] = new GridNode(newClosests.ToArray()[0], newMin);
				} else {
					grid[y][x] = new GridNode(newMin);
				}
			}
		}

		// pass 2
		for (int y=yLenght-1; y>=0; y--)
		{
			for (int x=xLenght-1; x>=0; x--)
			{
				int?[] neighbors;
				int?[] ranges;
				if (x<xLenght-1 && y<yLenght-1) // update both
				{
					// bottom, right, self
					neighbors = new int?[]{
						grid[y+1][x].closest,
						grid[y][x+1].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y+1][x].distance+1,
						grid[y][x+1].distance+1,
						grid[y][x].distance};

				} else if (x < xLenght-1) // update x only
				{
					// right, self
					neighbors = new int?[]{
						grid[y][x+1].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y][x+1].distance+1,
						grid[y][x].distance};

				} else if (y < yLenght-1) // update y only
				{
					// bottom, self
					neighbors = new int?[]{
						grid[y+1][x].closest,
						grid[y][x].closest};
					ranges = new int?[]{
						grid[y+1][x].distance+1,
						grid[y][x].distance};

				} else { // else we cant update
					neighbors = new int?[0];
					ranges = new int?[0];
				}

				int? newMin = Math.Max(yLenght, xLenght);
				HashSet<int?> newClosests = new HashSet<int?>();
				for (int i=0; i<ranges.Length; i++)
				{
					if (ranges[i] < newMin){
						newMin = ranges[i];
						newClosests.Clear();
						newClosests.Add(neighbors[i]);

					} else if (ranges[i] == newMin)
					{
						newClosests.Add(neighbors[i]);
					}
				}

				if (newClosests.Count == 1) {
					grid[y][x] = new GridNode(newClosests.ToArray()[0], newMin);
				} else {
					grid[y][x] = new GridNode(newMin);
				}
			}
		}

		return grid;
	}

	public static HashSet<int?> getInfinities(GridNode[][] grid)
	{
		HashSet<int?> infinities = new HashSet<int?>();

		// go around the border and note all that are there (those are infinite)
		int lastRowIndex = grid.Length-1;
		int lastColumnIndex = grid[0].Length-1;

		for (int x=0; x<=lastColumnIndex; x++)
		{
			infinities.Add(grid[0][x].closest);
			infinities.Add(grid[lastRowIndex][x].closest);
		}

		for (int y=1; y<=lastRowIndex-1; y++)
		{
			infinities.Add(grid[y][0].closest);
			infinities.Add(grid[y][lastColumnIndex].closest);
		}

		return infinities;
	}

	public static int getBiggest(GridNode[][] grid, HashSet<int?> infinities)
	{
		Dictionary<int, int> counts = new Dictionary<int, int>();

		for (int y=0; y<grid.Length; y++)
		{
			for (int x=0; x<grid[y].Length; x++)
			{
				int? nodeMaybe = grid[y][x].closest;

				if (nodeMaybe==null || infinities.Contains(nodeMaybe))
				{
					continue;
				}

				int node = Convert.ToInt32(nodeMaybe);

				if (!counts.ContainsKey(node))
				{
					counts.Add(node, 1);
				} else {
					counts[node]++;
				}
			}
		}

		var ordered = counts.OrderBy(x => x.Value);

		return ordered.Last().Value;
	}

	public static int[][] getMask(int maxX, int maxY, Dictionary<int, int[]> coords, int maxDist)
	{
		int[][] mask = new int[maxY+1][];

		for (int y=0; y<=maxY; y++)
		{
			mask[y] = new int[maxX+1];

			for (int x=0; x<=maxX; x++)
			{
				int dist = 0;
				foreach (int k in coords.Keys)
				{
					dist += Math.Abs(coords[k][0] - x);
					dist += Math.Abs(coords[k][1] - y);
				}

				if (dist < maxDist){
					mask[y][x] = 1;
				}
			}
		}

		return mask;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		GridNode[][] grid = new GridNode[0][];

		for (int i=0; i<lines.Length; i++)
		{
			string[] locs = lines[i].Split(", ");
			int x = Int32.Parse(locs[0]);
			int y = Int32.Parse(locs[1]);

			grid = setupGrid(grid, x, y);

			grid[y][x] = new GridNode(i, 0);
		}

		grid = resizeGrid(grid);

		grid = gridFlood(grid);

		HashSet<int?> infinities = getInfinities(grid);

		int biggest = getBiggest(grid, infinities);

        Console.WriteLine("AoC 06 part1: {0}", biggest);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		Dictionary<int, int[]> coords = new Dictionary<int, int[]>();
		int maxDistance = 10000;
		int maxX = 0;
		int maxY = 0;


		for (int i=0; i<lines.Length; i++)
		{
			string[] locs = lines[i].Split(", ");
			int x = Int32.Parse(locs[0]);
			int y = Int32.Parse(locs[1]);

			coords.Add(i, new int[]{x, y});

			if (x > maxX)
			{
				maxX = x;
			}
			if (y > maxY)
			{
				maxY = y;
			}
		}

		int[][] mask = getMask(maxX, maxY, coords, maxDistance);

		int totalCount = 0;
		for (int y=0; y<mask.Length; y++)
		{
			totalCount += mask[y].Sum();
		}

        Console.WriteLine("AoC 06 part1: {0}", totalCount);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
