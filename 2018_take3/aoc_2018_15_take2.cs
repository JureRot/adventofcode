namespace aoc_2018_take3;

class aoc_2018_15_take2
{
	public enum LocationType
	{
		Unknown, // should not happen
		Empty,
		Wall,
	}

	public enum UnitType
	{
		Unknown, // should not happen
		None, // used when no unit
		Elf,
		Goblin,
	}

	public class Unit
	{
		public int x;
		public int y;
		public UnitType type = UnitType.Unknown;
		public int hp = 200;
		public int att;

		public Unit(int _x, int _y, UnitType _type, int _att = 3)
		{
			x = _x;
			y = _y;
			type = _type;
			att = _att;
		}
	}

	public class Location
	{
		public int x;
		public int y;
		public LocationType type = LocationType.Unknown;
		public Unit? unit = null;

		public Location(int _x, int _y, LocationType _type)
		{
			x = _x;
			y = _y;
			type = _type;
		}

		public Location(int _x, int _y, LocationType _type, Unit _unit)
		{
			x = _x;
			y = _y;
			type = _type;
			unit = _unit;
		}
	}

	public static List<Unit> getPlayOrder(Location[,] map)
	{
		List<Unit> playOrder = new List<Unit>();

		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				Location loc = map[y, x];
				if (loc.unit != null)
				{
					playOrder.Add(loc.unit);
				}
			}
		}

		return playOrder;
	}

	public static Unit? isOpponent(Unit? unit, Unit? defender, UnitType type)
	{
		if (unit!=null && unit.type!=type)
		{
			if (defender == null)
			{
				defender = unit;
			} else {
				if (unit.hp < defender.hp)
				{
					defender = unit;
				}
			}
		}
		
		return defender;
	}

	public static (bool, (int, int)) isNextToOpponent(Location[,] map, Unit unit)
	{
		Unit? defender = null;

		// up
		Unit? up = map[unit.y-1, unit.x].unit;
		defender = isOpponent(up, defender, unit.type);

		// left
		Unit? left = map[unit.y, unit.x-1].unit;
		defender = isOpponent(left, defender, unit.type);

		// right
		Unit? right = map[unit.y, unit.x+1].unit;
		defender = isOpponent(right, defender, unit.type);

		// down
		Unit? down = map[unit.y+1, unit.x].unit;
		defender = isOpponent(down, defender, unit.type);

		if (defender != null)
		{
			return (true, (defender.x, defender.y));
		} else 
		{
			return (false, (0, 0));
		}
	}

	public static List<Unit> getOpponents(Location[,] map, UnitType type)
	{
		List<Unit> opponents = new List<Unit>();

		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				Location loc = map[y, x];
				if (loc.unit != null && loc.unit.type != type)
				{
					opponents.Add(loc.unit);
				}
			}
		}

		return opponents;
	}

	public static List<Location> getAdjacent(Location[,] map, List<Unit> opps)
	{
		List<Location> adjacent = new List<Location>();

		foreach (Unit u in opps)
		{
			// up
			if (map[u.y-1, u.x].type==LocationType.Empty && map[u.y-1, u.x].unit==null)
			{
				adjacent.Add(map[u.y-1, u.x]);
			}

			// left
			if (map[u.y, u.x-1].type==LocationType.Empty && map[u.y, u.x-1].unit==null)
			{
				adjacent.Add(map[u.y, u.x-1]);
			}

			// right
			if (map[u.y, u.x+1].type==LocationType.Empty && map[u.y, u.x+1].unit==null)
			{
				adjacent.Add(map[u.y, u.x+1]);
			}

			// down
			if (map[u.y+1, u.x].type==LocationType.Empty && map[u.y+1, u.x].unit==null)
			{
				adjacent.Add(map[u.y+1, u.x]);
			}
		}

		return adjacent;
	}

	public enum NodeStatus
	{
		Unvited,
		Open,
		Closed,
		Untraversable,
	}

	public class Node
	{
		public int x;
		public int y;
		public int value = Int32.MaxValue;
		public Node? prev;
		public NodeStatus status = NodeStatus.Unvited;

		public Node(int _x, int _y)
		{
			x = _x;
			y = _y;
		}

		public Node(int _x, int _y, Node _prev)
		{
			x = _x;
			y = _y;
			prev = _prev;
		}
	}

	public static (Queue<Node>, int) handleNeighbours(Location start, Node[,] floodmap, Queue<Node> open, int numFound, Node current, Location loc, Node node)
	{
		if (loc.type == LocationType.Wall)
		{
			node.status = NodeStatus.Untraversable;
		} else {
			if (node.status == NodeStatus.Unvited) // if univisted just add
			{
				node.status = NodeStatus.Open;
				node.value = current.value + 1;
				node.prev = current;
			} else if (node.status == NodeStatus.Open) // if open check if new path better
			{
				if (current.value+1 < node.value)
				{
					node.value = current.value + 1;
					node.prev = current;
				}
			}

			// at the end check if has unit
			if (node.status==NodeStatus.Open)
			{
				if (loc.unit==null)
				{
					open.Enqueue(floodmap[node.y, node.x]);
				} else
				{
					if (loc.unit.type != start.unit!.type)
					{
						numFound++;
					}
				}
			}
		}

		return (open, numFound);
	}

	public static Node[,] getFloodMap(Location[,] map, Location start)
	{
		Node[,] floodmap = new Node[map.GetLength(0), map.GetLength(1)];
		//do we need to do this
		for (int y=0; y<floodmap.GetLength(0); y++)
		{
			for (int x=0; x<floodmap.GetLength(1); x++)
			{
				floodmap[y, x] = new Node(x, y);
			}
		}

		Queue<Node> open = new Queue<Node>();
		open.Enqueue(floodmap[start.y, start.x]);
		floodmap[start.y, start.x].status = NodeStatus.Open;
		floodmap[start.y, start.x].value = 0;
		int numFound = 0;

		while (open.Count>0 && numFound<=0)
		{
			Node current = open.Dequeue();
			floodmap[current.y, current.x].status = NodeStatus.Closed;

			// add neighbours
			// up
			Location upLoc = map[current.y-1, current.x];
			Node up = floodmap[current.y-1, current.x];
			(open, numFound) = handleNeighbours(start, floodmap, open, numFound, current, upLoc, up);

			// left
			Location leftLoc = map[current.y, current.x-1];
			Node left = floodmap[current.y, current.x-1];
			(open, numFound) = handleNeighbours(start, floodmap, open, numFound, current, leftLoc, left);

			// right
			Location rightLoc = map[current.y, current.x+1];
			Node right = floodmap[current.y, current.x+1];
			(open, numFound) = handleNeighbours(start, floodmap, open, numFound, current, rightLoc, right);

			// down
			Location downLoc = map[current.y+1, current.x];
			Node down = floodmap[current.y+1, current.x];
			(open, numFound) = handleNeighbours(start, floodmap, open, numFound, current, downLoc, down);
		}

		return floodmap;
	}

	public static (bool, Location[,], bool) iteration(Location[,] map, bool strict = false)
	{
		List<Unit> playOrder = getPlayOrder(map);
		foreach (Unit u in playOrder)
		{
			// check if unit died this round
			if (u.hp <= 0)
			{
				continue;
			}

			(bool nextToOpponent, (int oX, int oY)) = isNextToOpponent(map, u);

			if (! nextToOpponent)
			{
				List<Unit> opponents = getOpponents(map, u.type);
				if (opponents.Count == 0) // combat end
				{
					return (true, map, false);
				}

				List<Location> adjacent = getAdjacent(map, opponents);
				if (adjacent.Count == 0)
				{
					continue;
				}

				// create floodmap
				Node[,] floodmap = getFloodMap(map, map[u.y, u.x]);

				// get best adjacent
				int shortestPath = Int32.MaxValue;
				Location goal = map[u.y, u.x];
				foreach (Location a in adjacent)
				{
					if (floodmap[a.y, a.x].value < shortestPath)
					{
						shortestPath = floodmap[a.y, a.x].value;
						goal = a;
					} else if (floodmap[a.y, a.x].value == shortestPath)
					{
						if (a.y < goal.y)
						{
							goal = a;
						} else if (a.y == goal.y)
						{
							if (a.x < goal.x)
							{
								goal = a;
							}
						}
					}
				}


				// get first step
				if (shortestPath < Int32.MaxValue)
				{
					// backtrack to first step
					Node n = floodmap[goal.y, goal.x];
					for (int s=0; s<shortestPath-1; s++)
					{
						n = n.prev!;
					}

					int firstStepX = n.x;
					int firstStepY = n.y;

					//todo move
					// update map new location
					map[firstStepY, firstStepX].unit = u;
					// update map old location
					map[u.y, u.x].unit = null;
					// update unit coords
					u.x = firstStepX;
					u.y = firstStepY;
				}
			}

			// attack if after move next to opponent
			(nextToOpponent, (oX, oY)) = isNextToOpponent(map, u);
			if (nextToOpponent)
			{
				Unit defender = map[oY, oX].unit!;

				defender.hp -= u.att;
				if (defender.hp <= 0)
				{
					map[oY, oX].unit = null;

					if (strict)
					{
						if (defender.type == UnitType.Elf)
						{
							return (false, map, true);
						}
					}
				}
			}
		}

		return (false, map, false);
	}

	public static int sumHP(Location[,] map)
	{
		int total = 0;

		for (int y=0; y<map.GetLength(0); y++)
		{
			for (int x=0; x<map.GetLength(1); x++)
			{
				Unit? alive = map[y, x].unit;
				if (alive != null)
				{
					total += alive.hp;
				}
			}
		}

		return total;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		var lines = File.ReadAllLines(filename);
		Location[,] map = new Location[lines.Length, lines[0].Length];
		bool combatEnd = false;
		int iterations = 0;

		for (int y=0; y<lines.Count(); y++)
		{
			for (int x=0; x<lines[y].Length; x++)
			{
				switch (lines[y][x])
				{
					case '#':
						map[y, x] = new Location(x, y, LocationType.Wall);
						break;
					case '.':
						map[y, x] = new Location(x, y, LocationType.Empty);
						break;
					case 'E':
						Unit elf = new Unit(x, y, UnitType.Elf);
						map[y, x] = new Location(x, y, LocationType.Empty, elf);
						break;
					case 'G':
						Unit goblin = new Unit(x, y, UnitType.Goblin);
						map[y, x] = new Location(x, y, LocationType.Empty, goblin);
						break;
					default:
						break;
				}
			}
		}

		while (!combatEnd)
		{
			(combatEnd, map, bool elfDied) = iteration(map);
			if (combatEnd)
			{
				break;
			}

			iterations++;
		}

        Console.WriteLine("AoC 15 take2 part1: {0}", iterations * sumHP(map));
		//todo quite slow. takes around 30 secconds to run

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		var lines = File.ReadAllLines(filename);
		Location[,] map = new Location[lines.Length, lines[0].Length];
		bool combatEnd = false;
		int iterations = 0;
		int att = 3;
		bool elvesWin = false;

		while (!elvesWin)
		{
			for (int y=0; y<lines.Count(); y++)
			{
				for (int x=0; x<lines[y].Length; x++)
				{
					switch (lines[y][x])
					{
						case '#':
							map[y, x] = new Location(x, y, LocationType.Wall);
							break;
						case '.':
							map[y, x] = new Location(x, y, LocationType.Empty);
							break;
						case 'E':
							Unit elf = new Unit(x, y, UnitType.Elf, att);
							map[y, x] = new Location(x, y, LocationType.Empty, elf);
							break;
						case 'G':
							Unit goblin = new Unit(x, y, UnitType.Goblin);
							map[y, x] = new Location(x, y, LocationType.Empty, goblin);
							break;
						default:
							break;
					}
				}
			}

			while (!combatEnd)
			{
				(combatEnd, map, bool elfDied) = iteration(map, true);
				if (elfDied)
				{
					att++;
					iterations = 0;
					break;
				}
				if (combatEnd)
				{
					elvesWin = true;
					break;
				}

				iterations++;
			}
		}

        Console.WriteLine("AoC 15 take2 part2: {0}", iterations * sumHP(map));
		//todo faster than part1 but still takes about 10 seconds to run

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
