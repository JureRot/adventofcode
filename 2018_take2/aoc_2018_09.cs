namespace aoc_2018_take2;

class Circle {
	private Marble? head;

	public Marble Head() {
		if (head != null) {
			return head;
		}

		return new Marble(); // should never happen
		// here just to remove the warning
	}

	public Marble SetHead(Marble newHead) {
		head = newHead;
		return head;
	}

	private void Insert(Marble node, int value) {
		var next = node.next;

		var inserted = new Marble(value, node, next);

		node.next = inserted;
		next.prev = inserted;
		SetHead(inserted);
	}

	public void InsertAt(int index, int value) {
		if (head == null) {
			var inserted = new Marble(value);
			SetHead(inserted);
			return;
		}
		
		var curr = head;
		if (index >= 0) {
			for (var i=0; i<index; i++) {
				curr = curr.next;
			}
		} else {
			for (var i=0; i<Math.Abs(index); i++) {
				curr = curr.prev;
			}
		}

		Insert(curr, value);
	}

	private int Remove(Marble node) {
		node.prev.next = node.next;
		node.next.prev = node.prev;
		SetHead(node.next);

		return node.value;
	}

	public int RemoveAt(int index) {
		if (head == null) {
			return -1;
		}
		
		var curr = head;
		if (index >= 0) {
			for (var i=0; i<index; i++) {
				curr = curr.next;
			}
		} else {
			for (var i=0; i<Math.Abs(index); i++) {
				curr = curr.prev;
			}
		}

		return Remove(curr);
	}
}

class Marble {
	public int value;
	public Marble prev;
	public Marble next;

	public Marble() {
		this.prev = this;
		this.next = this;
	}

	public Marble(int value) {
		this.value = value;
		this.prev = this;
		this.next = this;
	}

	public Marble(int value, Marble prev, Marble next) {
		this.value = value;
		this.prev = prev;
		this.next = next;
	}
}

class aoc_2018_09
{
    static string filename = "aoc_2018_09.txt";

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = File.ReadAllLines(filename)[0];
		var lineArray = line.Split(' ');

		var numPlayers = Convert.ToInt32(lineArray[0]);
		var numMarbles = Convert.ToInt32(lineArray[6]);

		var marbles = new SortedSet<int>();
		for (int i=0; i<=numMarbles; i++) {
			marbles.Add(i);
		}

		var players = new Dictionary<int,int>();
		for (int i=0; i<numPlayers; i++) {
			players[i] = 0;
		}

		var circle = new Circle();

		var start = new Marble();
		start.value = 0;
		// dont need to set next and prev are done automatically in constructor
		circle.InsertAt(0, 0);
		marbles.Remove(0);

		var player = 0;

		while (marbles.Count > 0) {
			var smallest = marbles.First();

			if (smallest % 23 != 0) {
				circle.InsertAt(1, smallest);
			} else {
				players[player] += smallest;
				var removed = circle.RemoveAt(-7);
				players[player] += removed;
				//marbles.Add(removed); marble is not added back
			}
			marbles.Remove(smallest);

			player = ++player % numPlayers;
		}

		var sortedPlayers = from p in players orderby p.Value descending select p;
		// this is LINQ (learn it)
		// could just sort it the default way (foreach)

        Console.WriteLine("AoC 09 part1: {0}", sortedPlayers.First().Value);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = File.ReadAllLines(filename)[0];
		var lineArray = line.Split(' ');

		var numPlayers = Convert.ToInt32(lineArray[0]);
		var numMarbles = Convert.ToInt32(lineArray[6]) * 100;

		var marbles = new SortedSet<int>();
		for (int i=0; i<=numMarbles; i++) {
			marbles.Add(i);
		}

		var players = new Dictionary<int,long>();
		for (int i=0; i<numPlayers; i++) {
			players[i] = 0;
		}

		var circle = new Circle();

		var start = new Marble();
		start.value = 0;
		circle.InsertAt(0, 0);
		marbles.Remove(0);

		var player = 0;

		while (marbles.Count > 0) {
			var smallest = marbles.First();

			if (smallest % 23 != 0) {
				circle.InsertAt(1, smallest);
			} else {
				players[player] += smallest;
				var removed = circle.RemoveAt(-7);
				players[player] += removed;
			}
			marbles.Remove(smallest);

			player = ++player % numPlayers;
		}

		var sortedPlayers = from p in players orderby p.Value descending select p;

        Console.WriteLine("AoC 09 part2: {0}", sortedPlayers.First().Value);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
