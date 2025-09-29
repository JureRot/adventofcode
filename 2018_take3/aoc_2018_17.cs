namespace aoc_2018_take3;

class aoc_2018_17
{
	public enum LocationStatus
	{
		Wall,
		Unreachable,
		Reachable,
		Full,
		Origin,
	}

	public enum IterationStatus
	{
		Unsearched,
		Flow,
		LeftBound,
		RightBound,
		FullBound,
		Endless,
		Finish,
	}

	public class Location
	{
		public LocationStatus status = LocationStatus.Unreachable;
		public IterationStatus searchStatus = IterationStatus.Unsearched;
	}

	public static (IterationStatus, Location[,], int, int) iteration(Location[,] map, int x, int y, int maxX, int maxY)
	{

		// endless backpropagation
		// check if below is endless
		if (map[y+1, x].searchStatus==IterationStatus.Endless) // below is endless
		{
			// finall check (backpropagated back to origin) 
			if (map[y-1, x].status == LocationStatus.Origin)
			{
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("END");
				return (IterationStatus.Finish, map, x, y-1);
			}

			if (map[y-1, x].status == LocationStatus.Reachable) // flowed from above
			{
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("endless up");
				return (IterationStatus.Endless, map, x, y-1);
			}

			if (map[y, x+1].status == LocationStatus.Reachable) // flowed from right
			{
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("endless up right");
				return (IterationStatus.Endless, map, x+1, y);
			}

			if (map[y, x-1].status == LocationStatus.Reachable) // flowed from left
			{
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("endless up left");
				return (IterationStatus.Endless, map, x-1, y);
			}
		}

		// check if left and right endless
		if (map[y, x-1].searchStatus==IterationStatus.Endless && map[y, x+1].searchStatus==IterationStatus.Endless) // left and right is endless
		{
			map[y, x].searchStatus = IterationStatus.Endless;
			Console.WriteLine("endless up up");
			return (IterationStatus.Endless, map, x, y-1);
		}

		// check if left is endless and right is bound OR right is endless and left is bound
		if ((map[y, x-1].searchStatus==IterationStatus.Endless && 
					map[y, x+1].searchStatus==IterationStatus.RightBound) ||
				(map[y, x-1].searchStatus==IterationStatus.LeftBound && 
				 	map[y, x+1].searchStatus==IterationStatus.Endless))
		{
			map[y, x].searchStatus = IterationStatus.Endless;
			Console.WriteLine("endless up up up");
			return (IterationStatus.Endless, map, x, y-1);
		}
		
		if (map[y, x-1].searchStatus==IterationStatus.Endless) // left is endless
		{
			if ((map[y+1, x].status==LocationStatus.Wall || 
					 map[y+1, x].status==LocationStatus.Full ||
					 map[y+1, x].searchStatus==IterationStatus.LeftBound ||
					 map[y+1, x].searchStatus==IterationStatus.RightBound) &&
					map[y, x+1].status == LocationStatus.Reachable) // bellow is ground and right is reachable
			{
				if (map[y, x+1].searchStatus == IterationStatus.LeftBound)
				{
					map[y, x].searchStatus = IterationStatus.Endless;
					Console.WriteLine("endless right up");
					return (IterationStatus.Endless, map, x, y);
				}
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("endless right");
				return (IterationStatus.Endless, map, x+1, y);
			}
		}

		if (map[y, x+1].searchStatus==IterationStatus.Endless) // right is endless
		{
			if ((map[y+1, x].status==LocationStatus.Wall || 
					 map[y+1, x].status==LocationStatus.Full ||
					 map[y+1, x].searchStatus==IterationStatus.LeftBound ||
					 map[y+1, x].searchStatus==IterationStatus.RightBound) &&
					map[y, x-1].status == LocationStatus.Reachable) // bellow is ground and left is reachable
			{
				if (map[y, x-1].searchStatus == IterationStatus.RightBound)
				{
					map[y, x].searchStatus = IterationStatus.Endless;
					Console.WriteLine("endless left up");
					return (IterationStatus.Endless, map, x, y);
				}
				map[y, x].searchStatus = IterationStatus.Endless;
				Console.WriteLine("endless left");
				return (IterationStatus.Endless, map, x-1, y);
			}
		}

		// would go below allowed level
		if (y+1 > maxY)
		{
			map[y+1, x].status = LocationStatus.Reachable;
			map[y+1, x].searchStatus = IterationStatus.Endless;
			Console.WriteLine("endless");
			return (IterationStatus.Endless, map, x, y);
		}

		// try to flow down
		if (map[y+1, x].status==LocationStatus.Unreachable) // below is empty
		{
			map[y+1, x].status = LocationStatus.Reachable;
			map[y+1, x].searchStatus = IterationStatus.Flow;
			Console.WriteLine("flow down");
			return (IterationStatus.Flow, map, x, y+1);
		}

		// below is wall or full level
		if (map[y+1, x].status==LocationStatus.Wall || 
				 map[y+1, x].status==LocationStatus.Full ||
				 map[y+1, x].searchStatus==IterationStatus.LeftBound ||
				 map[y+1, x].searchStatus==IterationStatus.RightBound)
		{
			// try to flow left
			if (x-1>0 && 
					map[y, x-1].status==LocationStatus.Unreachable) // left is empty
			{
				map[y, x-1].status = LocationStatus.Reachable;
				map[y, x-1].searchStatus = IterationStatus.Flow;
				Console.WriteLine("flow left");
				return (IterationStatus.Flow, map, x-1, y);
			}

			// try to flow right
			if (x+1<=maxX && 
					map[y, x+1].status==LocationStatus.Unreachable) // right is empty
			{
				map[y, x+1].status = LocationStatus.Reachable;
				map[y, x+1].searchStatus = IterationStatus.Flow;
				Console.WriteLine("flow right");
				return (IterationStatus.Flow, map, x+1, y);
			}

			// both bound and this level is full
			if ((map[y, x-1].status==LocationStatus.Wall || 
						map[y, x-1].searchStatus==IterationStatus.LeftBound) && 
					(map[y, x+1].status==LocationStatus.Wall || 
						 map[y, x+1].searchStatus==IterationStatus.RightBound))
			{
				map[y, x].status = LocationStatus.Full;
				map[y, x].searchStatus = IterationStatus.FullBound;
				Console.WriteLine("both bound");
				return (IterationStatus.FullBound, map, x, y);
			}

			// left is bound
			if (x-1>0 && 
					(map[y, x-1].status==LocationStatus.Wall || 
					 map[y, x-1].searchStatus==IterationStatus.LeftBound))
			{
				// right also bound
				if (map[y, x].searchStatus == IterationStatus.RightBound)
				{
					map[y, x].status = LocationStatus.Full;
					map[y, x].searchStatus = IterationStatus.FullBound;
					Console.WriteLine("both bound");
					return (IterationStatus.FullBound, map, x, y);
				}
				if (map[y, x].searchStatus != IterationStatus.LeftBound) // already left bound
				{
					map[y, x].searchStatus = IterationStatus.LeftBound;
					Console.WriteLine("left bound");
					return (IterationStatus.LeftBound, map, x, y);
				}
			}

			// right is bound
			if (x+1<=maxX && 
					(map[y, x+1].status==LocationStatus.Wall ||
					 map[y, x+1].searchStatus==IterationStatus.RightBound))
			{
				// left also bound
				if (map[y, x].searchStatus == IterationStatus.LeftBound)
				{
					map[y, x].status = LocationStatus.Full;
					map[y, x].searchStatus = IterationStatus.FullBound;
					Console.WriteLine("both bound");
					return (IterationStatus.FullBound, map, x, y);
				}
				if (map[y, x].searchStatus != IterationStatus.RightBound)
				{
					map[y, x].searchStatus = IterationStatus.RightBound;
					Console.WriteLine("right bound");
					return (IterationStatus.RightBound, map, x, y);
				}
			}

		}

		Console.WriteLine("{0} {1}", x, y);
		return (IterationStatus.Unsearched, map, x, y);
	}

