namespace aoc_2018_take2;

class aoc_2018_02
{
    static string filename = "aoc_2018_02.txt";

    private static bool[] getTwiceThrice(string array) {
        var twiceFound = false;
        var thriceFound = false;
        var curr = '!';
        var count = 0;

        for (int i=0; i<array.Length; i++) {
            if (curr == '!') {
                curr = array[i];
                count = 1;
            } else if (curr == array[i]) {
                count++;
            } else {
                if (!twiceFound && count==2) {
                    twiceFound = true;
                }
                if (!thriceFound && count==3) {
                    thriceFound = true;
                }

                if (twiceFound && thriceFound) {
                    return [twiceFound, thriceFound];
                }

                curr = array[i];
                count = 1;
            }
        }

        if (!twiceFound && count==2) {
            twiceFound = true;
        }
        if (!thriceFound && count==3) {
            thriceFound = true;
        }

        return [twiceFound, thriceFound];
    }

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var twice = 0;
        var thrice = 0;

        var lines = File.ReadLines(filename);
        foreach(var line in lines)
        {
            var lineArray = line.ToCharArray();
            Array.Sort(lineArray);
            var res = getTwiceThrice(String.Join("", lineArray));
            twice += res[0] ? 1 : 0;
            thrice += res[1] ? 1 : 0;
        }

        Console.WriteLine("AoC 02 part1: {0}", twice * thrice);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    private static int levensteinDistance(string a, string b) {
        if (a.Length != b.Length) {
            return -1;
        }

        var distance = 0;

        for (int i=0; i<a.Length; i++)
        {
            if (a[i] != b[i]) {
                distance++;
            }
        }

        return distance;
    }

    private static string difference(string a, string b) {
        List<char> same = new List<char>();

        for (int i=0; i<a.Length; i++)
        {
            if (a[i] == b[i]) {
                same.Add(a[i]);
            }
        }

        return String.Join("", same);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);
        for (int i=0; i<lines.Length; i++)
        {
            for (int j=i+1; j<lines.Length; j++)
            {
                var res = levensteinDistance(lines[i], lines[j]);
                if (res == 1) {
                    var match = difference(lines[i], lines[j]);
                    Console.WriteLine("AoC 02 part2: {0}", match);
                    goto ENDLOOPS;
                }
            }
        }
        
        ENDLOOPS:

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
