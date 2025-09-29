namespace aoc_2018_take2;

class Step {
	public char id = '!'; //this is redundant
	public HashSet<char> before = new HashSet<char>();
	public int duration = 0;
}

class Worker {
	public char? step = null;
	public int countdown = 0;
}

class aoc_2018_07
{
    static string filename = "aoc_2018_07.txt";

	private static char findFirst(SortedDictionary<char,Step> steps) {
		foreach (var s in steps) {
			if (s.Value.before.Count == 0) {
				return s.Key;
			}
		}
		
		return '!';
	}
	
	private static SortedDictionary<char,Step> removeBefores(SortedDictionary<char,Step> steps, char before) {
		foreach (var s in steps) {
			s.Value.before.Remove(before);
		}

		return steps;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		var steps = new SortedDictionary<char,Step>();

        var lines = File.ReadAllLines(filename);
        foreach(var line in lines)
        {
			var lineArray = line.Split(' ');
			var before = Convert.ToChar(lineArray[1]);
			var step = Convert.ToChar(lineArray[7]);

			if (!steps.ContainsKey(step)) {
				steps[step] = new Step();
				steps[step].id = step;
				steps[step].before.Add(before);
			} else {
				steps[step].before.Add(before);
			}
			
			if (!steps.ContainsKey(before)) {
				steps[before] = new Step();
				steps[before].id = before;
			}
        }

		var res = "";

		while (steps.Count > 0) {
			var first = findFirst(steps);
			steps.Remove(first);
			res += Convert.ToString(first);
			steps = removeBefores(steps, first);
		}

        Console.WriteLine("AoC 07 part1: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		var baseDuration = 60;
		var numWorkers = 5;
		var steps = new SortedDictionary<char,Step>();

        var lines = File.ReadAllLines(filename);
        foreach(var line in lines)
        {
			var lineArray = line.Split(' ');
			var before = Convert.ToChar(lineArray[1]);
			var step = Convert.ToChar(lineArray[7]);

			if (!steps.ContainsKey(step)) {
				steps[step] = new Step();
				steps[step].id = step;
				steps[step].before.Add(before);
				steps[step].duration = baseDuration + (Convert.ToInt32(step)-64);
			} else {
				steps[step].before.Add(before);
			}
			
			if (!steps.ContainsKey(before)) {
				steps[before] = new Step();
				steps[before].id = before;
				steps[before].duration = baseDuration + (Convert.ToInt32(before)-64);
			}
        }

		//while steps.Count>0 or while any worker is working
		//put 4 elves to work untill all working or until findFirst returns !
		//	iterate over workers
		//	if working decrease the countdown
		//		if completed remove that step from dependencies of other steps and put elf back to work
		//	if not working try to put it to work (assign him a step and remove it from the steps)
		//eves have a step and countdown

		var counter = -1; // first second counts as 0
		var res = "";
		var numWorking = 0;
		var workers = new Worker[numWorkers];
		for (int i=0; i<numWorkers; i++) {
			workers[i] = new Worker();
		}

		while (steps.Count>0 || numWorking>0) {
			// one iter
			foreach (var w in workers) {
				if (w.step != null) { //working -> decrease countdown, check if finished
					w.countdown--;
					if (w.countdown == 0) { //completed
						res += Convert.ToString(w.step);
						steps = removeBefores(steps, Convert.ToChar(w.step));
						w.step = null;
						w.countdown = 0;
						numWorking--;
					}
				}
			}

			foreach (var w in workers) {
				if (w.step == null) { //not working -> put to work
					var first = findFirst(steps);
					if (first != '!') {
						w.step = first;
						w.countdown = steps[first].duration;
						numWorking++;
						steps.Remove(first);
					}
				}
			}

			counter++;
		}


        Console.WriteLine("AoC 07 part2: {0}", counter);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
