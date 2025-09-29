namespace aoc_2018_take3;

class aoc_2018_13
{
	public enum Road
	{
		Empty,
		TopBottom,
		LeftRight,
		TopLeft_BottomRight,
		TopRight_BottomLeft,
		Intersection,
	}
	public enum CartDirection
	{
		Up,
		Down,
		Left,
		Right,
	}

	public enum CartTurn
	{
		Left,
		Straight,
		Right,
	}

	public class Cart
	{
		public CartDirection direction;
		public CartTurn nextTurn = CartTurn.Left;
		public bool moved = false;

		public Cart(CartDirection direction)
		{
			this.direction = direction;
		}

		public void updateNextTurn()
		{
			this.nextTurn = this.nextTurn switch
			{
				CartTurn.Left => CartTurn.Straight,
				CartTurn.Straight => CartTurn.Right,
				CartTurn.Right => CartTurn.Left,
				_ => CartTurn.Left, // should not happen
			};
		}
	}

	public class Location
	{
		public Road road;
		public List<Cart> carts = new List<Cart>();

		public Location(char c)
		{
			switch (c)
			{
				case '^':
					this.carts.Add(new Cart(CartDirection.Up));
					c = '|';
					break;
				case 'v':
					this.carts.Add(new Cart(CartDirection.Down));
					c = '|';
					break;
				case '<':
					this.carts.Add(new Cart(CartDirection.Left));
					c = '-';
					break;
				case '>':
					this.carts.Add(new Cart(CartDirection.Right));
					c = '-';
					break;
			}

			switch (c)
			{
				case '|':
					this.road = Road.TopBottom;
					break;
				case '-':
					this.road = Road.LeftRight;
					break;
				case '/':
					this.road = Road.TopLeft_BottomRight;
					break;
				case '\\':
					this.road = Road.TopRight_BottomLeft;
					break;
				case '+':
					this.road = Road.Intersection;
					break;
				default:
					this.road = Road.Empty;
					break;
			}
		}
	}

	public static CartDirection cartChangeDirection(CartDirection direction, Road turn)
	{
		CartDirection newDirection = direction;

		if (turn == Road.TopLeft_BottomRight)
		{
			// using switch expression instead of switch statement
			newDirection = direction switch
			{
				CartDirection.Up => CartDirection.Right,
				CartDirection.Down => CartDirection.Left,
				CartDirection.Left => CartDirection.Down,
				CartDirection.Right => CartDirection.Up,
				_ => direction, // should not happen
			};
		} else if (turn == Road.TopRight_BottomLeft)
		{
			newDirection = direction switch
			{
				CartDirection.Up => CartDirection.Left,
				CartDirection.Down => CartDirection.Right,
				CartDirection.Left => CartDirection.Up,
				CartDirection.Right => CartDirection.Down,
				_ => direction, // should not happen
			};
		}

		return newDirection;
	}

	public static CartDirection cartTurn(CartDirection direction, CartTurn turn)
	{
		CartDirection newDirection = direction;

		if (turn == CartTurn.Left)
		{
			newDirection = direction switch
			{
				CartDirection.Up => CartDirection.Left,
				CartDirection.Down => CartDirection.Right,
				CartDirection.Left => CartDirection.Down,
				CartDirection.Right => CartDirection.Up,
				_ => direction,
			};

		} else if (turn == CartTurn.Right)
		{
			newDirection = direction switch
			{
				CartDirection.Up => CartDirection.Right,
				CartDirection.Down => CartDirection.Left,
				CartDirection.Left => CartDirection.Up,
				CartDirection.Right => CartDirection.Down,
				_ => direction,
			};
		} else if (turn == CartTurn.Straight)
		{
			newDirection = direction;
		}

		return newDirection;
	}

