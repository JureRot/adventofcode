namespace aoc_2018_take2;

class aoc_2018_01
{
    static string filename = "aoc_2018_01.txt";

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
        var frequency = 0;

        var lines = File.ReadLines(filename);
        foreach(var line in lines)
        {
            var op = line[0];
            var value = Int32.Parse(line[1..]);

            if (op == '+')
            {
                frequency += value;
            }
            else if (op == '-')
            {
                frequency -= value;
            }
        }

        Console.WriteLine("AoC 01 part1: {0}", frequency);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }


    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
        var frequency = 0;
        HashSet<int> seen = new HashSet<int>();
        var notSeen = true;

        var lines = File.ReadLines(filename);
        while (notSeen) {
            foreach(var line in lines)
            {
                var op = line[0];
                var value = Int32.Parse(line[1..]);

                if (op == '+')
                {
                    frequency += value;
                }
                else if (op == '-')
                {
                    frequency -= value;
                }

                if (seen.Count == 0 || !seen.Contains(frequency))
                {
                    seen.Add(frequency);
                } else {
                    Console.WriteLine("AoC 01 part2: {0}", frequency);
                    notSeen = false;
                    break;
                }
            }
        }

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
