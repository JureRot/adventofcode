namespace aoc_2018_take3;

class aoc_2018_08
{
	public class Node
	{
		public static Dictionary<int, Node> nodes = new Dictionary<int, Node>();
		//public List<Node> children = new List<Node>();
		public List<int> children = new List<int>();
		//public int id;
		public List<int> metadata = new List<int>();
	}

	public static int parseNodes(int[] seq, int i)
	{
		int currI = i;
		Node.nodes.Add(currI, new Node());

		int numChildren = seq[i];
		i++;
		int numMetadata = seq[i];
		i++;

		for (int c=0; c<numChildren; c++)
		{
			Node.nodes[currI].children.Add(i);
			i = parseNodes(seq, i);
		}

		for (int m=0; m<numMetadata; m++)
		{
			Node.nodes[currI].metadata.Add(seq[i]);
			i++;
		}

		return i;
	}

	public static int getValue(int i){
		Node node = Node.nodes[i];
		int value = 0;

		if (node.children.Count == 0) 
		{
			return node.metadata.Sum();
		}

		node.children.Sort(); //todo maybe not needed

		foreach (int m in node.metadata)
		{
			if (m!=0 && m<=node.children.Count){
				int child = node.children[m-1];
				value += getValue(child);
			}
		}

		return value;
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int[] sequence = lines[0].Split(' ').Select(s => Int32.Parse(s)).ToArray();
		int index = 0;
		int metadataSum = 0;

		parseNodes(sequence, index);

		foreach (int k in Node.nodes.Keys)
		{
			metadataSum += Node.nodes[k].metadata.Sum();
		}

        Console.WriteLine("AoC 08 part1: {0}", metadataSum);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var lines = File.ReadAllLines(filename);
		int[] sequence = lines[0].Split(' ').Select(s => Int32.Parse(s)).ToArray();

		// reuse previously constructed
		/*
		int index = 0;
		Node.nodes.Clear();
		parseNodes(sequence, index);
		*/

		int valueSum = getValue(0);

        Console.WriteLine("AoC 08 part2: {0}", valueSum);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
