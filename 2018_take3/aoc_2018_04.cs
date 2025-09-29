namespace aoc_2018_take3;

class aoc_2018_04
{
	// UNUSED BECAUSE REGULAR SORT DOES IT CORRECTLY
	/*
	static int lineCompare(string s1, string s2)
	{

		s1 = s1.Split(new Char[]{'[', ']'})[1];
		string[] time1 = s1.Split(new Char[]{' ', ':'}); // day, hour, minute
		s2 = s2.Split(new Char[]{'[', ']'})[1];
		string[] time2 = s2.Split(new Char[]{' ', ':'});

		int dayCompare = String.Compare(time1[0], time2[0]);
		if (dayCompare == 0)
		{
			int hourCompare = String.Compare(time1[1], time2[1]);
			if (hourCompare == 0)
			{
				return String.Compare(time1[2], time2[2]); // minutes different (return normal minute compare)
			} else // hours different (return opposite hour compare (since 23:00 before 00:00))
			{
				return -1 * hourCompare;
			}

		} else  // days different (return normal day compare)
		{
			return dayCompare;
		}
	}
	*/

	public enum State
	{
		awake,
		sleep,
		guard
	}

	public class Action
	{
		public int guardId;
		public State action;
		public int minute;

		public Action(int id, State action, int minute)
		{
			this.guardId = id;
			this.action = action;
			this.minute = minute;
		}
		public Action(State action, int minute)
		{
			this.guardId = -1;
			this.action = action;
			this.minute = minute;
		}
	}

	public static Action parseLine(string line)
	{
		string[] splitLine = line.Split(' ');

		string minString = splitLine[1].Split(':')[1];
		int minute = Int32.Parse(minString.Substring(0, minString.Length-1));

		if (splitLine[2] == "Guard") // new guard
		{
			return new Action(Int32.Parse(splitLine[3].Substring(1)), State.guard, minute);
		} else if (splitLine[2] == "falls") // falls asleep
		{
			return new Action(State.sleep, minute);
		} else // wakes up
		{
			return new Action(State.awake, minute);
		}
	}

	public static Dictionary<int, int[]> createTimesheet(string[] lines) {
		Dictionary<int, int[]> timesheet = new Dictionary<int, int[]>();
		int currGuard = 0;
		int sleepStart = -1;

		foreach (string line in lines)
		{
			Action action = parseLine(line);

			if (action.action == State.guard) // new guard
			{
				if (!timesheet.Keys.Contains(action.guardId))
				{
					timesheet.Add(action.guardId, new int[60]);
				}
				currGuard = action.guardId;
			} else if (action.action == State.sleep) // falls asleep
			{
				sleepStart = action.minute;

			} else if (action.action == State.awake) // wakes up
			{
				for(int i=sleepStart; i<action.minute; i++)
				{
					timesheet[currGuard][i] += 1;
				}
				sleepStart = -1;
			}
		}

		return timesheet;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);

		// sort input
		Array.Sort(lines);
		//Array.Sort(lines, lineCompare); // if we would use custom sorter

		// create data structure
		Dictionary<int, int[]> timesheet = createTimesheet(lines);

		// get guard that sleeps the most and its most common sleep minute
		int guardId = -1;
		int mostVolume = 0;
		int mostCommonMinute = -1;

		foreach (int k in timesheet.Keys)
		{
			int volume = timesheet[k].Sum();
			
			if (volume > mostVolume)
			{
				guardId = k;
				mostVolume = volume;

				int commonValue = 0;
				int commonMinute = -1;
				for(int m=0; m<timesheet[k].Length; m++)
				{
					if (timesheet[k][m] > commonValue)
					{
						commonValue = timesheet[k][m];
						commonMinute = m;
					}
				}

				mostCommonMinute = commonMinute;
			}
		}

        Console.WriteLine("AoC 04 part1: {0}", guardId * mostCommonMinute);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);

		// sort input
		Array.Sort(lines);

		// create data structure
		Dictionary<int, int[]> timesheet = createTimesheet(lines);

		// get guard that sleeps the same minute the most
		int guardId = -1;
		int mostCommonValue = 0;
		int mostCommonMinute = 0;

		foreach (int k in timesheet.Keys)
		{
			int commonValue = 0;
			int commonMinute = -1;
			for(int m=0; m<timesheet[k].Length; m++)
			{
				if (timesheet[k][m] > commonValue)
				{
					commonValue = timesheet[k][m];
					commonMinute = m;
				}
			}

			if (commonValue > mostCommonValue)
			{
				mostCommonValue = commonValue;
				mostCommonMinute = commonMinute;
				guardId = k;
			}
		}

        Console.WriteLine("AoC 04 part2: {0}", guardId * mostCommonMinute);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