	public static (int, int, int) iteration(Dictionary<int, Dictionary<int, Location>> map)
	{
		int collisions = 0;
		int collisionX = -1;
		int collisionY = -1;
		List<int[]> newCartLocations = new List<int[]>();

		foreach (int y in map.Keys)
		{
			foreach (int x in map[y].Keys)
			{
				if (map[y][x].carts.Count > 0)
				{
					Cart cart = map[y][x].carts.First();

					if (cart.moved) // break if this cart already moved
					{
						continue;
					}

					int newX = -1;
					int newY = -1;

					switch (cart.direction)
					{
						case CartDirection.Up:
							newX = x;
							newY = y - 1;
							break;
						case CartDirection.Down:
							newX = x;
							newY = y + 1;
							break;
						case CartDirection.Left:
							newX = x - 1;
							newY = y;
							break;
						case CartDirection.Right:
							newX = x + 1;
							newY = y;
							break;
					}

					map[y][x].carts.Remove(cart);
					map[newY][newX].carts.Add(cart);
					map[newY][newX].carts.First().moved = true;
					newCartLocations.Add(new int[]{newX, newY}); // so we dont move same cart multiple times within the iteration

					if (map[newY][newX].carts.Count > 1) // collision
					{
						if (collisions <= 0)
						{
							collisionX = newX;
							collisionY = newY;
						}
						collisions += 2;
						//return (collisions, newX, newY);
						map[newY][newX].carts.Clear();
						//instead of returning we just remove carts and continue to the end of iteration
						continue;
					}

					Road[] turns = {Road.TopLeft_BottomRight, Road.TopRight_BottomLeft};
					if (turns.Contains(map[newY][newX].road)) // turn
					{
						CartDirection newCartDirection = cartChangeDirection(map[newY][newX].carts.First().direction, map[newY][newX].road);
						map[newY][newX].carts.First().direction = newCartDirection;
					}

					if (map[newY][newX].road == Road.Intersection) // intersection
					{

						CartDirection newCartDirection = cartTurn(map[newY][newX].carts.First().direction, map[newY][newX].carts.First().nextTurn);
						map[newY][newX].carts.First().direction = newCartDirection;
						map[newY][newX].carts.First().updateNextTurn();
					}
				}
			}
		}

		// reset cart moved flag
		foreach (int[] cartLocation in newCartLocations)
		{

			List<Cart> locationCarts = map[cartLocation[1]][cartLocation[0]].carts;
			if (locationCarts.Count > 0) // need to check because we dont remove them in case of collision
			{
				map[cartLocation[1]][cartLocation[0]].carts.First().moved = false;
			}
		}

		return (collisions, collisionX, collisionY);
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		Dictionary<int, Dictionary<int, Location>> map = new Dictionary<int, Dictionary<int, Location>>();
		int collisions = 0;
		int collisionX = -1;
		int collisionY = -1;

		for (int y=0; y<lines.Length; y++)
		{
			string line = lines[y];

			map.Add(y, new Dictionary<int, Location>());

			for (int x=0; x<line.Length; x++)
			{
				map[y].Add(x, new Location(line[x]));
			}
		}

		while (collisions <= 0)
		{
			(collisions, collisionX, collisionY) = iteration(map);

			if (collisions > 0)
			{
				break;
			}
		}

        Console.WriteLine("AoC 13 part1: {0},{1}", collisionX, collisionY);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

	public static void part2(string filename)
	{
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		Dictionary<int, Dictionary<int, Location>> map = new Dictionary<int, Dictionary<int, Location>>();
		int numCarts = 0;
		int collisions = 0;
		int lastCartX = -1;
		int lastCartY = -1;

		for (int y=0; y<lines.Length; y++)
		{
			string line = lines[y];

			map.Add(y, new Dictionary<int, Location>());

			for (int x=0; x<line.Length; x++)
			{
				map[y].Add(x, new Location(line[x]));

				Char[] cartChars = {'^', 'v', '<', '>'};
				if (cartChars.Contains(line[x]))
				{
					numCarts++;
				}
			}
		}

		while (collisions < (numCarts - 1))
		{
			(int newCollisions, int collisionX, int collisionY) = iteration(map);
			collisions += newCollisions;
		}

		// find the last cart
		foreach (int y in map.Keys)
		{
			foreach (int x in map[y].Keys)
			{
				if (map[y][x].carts.Count > 0)
				{
					lastCartX = x;
					lastCartY = y;
				}
			}
		}

        Console.WriteLine("AoC 13 part2: {0},{1}", lastCartX, lastCartY);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);

	}
}