	public static Location[,] dfs(Location[,] map, int x, int y, int maxX, int maxY)
	{
		int index = 0;
		//for (int n=0; n<117; n++)
		while (true)
		{
			//Console.WriteLine("{0}: {1}, {2}", n, x, y);
			(IterationStatus status, map, int newX, int newY) = iteration(map, x, y, maxX, maxY);
			Console.WriteLine("{0}: {1}", index, status);

			if (status == IterationStatus.Flow)
			{
				x = newX;
				y = newY;
			} else if (status == IterationStatus.LeftBound)
			{
				if (x+1<maxX && map[y, x+1].status!=LocationStatus.Wall)
				{
					x = x + 1;
				}
			} else if (status == IterationStatus.RightBound)
			{
				if (x-1>=0 && map[y, x-1].status!=LocationStatus.Wall)
				{
					x = x - 1;
				}
			} else if (status == IterationStatus.FullBound)
			{
				if (y-1 >= 0)
				{
					y = y - 1;
				}
			} else if (status == IterationStatus.Endless)
			{
				x = newX;
				y = newY;
			} else if (status == IterationStatus.Finish)
			{
				break;
			} else if (status == IterationStatus.Unsearched)
			{
				for (int j=Math.Max(0, y-30); j<Math.Min(map.GetLength(0), y+30); j++)
				{
					for (int i=Math.Max(0, x-30); i<Math.Min(map.GetLength(1), x+30); i++)
					{
						if (map[j, i].status == LocationStatus.Wall)
						{
							Console.Write('#');
						} else if (map[j, i].status == LocationStatus.Unreachable)
						{
							Console.Write('.');
						} else if (map[j, i].status == LocationStatus.Reachable)
						{
							if (map[j, i].searchStatus == IterationStatus.LeftBound)
							{
								Console.Write('<');
							} else if (map[j, i].searchStatus == IterationStatus.RightBound)
							{
								Console.Write('>');
							} else if (map[j, i].searchStatus == IterationStatus.Endless)
							{
								Console.Write('!');
							} else
							{
								Console.Write('|');
							}
						} else if (map[j, i].status == LocationStatus.Full)
						{
							Console.Write('~');
						} else if (map[j, i].status == LocationStatus.Origin)
						{
							Console.Write('+');
						}
					}
					Console.WriteLine();
				}

				break;

			}

			/*
			for (int j=0; j<map.GetLength(0); j++)
			{
				for (int i=494; i<map.GetLength(1); i++)
				{
					if (map[j, i].status == LocationStatus.Wall)
					{
						Console.Write('#');
					} else if (map[j, i].status == LocationStatus.Unreachable)
					{
						Console.Write('.');
					} else if (map[j, i].status == LocationStatus.Reachable)
					{
						if (map[j, i].searchStatus == IterationStatus.LeftBound)
						{
							Console.Write('<');
						} else if (map[j, i].searchStatus == IterationStatus.RightBound)
						{
							Console.Write('>');
						} else if (map[j, i].searchStatus == IterationStatus.Endless)
						{
							Console.Write('!');
						} else
						{
							Console.Write('|');
						}
					} else if (map[j, i].status == LocationStatus.Full)
					{
						Console.Write('~');
					} else if (map[j, i].status == LocationStatus.Origin)
					{
						Console.Write('+');
					}
				}
				Console.WriteLine();
			}
			*/
			index++;
		}

		return map;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);

