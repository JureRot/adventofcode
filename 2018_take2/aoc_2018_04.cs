namespace aoc_2018_take2;

class aoc_2018_04
{
    static string filename = "aoc_2018_04.txt";

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        Dictionary<int, int[]> guards = new Dictionary<int, int[]>();

        var lastGuard = 0;
        var sleep = 0;
        var wake = 0;


        var lines = File.ReadAllLines(filename);
        Array.Sort(lines);
        foreach(var line in lines)
        {
            var lineArray = line.Split(' ');
            switch (lineArray[2]) {
                case "Guard":
                    lastGuard = Convert.ToInt32(lineArray[3].Replace("#", ""));
                    sleep = 0;
                    wake = 0;
                    break;
                case "falls":
                    sleep = Convert.ToInt32(lineArray[1].Replace("]", "").Split(":")[1]);
                    wake = 0;
                    break;
                case "wakes":
                    wake = Convert.ToInt32(lineArray[1].Replace("]", "").Split(":")[1]);

                    if (!guards.ContainsKey(lastGuard)) {
                        guards[lastGuard] = new int[60];
                    }

                    for (int i=sleep; i<wake; i++) {
                        guards[lastGuard][i]++;
                    }
                    break;
            }
        }

        var maxSum = 0;
        var maxGuard = 0;
        var maxMinute = 0;

        foreach (var g in guards) {
            if (g.Value.Sum() > maxSum) {
                maxSum = g.Value.Sum();
                maxGuard = g.Key;
                var maxValue = g.Value.Max();
                maxMinute = g.Value.ToList().IndexOf(maxValue);
            }
        }

        Console.WriteLine("AoC 04 part1: {0}", maxGuard * maxMinute);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        Dictionary<int, int[]> guards = new Dictionary<int, int[]>();

        var lastGuard = 0;
        var sleep = 0;
        var wake = 0;


        var lines = File.ReadAllLines(filename);
        Array.Sort(lines);
        foreach(var line in lines)
        {
            var lineArray = line.Split(' ');
            switch (lineArray[2]) {
                case "Guard":
                    lastGuard = Convert.ToInt32(lineArray[3].Replace("#", ""));
                    sleep = 0;
                    wake = 0;
                    break;
                case "falls":
                    sleep = Convert.ToInt32(lineArray[1].Replace("]", "").Split(":")[1]);
                    wake = 0;
                    break;
                case "wakes":
                    wake = Convert.ToInt32(lineArray[1].Replace("]", "").Split(":")[1]);
                    //add to guard
                    if (!guards.ContainsKey(lastGuard)) {
                        guards[lastGuard] = new int[60];
                    }

                    for (int i=sleep; i<wake; i++) {
                        guards[lastGuard][i]++;
                    }
                    break;
            }
        }

        var maxCount = 0;
        var maxGuard = 0;
        var maxMinute = 0;

        foreach (var g in guards) {
            if (g.Value.Max() > maxCount) {
                maxCount = g.Value.Max();
                maxGuard = g.Key;
                maxMinute = g.Value.ToList().IndexOf(maxCount);
            }
        }

        Console.WriteLine("AoC 04 part2: {0}", maxGuard * maxMinute);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
