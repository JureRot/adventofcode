namespace aoc_2018_take3;

class aoc_2018_15
{
	public enum LocationType
	{
		Empty,
		Wall,
		Unknown, //should not happen
	}

	public enum UnitType
	{
		Elf,
		Goblin,
		Unknown, //should not happen
	}

	public class Unit
	{
		public UnitType type;
		public int hp = 200;
		public int att;
		public int x;
		public int y;

		public Unit(UnitType type, int x, int y, int att = 3)
		{
			this.type = type;
			this.x = x;
			this.y = y;
			this.att = att;
		}
	}

	public class Location
	{
		public LocationType type;
		public List<Unit> unit = new List<Unit>();
		public int x;
		public int y;

		public Location(LocationType type, UnitType unit, int x, int y, int att = 3)
		{
			this.type = type;
			this.x = x;
			this.y = y;
			Unit newUnit = new Unit(unit, x, y, att);
			this.unit.Add(newUnit);
		}

		public Location(LocationType type, int x, int y)
		{
			this.type = type;
			this.x = x;
			this.y = y;
		}
	}

	public class AStarNode
	{
		public int x;
		public int y;
		public AStarNode? prev;
		public int path; // up till now
		public int heur; // heuristic score

		public AStarNode(int _x, int _y, AStarNode? _prev, int _path, Location _end)
		{
			x = _x;
			y = _y;
			prev = _prev;
			path = _path;
			heur = Math.Abs(x - _end.x) + Math.Abs(y - _end.y);
		}

		public int total // just a getter for total cost
		{
			get
			{
				return path + heur;
			}
		}
	}

	public static (int, int) getBestNode(Dictionary<(int, int), AStarNode> nodes)
	{
		int bestTotal = Int32.MaxValue;
		int bestHeur = Int32.MaxValue;
		int bestX = 0;
		int bestY = 0;

		foreach (AStarNode node in nodes.Values)
		{
			// prefer best total value
			if (node.total < bestTotal)
			{
				bestTotal = node.total;
				bestHeur = node.heur;
				bestX = node.x;
				bestY = node.y;

			} else if (node.total == bestTotal)
			{
				if (node.heur < bestHeur) //todo questionable
				{
					// else prefer nodes that are closest to end 
					bestHeur = node.heur;
					bestX = node.x;
					bestY = node.y;
				} else if (node.heur == bestHeur)
				{
					// else prefer reading order
					if (node.y < bestY) //todo questionable
					{
						bestX = node.x;
						bestY = node.y;
					} else if (node.y == bestY)
					{
						if (node.x < bestX)
						{
							bestX = node.x;
						}
					}
				}
			}
		}

		return (bestX, bestY);
	}

	public static List<(int, int)> getNeighbouringNodes(AStarNode node, Location[,] map, Dictionary<(int, int), AStarNode> closed, Location start)
	{
		List<(int, int)> neighbours = new List<(int, int)>();

		int x = node.x;
		int y = node.y;

		//todo questionable
		// down
		if (isEmpty(map[y+1, x]) || (y+1 == start.y && x == start.x))
		{
			if (!closed.ContainsKey((x, y+1)))
			{
				neighbours.Add((x, y+1));
			}
		}

		// right
		if (isEmpty(map[y, x+1]) || (y == start.y && x+1 == start.x))
		{
			if (!closed.ContainsKey((x+1, y)))
			{
				neighbours.Add((x+1, y));
			}
		}

		// left
		if (isEmpty(map[y, x-1]) || (y == start.y && x-1 == start.x))
		{
			if (!closed.ContainsKey((x-1, y)))
			{
				neighbours.Add((x-1, y));
			}
		}

		// up
		if (isEmpty(map[y-1, x]) || (y-1 == start.y && x == start.x)) // walkable
		{
			if (!closed.ContainsKey((x, y-1))) // not in closed
			{
				neighbours.Add((x, y-1));
			}
		}

		return neighbours;
	}

	public static (bool, int, Location) aStart(Location start, Location end, Location[,] map)
	{
		Dictionary<(int, int), AStarNode> open = new Dictionary<(int, int), AStarNode>();
		Dictionary<(int, int), AStarNode> closed = new Dictionary<(int, int), AStarNode>();

		// add starting (end in our case) possition to the open list
		AStarNode endLoc = new AStarNode(end.x, end.y, null, 0, start);
		open.Add((endLoc.x, endLoc.y), endLoc);

		while (open.Count() > 0)
		{
			// get current node
			(int currX, int currY) = getBestNode(open);
			AStarNode current = open[(currX, currY)];

			// remove from open
			open.Remove((currX, currY));
			// add to closed
			closed.Add((current.x, current.y), current);

			// end condition
			if (current.x == start.x && current.y == start.y)
			{
				return (true, current.total, map[current.prev!.y, current.prev!.x]);
			}

			List<(int, int)> neighbours = getNeighbouringNodes(current, map, closed, start);

			foreach ((int nX, int nY) in neighbours)
			{
				if (open.ContainsKey((nX, nY))) //is in open -> check if current path better
				{
					if (open[(nX, nY)].path > current.path+1)
					{
						open[(nX, nY)].path = current.path + 1;
						open[(nX, nY)].prev = current;
					} else if (open[(nX, nY)].path == current.path+1)
					{
						AStarNode? prev = open[(nX, nY)].prev;
						if (prev != null)
						{
							if (current.y < prev.y) //todo questionable
							{
								open[(nX, nY)].prev = current;
							} else if (current.x < prev.x)
							{
								open[(nX, nY)].prev = current;
							}
						}

					}
				} else { // not in open -> just add it
					open.Add((nX, nY), new AStarNode(nX, nY, current, current.path+1, start));
				}
			}
		}

		return (false, Int32.MaxValue, start);
	}
	