		int minX = Int32.MaxValue;
		int maxX = Int32.MinValue;
		int minY = Int32.MaxValue;
		int maxY = Int32.MinValue;
		List<int[]> parsed = new List<int[]>();
		int reachable = 0;

		foreach (var line in lines)
		{
			string[] split = line.Split(", ");
			string[] first = split[0].Split('='); // x/y value
			string[] second = split[1].Split('='); // x/y range
			string[] range = second[1].Split(".."); // from to

			int lowX = 0;
			int highX = 0;
			int lowY = 0;
			int highY = 0;

			if (first[0].Equals("x")) // x first, y range
			{
				int firstValue = Int32.Parse(first[1]);
				if (firstValue < minX)
				{
					minX = firstValue;
				}
				if (firstValue > maxX)
				{
					maxX = firstValue;
				}

				lowX = firstValue;
				highX = firstValue;

				int firstRange = Int32.Parse(range[0]);
				int secondRange = Int32.Parse(range[1]);

				if (firstRange < minY)
				{
					minY = firstRange;
				}
				if (secondRange > maxY)
				{
					maxY = secondRange;
				}

				lowY = firstRange;
				highY = secondRange;
			} else // y first, x range
			{
				int firstValue = Int32.Parse(first[1]);
				if (firstValue < minY)
				{
					minY = firstValue;
				}
				if (firstValue > maxY)
				{
					maxY = firstValue;
				}

				lowY = firstValue;
				highY = firstValue;

				int firstRange = Int32.Parse(range[0]);
				int secondRange = Int32.Parse(range[1]);

				if (firstRange < minX)
				{
					minX = firstRange;
				}
				if (secondRange > maxX)
				{
					maxX = secondRange;
				}

				lowX = firstRange;
				highX = secondRange;
			}

			parsed.Add(new int[]{lowX, highX, lowY, highY});
		}

