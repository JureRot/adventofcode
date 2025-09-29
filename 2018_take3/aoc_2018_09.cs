namespace aoc_2018_take3;

class aoc_2018_09
{
	public class Marble
	{
		public int id;
		public Marble? prev;
		public Marble? next;

		public Marble(int id)
		{
			this.id = id;
		}
		
		private static Marble move(Marble curr, int position)
		{
			if (position>0)
			{
				for (int i=0; i<position; i++)
				{
					curr = curr.next!;
				}
			} else 
			{
				for (int i=0; i>position; i--)
				{
					curr = curr.prev!;
				}
			}

			return curr;
		}

		public static Marble insert(Marble curr, int position, int id)
		{
			curr = move(curr, position);

			Marble newMarble = new Marble(id);
			newMarble.next = curr.next;
			newMarble.prev = curr;

			curr.next!.prev = newMarble;
			curr.next = newMarble;

			return newMarble;
		}

		public static Tuple<Marble, int> pop(Marble curr, int position)
		{
			curr = move(curr, position);
			int currValue = curr.id;

			curr.next!.prev = curr.prev;
			curr.prev!.next = curr.next;

			return Tuple.Create(curr.next, currValue); // should return the value of the marble poped
		}
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var line = File.ReadAllLines(filename)[0];
		string[] parsed = line.Split(' ');
		int numPlayers = Int32.Parse(parsed[0]);
		int lastMarble = Int32.Parse(parsed[6]);
		int index = 0;
		Dictionary<int, int> players = new Dictionary<int, int>();
		Marble current = new Marble(index);
		current.prev = current;
		current.next = current;
		index++;

		while (index <= lastMarble)
		{
			if (index%23 == 0)
			{
				int value;
				(current, value) = Marble.pop(current, -7);
				int currPlayer = index % numPlayers;
				if (!players.ContainsKey(currPlayer))
				{
					players[currPlayer] = 0;
				}
				players[currPlayer] += value + index;

			} else {
				current = Marble.insert(current, 1, index);
			}
			index++;
		}

		int maxValue = 0;
		foreach (int v in players.Values)
		{
			if (v > maxValue)
			{
				maxValue = v;
			}
		}

        Console.WriteLine("AoC 09 part1: {0}", maxValue);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var line = File.ReadAllLines(filename)[0];
		string[] parsed = line.Split(' ');
		int numPlayers = Int32.Parse(parsed[0]);
		int lastMarble = Int32.Parse(parsed[6]) * 100;
		int index = 0;
		Dictionary<int, double> players = new Dictionary<int, double>(); // needs to be double
		Marble current = new Marble(index);
		current.prev = current;
		current.next = current;
		index++;

		while (index <= lastMarble)
		{
			if (index%23 == 0)
			{
				int value;
				(current, value) = Marble.pop(current, -7);
				int currPlayer = index % numPlayers;
				if (!players.ContainsKey(currPlayer))
				{
					players[currPlayer] = 0;
				}
				players[currPlayer] += value + index;

			} else {
				current = Marble.insert(current, 1, index);
			}
			index++;
		}

		double maxValue = 0;
		foreach (double v in players.Values)
		{
			if (v > maxValue)
			{
				maxValue = v;
			}
		}

        Console.WriteLine("AoC 09 part2: {0}", maxValue);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
