namespace aoc_2018_take2;

class LicenseNode {
	public List<LicenseNode> children = new List<LicenseNode>();
	public List<int> metadata = new List<int>();
}

class aoc_2018_08
{
    static string filename = "aoc_2018_08.txt";

	static String[]? array;
	static int index = 0;
	
	private static LicenseNode formNodes() {
		var node = new LicenseNode();

		if (array != null) {
			var numChildren = Convert.ToInt32(array[index]);
			index++;
			var numMetadata = Convert.ToInt32(array[index]);
			index++;

			if (numChildren > 0) {
				for (var i=0; i<numChildren; i++) {
					node.children.Add(formNodes());
				}
			}

			for (var i=0+index; i<numMetadata+index; i++) {
				node.metadata.Add(Convert.ToInt32(array[i]));
			}
			index += numMetadata;
		}

		return node;
	}

	private static int sumMetadata(LicenseNode node) {
		var sum = node.metadata.Sum();

		foreach (var c in node.children) {
			sum += sumMetadata(c);
		}

		return sum;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = File.ReadAllLines(filename)[0];
		array = line.Split(' ');

		var root = formNodes();
		var res = sumMetadata(root);

        Console.WriteLine("AoC 08 part1: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

	private static int sumValues(LicenseNode node) {
		if (node.children.Count == 0) {
			return node.metadata.Sum();
		}

		var sum = 0;

		foreach (var m in node.metadata) {
			//if child exists add child value to sum, else 0
			if (node.children.Count >= m) {
				sum += sumValues(node.children[m-1]);
			}
		}

		return sum;
	}


    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = File.ReadAllLines(filename)[0];
		array = line.Split(' ');

		index = 0;
		var root = formNodes();

		var res = sumValues(root);

        Console.WriteLine("AoC 08 part2: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
