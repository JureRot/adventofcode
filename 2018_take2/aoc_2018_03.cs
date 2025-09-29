namespace aoc_2018_take2;

class ArrayInts {
    public int[,] array;
    public HashSet<int> ids;

    public ArrayInts(int[,] array, HashSet<int> ids) {
        this.array = array;
        this.ids = ids;
    }
}

class aoc_2018_03
{
    static string filename = "aoc_2018_03.txt";

    private static int[,] mark(int[,] array, int x, int y, int w, int h) {
        for (int j=y; j<y+h; j++) {
            for (int i=x; i<x+w; i++) {
                array[j, i]++;
            }
        }

        return array;
    }

    private static int countOverlap(int[,] array) {
        var overlap = 0;
        for (int j=0; j<array.GetLength(0); j++) {
            for (int i=0; i<array.GetLength(1); i++) {
                if (array[j, i] >= 2) {
                    overlap++;
                }
            }
        }
        
        return overlap;
    }

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
        int[,] fabric = new int[2000, 2000];

        var lines = File.ReadLines(filename);
        foreach(var line in lines)
        {
            var lineArray = line.Split(' ');

            var id = lineArray[0][1..];
            var loc = lineArray[2].Replace(":", "").Split(',');
            var x = loc[0];
            var y = loc[1];
            var dim = lineArray[3].Split('x');
            var w = dim[0];
            var h = dim[1];
            fabric = mark(fabric, Convert.ToInt32(x), Convert.ToInt32(y), Convert.ToInt32(w), Convert.ToInt32(h));
        }

        var res = countOverlap(fabric);

        Console.WriteLine("AoC 03 part1: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    private static ArrayInts mark2(int[,] array, int id, int x, int y, int w, int h) {
        HashSet<int> ids = new HashSet<int>();
        for (int j=y; j<y+h; j++) {
            for (int i=x; i<x+w; i++) {
                if (array[j, i] != 0) {
                    ids.Add(array[j, i]);
                }
                array[j, i] = id;
            }
        }

        ArrayInts ret = new ArrayInts(array, ids);
        return ret;
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
        int[,] fabric = new int[2000, 2000];
        HashSet<int> unoverlapped = new HashSet<int>();

        var lines = File.ReadLines(filename);
        foreach(var line in lines)
        {
            var lineArray = line.Split(' ');

            var id = lineArray[0][1..];
            var loc = lineArray[2].Replace(":", "").Split(',');
            var x = loc[0];
            var y = loc[1];
            var dim = lineArray[3].Split('x');
            var w = dim[0];
            var h = dim[1];
            unoverlapped.Add(Convert.ToInt32(id));
            ArrayInts bla = mark2(fabric, Convert.ToInt32(id), Convert.ToInt32(x), Convert.ToInt32(y), Convert.ToInt32(w), Convert.ToInt32(h));
            fabric = bla.array;

            if (bla.ids.Count > 0) {
                foreach (var i in bla.ids) {
                    unoverlapped.Remove(i);
                }

                unoverlapped.Remove(Convert.ToInt32(id));
            }
        }

        if (unoverlapped.Count == 1) {
            Console.WriteLine("AoC 03 part2: {0}", unoverlapped.First());
        }


        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
