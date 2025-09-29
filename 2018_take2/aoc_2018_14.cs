namespace aoc_2018_take2;

class aoc_2018_14
{
    static string filename = "aoc_2018_14.txt";

	static List<int> recipies = new List<int>();

	private static int[] iteration (int[] workers) {
		//create new recipies
		//sum workers, for each digit create new recipie
		var sum = 0;
		foreach (var w in workers) {
			sum += recipies[w];
		}

		var newRecipies = Convert.ToString(sum);
		foreach (var r in newRecipies) {
			recipies.Add(Convert.ToInt32(Char.GetNumericValue(r)));
		}

		//move workers
		var newWorkers = new int[workers.Length];
		for (var i=0; i<workers.Length; i++) {
			newWorkers[i] = (workers[i] + (recipies[workers[i]] + 1)) % recipies.Count();
		}

		return newWorkers;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = Convert.ToInt32(File.ReadAllLines(filename)[0]);

		recipies.Add(3);
		recipies.Add(7);

		var workers = new int[]{0, 1};

		int[] newWorkers;
		while (recipies.Count <= line + 10) {
			newWorkers = iteration(workers);
			for (int i=0; i<newWorkers.Length; i++) {
				workers[i] = newWorkers[i];
			}
		}

		Console.WriteLine("AoC 14 part1: {0}", String.Join("", recipies.GetRange(line, 10)));

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = Convert.ToInt32(File.ReadAllLines(filename)[0]);

		recipies.Clear();

		recipies.Add(3);
		recipies.Add(7);

		var workers = new int[]{0, 1};

		var count = 0;

		int[] newWorkers;
		//while (String.Join("", recipies).IndexOf(Convert.ToString(line)) == -1) {
		// this is very slow to check every loop, so we just go to a huge number and than check once
		while (recipies.Count < 50000000) {
			newWorkers = iteration(workers);
			for (int i=0; i<newWorkers.Length; i++) {
				workers[i] = newWorkers[i];
			}
			count++;
		}

		Console.WriteLine("AoC 14 part2: {0}", String.Join("", recipies).IndexOf(Convert.ToString(line)));

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
