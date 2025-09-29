namespace aoc_2018_take2;

class aoc_2018_05
{
    static string filename = "aoc_2018_05.txt";

    private static string collapse(string chain) {
        var prevChar = '!';

        for (int i=0; i<chain.Length; i++) {
            if (prevChar == '!') {
                prevChar = chain[i];
                continue;
            }

            var currCharShift = chain[i];

            if (Char.IsLower(chain[i])) {
                currCharShift = Char.ToUpper(chain[i]);
            } else if (Char.IsUpper(chain[i])) {
                currCharShift = Char.ToLower(chain[i]);
            }

            if (prevChar == currCharShift) {
                var start = i-1;
                var end = i+1;
                chain = chain[0..start] + chain[end..];
                i -= 2;
            }

            prevChar = chain[Math.Max(i, 0)];
        }

        return chain;
    }

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = File.ReadAllLines(filename)[0];

        line = collapse(line);
        
        Console.WriteLine("AoC 05 part1: {0}", line.Length);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line_og = File.ReadAllLines(filename)[0];
        List<char> alphabeth = new List<char>();

        for (int i=97; i<123; i++) {
            alphabeth.Add(Convert.ToChar(i));
        }

        var minLen = line_og.Length;
        var minChar = 'a';

        foreach (var l in alphabeth) {
            var line = line_og;
            line = line.Replace(Convert.ToString(l), "");
            line = line.Replace(Convert.ToString(Char.ToUpper(l)), "");

            line = collapse(line);

            if (line.Length < minLen) {
                minLen = line.Length;
                minChar = l;
            }
        }

        Console.WriteLine("AoC 05 part2: {0}", minLen);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