	public static (List<Unit>, List<Unit>, List<Unit>) getPlayOrder(Location[,] map)
	{
		//Queue<Unit> queue = new Queue<Unit>();
		List<Unit> queue = new List<Unit>();
		List<Unit> elves = new List<Unit>();
		List<Unit> goblins = new List<Unit>();

		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				if (map[y, x].unit.Count > 0)
				{
					Unit unit = map[y, x].unit.First();
					queue.Add(unit);
					if (unit.type == UnitType.Elf)
					{
						elves.Add(unit);
					} else
					{
						goblins.Add(unit);
					}
				}
			}
		}

		return (queue, elves, goblins);
	}

	public static bool isEmpty(Location loc)
	{
		if (loc.type==LocationType.Empty && loc.unit.Count==0)
		{
			return true;
		}

		return false;
	}

	public static (bool, (int, int)) isNextToOpponent(Unit unit, Location[,] map)
	{
		int x = unit.x;
		int y = unit.y;
		UnitType type = unit.type;
		int fewestHp = Int32.MaxValue;
		int oX = unit.x;
		int oY = unit.y;

		// up
		if (map[y-1, x].unit.Count()>0 && map[y-1, x].unit.First().type!=type)
		{
			Unit opp = map[y-1, x].unit.First();
			if (opp.hp < fewestHp)
			{
				fewestHp = opp.hp;
				oX = opp.x;
				oY = opp.y;
			}
		}

		// left
		if (map[y, x-1].unit.Count()>0 && map[y, x-1].unit.First().type!=type)
		{
			Unit opp = map[y, x-1].unit.First();
			if (opp.hp < fewestHp)
			{
				fewestHp = opp.hp;
				oX = opp.x;
				oY = opp.y;
			}
		}

		// right
		if (map[y, x+1].unit.Count()>0 && map[y, x+1].unit.First().type!=type)
		{
			Unit opp = map[y, x+1].unit.First();
			if (opp.hp < fewestHp)
			{
				fewestHp = opp.hp;
				oX = opp.x;
				oY = opp.y;
			}
		}

		// down
		if (map[y+1, x].unit.Count()>0 && map[y+1, x].unit.First().type!=type)
		{
			Unit opp = map[y+1, x].unit.First();
			if (opp.hp < fewestHp)
			{
				fewestHp = opp.hp;
				oX = opp.x;
				oY = opp.y;
			}
		}

		if (fewestHp == Int32.MaxValue)
		{
			return (false, (x, y));
		}

		return (true, (oX, oY));
	}

	public static List<Location> getNeighbouringLocations (Location[,] map, List<Unit> units)
	{
		List<Location> locations = new List<Location>();

		foreach (Unit unit in units)
		{
			int x = unit.x;
			int y = unit.y;

			// up
			if (isEmpty(map[y-1, x]))
			{
				locations.Add(map[y-1, x]);
			}
			// left
			if (isEmpty(map[y, x-1]))
			{
				locations.Add(map[y, x-1]);
			}
			// right
			if (isEmpty(map[y, x+1]))
			{
				locations.Add(map[y, x+1]);
			}
			// down
			if (isEmpty(map[y+1, x]))
			{
				locations.Add(map[y+1, x]);
			}
		}

		return locations;
	}

	public static (Location[,], bool) iteration(Location[,] map, bool strict = false)
	{
		// get play order
		(List<Unit> playOrder, List<Unit> elves, List<Unit> goblins) = getPlayOrder(map);

		while (playOrder.Count > 0)
		{
			Unit unit = playOrder.First();
			playOrder.RemoveAt(0);

			List<Unit> opponents;
			if (unit.type == UnitType.Elf)
			{
				opponents = goblins;
			} else
			{
				opponents = elves;
			}

			// check if any opponents
			if (opponents.Count == 0)
			{
				// end combat
				return (map, true);
			}

			// check if next to opponent
			(bool nextToOpponent, (int oX, int oY)) = isNextToOpponent(unit, map);

			if (!nextToOpponent) // move toward opponent
			{
				// get locations next to opponents
				List<Location> neighbouringLocations = getNeighbouringLocations(map, opponents);

				// a* to locations
				Location start = map[unit.y, unit.x];
				int shortestPath = Int32.MaxValue;
				Location? closest = null;
				Location? firstSteps = null;
				foreach (Location loc in neighbouringLocations)
				{
					(bool found, int length, Location firstStep) = aStart(start, loc, map);
					if (found)
					{
						if (length < shortestPath)
						{
							shortestPath = length;
							closest = loc;
							firstSteps = firstStep;
						} else if (length == shortestPath)
						{
							if (closest!=null && loc.y < closest.y) //todo double questionable
							{
								closest = loc;
							} else if (closest!=null && loc.x < closest.x)
							{
								closest = loc;
							}
						}

					} else // path not found
					{
						continue;
					}
				}

				if (closest!=null && firstSteps!=null)
				{
					//move to that location (update map)
					map[unit.y, unit.x].unit.Clear();
					unit.x = firstSteps!.x;
					unit.y = firstSteps!.y;
					map[firstSteps!.y, firstSteps!.x].unit.Add(unit);
				}
			}

			// attack opponent
			(nextToOpponent, (oX, oY)) = isNextToOpponent(unit, map);
			if (nextToOpponent)
			{
				// attack that unit (remove if dies)
				Unit defender = map[oY, oX].unit.First();
				defender.hp -= unit.att;
				if (defender.hp <= 0)
				{
					elves.Remove(defender);
					goblins.Remove(defender);
					playOrder.Remove(defender);
					map[oY, oX].unit.Clear();
					if (strict && defender.type==UnitType.Elf)
					{
						return (map, true);
					}
				}
			}
		}

		return (map, false);
	}

	public static int getSumStanding(Location[,] map)
	{
		int sum = 0;

		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				if (map[y, x].unit.Count() > 0)
				{
					sum += map[y, x].unit.First().hp;
				}
			}
		}

		return sum;
	}

	public static (UnitType, int) whoWon(Location[,] map)
	{
		int numSurvivors = 0;
		UnitType winner = UnitType.Unknown;
		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				if (map[y, x].unit.Count() > 0)
				{
					numSurvivors += map[y, x].unit.First().type==UnitType.Elf ? 1 : 0;
					if (winner == UnitType.Unknown)
					{
						winner = map[y, x].unit.First().type;
					} else if (map[y, x].unit.First().type != winner)
					{
						return (UnitType.Unknown, numSurvivors);
					}
				}
			}
		}

		return (winner, numSurvivors);
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		Location[,] map = new Location[lines.Count(), lines[0].Length];
		bool end = false;
		int counter = 0;

		for (int y=0; y<lines.Count(); y++)
		{
			for (int x=0; x<lines[y].Length; x++)
			{
				map[y, x] = lines[y][x] switch
				{
					'.' => new Location(LocationType.Empty, x, y),
					'#' => new Location(LocationType.Wall, x, y),
					'E' => new Location(LocationType.Empty, UnitType.Elf, x, y),
					'G' => new Location(LocationType.Empty, UnitType.Goblin, x, y),
					_ => new Location(LocationType.Unknown, x, y),
				};
			}
		}

		while (!end)
		{
			(map, end) = iteration(map);

			if (!end)
			{
				counter++;
			}
		}

		// this work(ed) for all examples but for the puzzle input
		// if that doesnt work do part2 but use floodmap instead of a*

		// THE PROBLEM WAS THAT I IMPLEMENTED MOVE WRONGLY

        Console.WriteLine("AoC 15 part1: {0}", counter * getSumStanding(map));

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int att = 3;

		while (true)
		{
			//Console.WriteLine(att);
			Location[,] map = new Location[lines.Count(), lines[0].Length];
			int numElves = 0;
			bool end = false;
			int counter = 0;
			for (int y=0; y<lines.Count(); y++)
			{
				for (int x=0; x<lines[y].Length; x++)
				{
					switch (lines[y][x])
					{
						case '.':
							map[y, x] = new Location(LocationType.Empty, x, y);
							break;
						case '#':
							map[y, x] = new Location(LocationType.Wall, x, y);
							break;
						case 'E':
							map[y, x] = new Location(LocationType.Empty, UnitType.Elf, x, y, att);
							numElves++;
							break;
						case 'G':
							map[y, x] = new Location(LocationType.Empty, UnitType.Goblin, x, y);
							break;
						default:
							map[y, x] = new Location(LocationType.Unknown, x, y);
							break;
					}
				}
			}

			while (!end)
			{
				(map, end) = iteration(map, true);

				if (!end)
				{
					counter++;
				}
			}

			(UnitType winner, int numSurvivors) = whoWon(map);
			if (winner==UnitType.Elf && numSurvivors==numElves)
			{
				Console.WriteLine("AoC 15 part2: {0}", counter * getSumStanding(map));
				break;
			} else
			{
				att++;
			}
		}

		//todo again this does not work
		// probably a* returns too quick but dont know

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