		Location[,] map = new Location[maxY+10, maxX+10];
		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				map[y, x] = new Location();
			}
		}

		foreach (int[] p in parsed)
		{
			if (p[0] == p[1]) // x is same
			{
				int x = p[0];
				int y1 = p[2];
				int y2 = p[3];
				for (int y=y1; y<=y2; y++)
				{
					map[y, x].status = LocationStatus.Wall;
				}
			} else // y is same
			{
				int y = p[2];
				int x1 = p[0];
				int x2 = p[1];
				for (int x=x1; x<=x2; x++)
				{
					map[y, x].status = LocationStatus.Wall;
				}
			}
		}
		map[0, 500].status = LocationStatus.Origin;


		//todo DFS from here on
		/*
		for (int j=0; j<map.GetLength(0); j++)
		{
			for (int i=494; i<map.GetLength(1); i++)
			{
				if (map[j, i].status == LocationStatus.Wall)
				{
					Console.Write('#');
				} else if (map[j, i].status == LocationStatus.Unreachable)
				{
					Console.Write('.');
				} else if (map[j, i].status == LocationStatus.Reachable)
				{
					Console.Write('|');
				} else if (map[j, i].status == LocationStatus.Full)
				{
					Console.Write('~');
				} else if (map[j, i].status == LocationStatus.Origin)
				{
					Console.Write('+');
				}
			}
			Console.WriteLine();
		}
		*/

		map = dfs(map, 500, 0, maxX+1, maxY);

		/*
		for (int j=0; j<map.GetLength(0); j++)
		{
			for (int i=494; i<map.GetLength(1); i++)
			{
				if (map[j, i].status == LocationStatus.Wall)
				{
					Console.Write('#');
				} else if (map[j, i].status == LocationStatus.Unreachable)
				{
					Console.Write('.');
				} else if (map[j, i].status == LocationStatus.Reachable)
				{
					if (map[j, i].searchStatus == IterationStatus.LeftBound)
					{
						Console.Write('<');
					} else if (map[j, i].searchStatus == IterationStatus.RightBound)
					{
						Console.Write('>');
					} else if (map[j, i].searchStatus == IterationStatus.Endless)
					{
						Console.Write('!');
					} else
					{
						Console.Write('|');
					}
				} else if (map[j, i].status == LocationStatus.Full)
				{
					Console.Write('~');
				} else if (map[j, i].status == LocationStatus.Origin)
				{
					Console.Write('+');
				}
			}
			Console.WriteLine();
		}
		*/

		for (int j=1; j<map.GetLength(0)-1; j++)
		{
			for (int i=0; i<map.GetLength(1); i++)
			{
				if (map[j, i].status==LocationStatus.Reachable || map[j, i].status==LocationStatus.Full)
				{
					//Console.Write('X');
					reachable++;
				} else
				{
					//Console.Write(' ');
				}
			}
			//Console.WriteLine();
		}

		//todo water can flow on something bound on just one side
		// when encountering full -> fill it from wall to wall
		// remove that if l or r bound below cant go down
		//todo backpropagation near bound does not check if above is spout
		// check if above is spout else check where is bound

		//todo or use recursion

		Console.WriteLine("{0} {1}; {2}, {3}", minX, maxX, minY, maxY);

        Console.WriteLine("AoC 17 part1: {0}", reachable);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
