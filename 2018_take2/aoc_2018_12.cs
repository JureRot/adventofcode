namespace aoc_2018_take2;

class aoc_2018_12
{
    static string filename = "aoc_2018_12.txt";

	private static String iter (String state, HashSet<int> patterns) {
		// add one pot to front and back
		state = "000" + state + "000";
		var newState = new String('0', state.Length).ToCharArray();

		for (var i=2; i<state.Length-2; i++) {
			var start = i-2;
			var end = i+3; // end is the first character that is not in the substring
			if (patterns.Contains(Convert.ToInt32(state[start..end], 2))) {
				newState[i] = '1';
			}
		}
		return new String(newState);
	}

	private static int sumPots (String state, int offset) {
		var sum = 0;

		for (int i=0; i<state.Length; i++) {
			if (state[i] == '1') {
				sum += i-offset;
			}
		}
		
		return sum;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);
		var state = lines[0].Split(": ")[1];
		var offset = 0;

		// we assume 0 is not in patterns
		// because we use bit logic so if there was ..... => # pattern the infinite thing would swap to potted

		state = state.Replace('#', '1').Replace('.', '0');

		var patterns = new HashSet<int>();

		for (var l=2; l<lines.Count(); l++) {
			var lineArray = lines[l].Split(" => ");
			if (lineArray[1] == "#") {
				var pattern = lineArray[0].Replace('#', '1').Replace('.', '0');
				patterns.Add(Convert.ToInt32(pattern, 2));
			}
		}

		for (var i=0; i<20; i++) {
			state = iter(state, patterns);
			offset += 3;
		}

		var res = sumPots(state, offset);

		Console.WriteLine("AoC 12 part1: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);
		var state = lines[0].Split(": ")[1];
		var offset = 0;

		state = state.Replace('#', '1').Replace('.', '0');

		var patterns = new HashSet<int>();

		for (var l=2; l<lines.Count(); l++) {
			var lineArray = lines[l].Split(" => ");
			if (lineArray[1] == "#") {
				var pattern = lineArray[0].Replace('#', '1').Replace('.', '0');
				patterns.Add(Convert.ToInt32(pattern, 2));
			}
		}

		// growth becomes linear after some hundred iterations

		for (var i=0; i<199; i++) {
			state = iter(state, patterns);
			offset += 3;
		}

		var oldRes = sumPots(state, offset);
		state = iter(state, patterns);
		offset += 3;
		var newRes =  sumPots(state, offset);
		var linear = newRes - oldRes;


		var res = newRes + (linear * (50000000000 - 200));

		Console.WriteLine("AoC 12 part2: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
