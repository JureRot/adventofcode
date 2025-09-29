namespace aoc_2018_take3;

class aoc_2018_07
{
	public enum State
	{
		waiting,
		inProgress,
		done
	}

	public class Step
	{
		public string id = "";
		public int time;
		public State state = State.waiting;
		public HashSet<string> pre = new HashSet<string>();
		public HashSet<string> post = new HashSet<string>();

		public Step(string id)
		{
			this.id = id;
			this.time = 60 + ((int)char.Parse(id) - 64);
		}
	}

	public static string iterate(SortedDictionary<string, Step> steps)
	{
		string seq = "";

		while (steps.Count > 0)
		{
			// get the first that has no pre
			string next = "";
			foreach (Step s in steps.Values)
			{
				if (s.pre.Count == 0)
				{
					next = s.id;
					break;
				}
			}

			seq += next;

			// remove it from all otherses pre and than remove it itself
			foreach (Step s in steps.Values)
			{
				if (s.pre.Contains(next))
				{
					s.pre.Remove(next);
				}
			}

			steps.Remove(next);
		}

		return seq;
	}

	public static int iterateParallel(SortedDictionary<string, Step> steps, string[] workers)
	{
		int iteration = 0;
		string seq = "";

		while (steps.Count > 0)
		{
			// decrease time for all tasks
			foreach (Step s in steps.Values)
			{
				if (s.state == State.inProgress)
				{
					s.time--;
				}
			}

			// check if any worker finished
			for (int i=0; i<workers.Length; i++)
			{
				string w = workers[i];

				if (!string.IsNullOrEmpty(w) && steps[w].time==0) //task finished
				{
					seq += w;
					foreach (Step s in steps.Values)
					{
						if (s.pre.Contains(w))
						{
							s.pre.Remove(w);
						}
					}
					steps[w].state = State.done;
					steps.Remove(w);

					workers[i] = "";
				}
			}

			// delegate tasks
			for (int i=0; i<workers.Length; i++)
			{
				string w = workers[i];

				if (string.IsNullOrEmpty(w)) {
					// get the first that has no pre
					string next = "";
					foreach (Step s in steps.Values)
					{
						if (s.state==State.waiting && s.pre.Count == 0)
						{
							next = s.id;
							break;
						}
					}

					if (!string.IsNullOrEmpty(next))
					{
						steps[next].state = State.inProgress;
						workers[i] = next;
					}
				}
			}

			iteration++;
		}

		return iteration;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		SortedDictionary<string, Step> steps = new SortedDictionary<string, Step>();

		foreach (var line in lines)
		{
			string[] parsed = line.Split(' ');
			string pre = parsed[1];
			string post = parsed[7];

			if (!steps.ContainsKey(pre))
			{
				steps.Add(pre, new Step(pre));
			}
			if (!steps.ContainsKey(post))
			{
				steps.Add(post, new Step(post));
			}

			steps[pre].post.Add(post);
			steps[post].pre.Add(pre);
		}

		string sequence = iterate(steps);

        Console.WriteLine("AoC 07 part1: {0}", sequence);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadLines(filename);
		SortedDictionary<string, Step> steps = new SortedDictionary<string, Step>();
		int numWorkers = 5;
		string[] workers = new string[numWorkers];

		foreach (var line in lines)
		{
			string[] parsed = line.Split(' ');
			string pre = parsed[1];
			string post = parsed[7];

			if (!steps.ContainsKey(pre))
			{
				steps.Add(pre, new Step(pre));
			}
			if (!steps.ContainsKey(post))
			{
				steps.Add(post, new Step(post));
			}

			steps[pre].post.Add(post);
			steps[post].pre.Add(pre);
		}

		int iterations = iterateParallel(steps, workers);

        Console.WriteLine("AoC 07 part1: {0}", iterations-1);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
