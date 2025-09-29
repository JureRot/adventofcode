namespace aoc_2018_take3;

class aoc_2018_14
{
	public class Recipie
	{
		public int id;
		public Recipie next;
		public Recipie prev;

		public Recipie(int id)
		{
			this.id = id;
			this.next = this;
			this.prev = this;
		}

		public Recipie addAfter(Recipie element)
		{
			Recipie next = this.next;
			this.next = element;
			next.prev = element;
			element.next = next;
			element.prev = this;

			return element;
		}

		public Recipie moveNext(int n)
		{
			Recipie element = this;
			for (int i=0; i<n; i++)
			{
				element = element.next;
			}

			return element;
		}
	}

	public static bool checkTail(Recipie tail, string input)
	{
		string tailString = tail.id.ToString();

		while (tailString.Length < input.Length)
		{
			tail = tail.prev;
			tailString = tail.id.ToString() + tailString;
		}

		if (tailString.Equals(input))
		{
			return true;
		}

		return false;
	}

	public static (Recipie[], Recipie, int, bool) iteration(Recipie[] elves, Recipie tail, string? tailString = null)
	{
		int numRecipies = 0;

		// create new recipies
		int[] newRecipies = (elves[0].id + elves[1].id).ToString().ToCharArray().Select(c => c.ToString()).ToArray().Select(s => Convert.ToInt32(s)).ToArray();
		// sums both current recepies
		// splits them to digits by converting them to char array and to strings
		// (not converting from char to string will return ascii values)
		// parses them back to ints
		foreach (int r in newRecipies)
		{
			tail = tail.addAfter(new Recipie(r));
			numRecipies++;

			if (tailString != null)
			{
				if (checkTail(tail, tailString))
				{
					return (elves, tail, numRecipies, true);
				}
			}
		}

		// move both elves to the next recipie
		for (int e=0; e<elves.Length; e++)
		{
			elves[e] = elves[e].moveNext(elves[e].id+1);
		}

		return (elves, tail, numRecipies, false);
	}

    public static void part1(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var input = 919901;
		int numRecipies = 0;

		Recipie head = new Recipie(3);
		Recipie tail = new Recipie(7);
		head.next = tail;
		head.prev = tail;
		tail.prev = head;
		tail.next = head;
		Recipie[] elves = new Recipie[2];
		elves[0] = head;
		elves[1] = tail;
		numRecipies += 2;

		while (numRecipies <= input+10)
		{
			(elves, tail, int numNewRecipies, bool tailMatched) = iteration(elves, tail);

			numRecipies += numNewRecipies;
		}

		//get 10 after input
		Recipie first = head.moveNext(input);
		string result = first.id.ToString();
		for (int i=0; i<(10-1); i++)
		{
			first = first.moveNext(1);
			result += first.id.ToString();
		}

        Console.WriteLine("AoC 14 part1: {0}", result);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }

    public static void part2(string filename)
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();
		
		var input = "919901";
		int inputLength = input.ToString().Length;
		int numRecipies = 0;

		Recipie head = new Recipie(3);
		Recipie tail = new Recipie(7);
		head.next = tail;
		head.prev = tail;
		tail.prev = head;
		tail.next = head;
		Recipie[] elves = new Recipie[2];
		elves[0] = head;
		elves[1] = tail;
		numRecipies += 2;

		while (true)
		{
			(elves, tail, int numNewRecipies, bool tailMatched) = iteration(elves, tail, input);
			numRecipies += numNewRecipies;
			
			if (tailMatched)
			{
				Console.WriteLine("tail matched");
				break;
			}
		}

		// takes around 20 seconds to compute
        Console.WriteLine("AoC 14 part2: {0}", numRecipies - input.Length);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms\n", elapsed);
    }
}
