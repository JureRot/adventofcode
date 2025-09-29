namespace aoc_2018_take2;

class Warrior {
	public int hp = 200;
	public int power = 3;
	// type 1 = elf, 2 = goblin
	public int type;

	public Warrior (int type) {
		this.type = type;
	}
}

class BattleLocation {
	public bool accessable;
	public Warrior? unit = null;

	public BattleLocation (bool acc) {
		this.accessable = acc;
	}
}

class StarNode {
	// need location because else parent doesnt tell us anything (or not??)
	// that also means we dont need an 2d array (just 2 arrays)
	public int y;
	public int x;
	public double g; //up until now
	public double h; //heuristics to the end
	public double f; //sum of g and h
	public StarNode? parent; // should this be a [y, x] and not a starNode?

	public StarNode (int y, int x, double g, double h) {
		this.y = y;
		this.x = x;
		this.g = g;
		this.h = h;
		this.f = this.g + this.h;
	}

	public void updateFCost() {
		this.f = Math.Round(this.g + this.h, 3);
	}
}

class aoc_2018_15
{
    static string filename = "aoc_2018_15.txt";
	static BattleLocation[,] battle = new BattleLocation[0,0];

	private static List<int[]> playOrder () {
		var order = new List<int[]>();
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				if (battle[j,i].unit != null ) {
					order.Add(new int[]{j, i});
				}
			}
		}

		return order;
	}

	private static bool hasOpponentInRange(int j, int i, int type) {
		var unit = battle[j,i].unit;
		if (unit == null) {
			return false;
		}

		//up
		if (j>0) {
			var opponent = battle[j-1,i].unit;
			if (opponent != null && opponent.type != unit.type) {
				return true;
			}
		}
		//left
		if (i>0) {
			var opponent = battle[j,i-1].unit;
			if (opponent != null && opponent.type != unit.type) {
				return true;
			}
		}
		//right
		if (i<battle.GetLength(1)) {
			var opponent = battle[j,i+1].unit;
			if (opponent != null && opponent.type != unit.type) {
				return true;
			}
		}
		//down
		if (i<battle.GetLength(0)) {
			var opponent = battle[j+1,i].unit;
			if (opponent != null && opponent.type != unit.type) {
				return true;
			}
		}

		return false;
	}

	private static int[]? attackOpponentInRange(int j, int i) {
		var opponentLoc = new int[]{-1, -1};
		var minHP = Int32.MaxValue;
		var unit = battle[j,i].unit;
		if (unit == null) {
			return null;
		}

		//up
		if (j>0) {
			var opponent = battle[j-1,i].unit;
			if (opponent != null && opponent.type != unit.type) {
				if (opponent.hp < minHP) {
					minHP = opponent.hp;
					opponentLoc[0] = j-1;
					opponentLoc[1] = i;
				}
			}
		}
		//left
		if (i>0) {
			var opponent = battle[j,i-1].unit;
			if (opponent != null && opponent.type != unit.type) {
				if (opponent.hp < minHP) {
					minHP = opponent.hp;
					opponentLoc[0] = j;
					opponentLoc[1] = i-1;
				}
			}
		}
		//right
		if (i<battle.GetLength(1)) {
			var opponent = battle[j,i+1].unit;
			if (opponent != null && opponent.type != unit.type) {
				if (opponent.hp < minHP) {
					minHP = opponent.hp;
					opponentLoc[0] = j;
					opponentLoc[1] = i+1;
				}
			}
		}
		//down
		if (i<battle.GetLength(0)) {
			var opponent = battle[j+1,i].unit;
			if (opponent != null && opponent.type != unit.type) {
				if (opponent.hp < minHP) {
					minHP = opponent.hp;
					opponentLoc[0] = j+1;
					opponentLoc[1] = i;
				}
			}
		}

		if (minHP < Int32.MaxValue) {
			//Console.WriteLine("attack opponent {0},{1} -> {2},{3}", j, i, opponentLoc[0], opponentLoc[1]);
			//todo attack opponent
			var opponent = battle[opponentLoc[0], opponentLoc[1]].unit;
			opponent!.hp -= unit.power;

			if (opponent.hp <= 0) {
				battle[opponentLoc[0], opponentLoc[1]].unit = null;
			}

			return opponentLoc;
		}

		return null;
	}

	private static List<int[]> getOpponentLocations(int y, int x, int type) {
		var locations = new List<int[]>();
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				if (j!=y || i!=x) {
					var opponent = battle[j,i].unit;
					if (opponent != null && opponent.type != type) {
						//check in reading order
						if (battle[j-1, i].accessable && battle[j-1, i].unit==null) {
							locations.Add(new int[]{j-1, i});
						}
						if (battle[j, i-1].accessable && battle[j, i-1].unit==null) {
							locations.Add(new int[]{j, i-1});
						}
						if (battle[j, i+1].accessable && battle[j, i+1].unit==null) {
							locations.Add(new int[]{j, i+1});
						}
						if (battle[j+1, i].accessable && battle[j+1, i].unit==null) {
							locations.Add(new int[]{j+1, i});
						}
					}
				}
			}
		}

		return locations;
	}

	private static float getDistance (int[] from, int [] to) {
		return Math.Abs(from[0]-to[0]) + Math.Abs(from[1]-to[1]);
	}

	private static StarNode getLowestFCost (List<StarNode> array) {
		StarNode output = array[0];
		
		for (var i=1; i<array.Count; i++) {
			if (array[i].f < output.f) {
				output = array[i];
			}
		}

		//Console.WriteLine("get lowest f cost: {0}", output.f);
		return output;
	}

	private static object[] handleNeigbour(List<StarNode> open, List<StarNode> closed, StarNode?[,] aStarBattle, StarNode current, int[] to, int direction) {
		var n_y = current.y;
		var n_x = current.x;
		var factor = 1000;
		
		switch (direction) {
			case 0:
				n_y -= 1;
				break;
			case 1:
				n_x-=1;
				factor += 1;
				break;
			case 2:
				n_x += 1;
				factor += 2;
				break;
			case 3:
				n_y += 1;
				factor += 3;
				break;
		}

		//Console.WriteLine("{0},{1} -> {2},{3} {4} {5}", current.y, current.x, n_y, n_x, factor, direction);
		if ((battle[n_y, n_x].accessable && battle[n_y, n_x].unit==null) && (aStarBattle[n_y, n_x] == null || !closed.Contains(aStarBattle[n_y, n_x]!))) {
			StarNode? neighbour = aStarBattle[n_y, n_x];
			if (neighbour == null) {
				neighbour = new StarNode(n_y, n_x, current.g+factor, getDistance(new int[]{n_y, n_x}, to)*1000);
				neighbour.parent = current;
				open.Add(neighbour);
				aStarBattle[n_y, n_x] = neighbour;
				//Console.WriteLine("added neighbour {0},{1} {2} ; {3},{4}", n_y, n_x, neighbour.f, neighbour.parent.y, neighbour.parent.x);
			}

			if (neighbour.g > current.g+factor) {
				neighbour.g = current.g+factor;
				neighbour.parent = current;
				neighbour.updateFCost();
				//Console.WriteLine("update neighbour {0},{1} {2} ; {3},{4}", n_y, n_x, neighbour.f, neighbour.parent.y, neighbour.parent.x);
				//Console.WriteLine("updated neighbour");
			}
		}

		return new object[] {open, closed, aStarBattle};
	}

	private static int[] reconstructPath(StarNode start, StarNode end) {
		StarNode backtrack = start;
		var length = 0;
		var lastLoc = new int[2];

		while (backtrack != end) {
			lastLoc[0] = backtrack!.y;
			lastLoc[1] = backtrack!.x;
			length++;
			//Console.WriteLine("{0},{1} : {2},{3}", lastLoc[0], lastLoc[1], backtrack.parent.y, backtrack.parent.x);
			backtrack = backtrack.parent!;
		}

		return new int[]{lastLoc[0], lastLoc[1], length};
	} 

	private static int[] aStar (int[] from, int [] to) {
		// damn, how does a* work
		// need new datastructure to hold the values (location, g, h, f, parent) //StarNode
		// need 2 arrays open (sorted by h) and closed //both List<StarNode>
		// nodes for the same location can repeat (or if we have 2d array they need to be updated)
		// need a sorted datastructure to hold the next node to check
		// how to handle multiple best paths (implement reading order) //needs to preffer reading order
		// maybe return int[] with distance and first move
		//Console.WriteLine("aStar f: {0},{1} -> t: {2},{3}", from[0], from[1], to[0], to[1]);

		//todo write a* logic
		/*
		OPEN //the set of nodes to be evaluated
		CLOSED //the set of nodes already evaluated
		add the start node to OPEN

		loop
			current = node in OPEN with the lowest f_cost
			remove current from OPEN
			add current to CLOSED

			if current is the target node //path has been found
				return (reconstructed path)

			foreach neighbour of the current node
				if neighbour is not traversable or neighbour is in CLOSED
					skipp to the next neighbour

				if new path to neighbour is shorter OR neighbour is not in OPEN
					set f_cost of neighbour
					set parent of neighbour to current
					if neighbour is not in OPEN
						add neighbour to OPEN
		*/

		List<StarNode> open = new List<StarNode>();
		List<StarNode> closed = new List<StarNode>();
		//Console.WriteLine("battle size: {0},{1}", battle.GetLength(0), battle.GetLength(1));
		StarNode?[,] aStarBattle = new StarNode?[battle.GetLength(0), battle.GetLength(1)];

		var starting = new StarNode(from[0], from[1], 0, getDistance(from, to)*1000);
		open.Add(starting);
		aStarBattle[from[0], from[1]] = starting;

		/*Console.WriteLine("astar battle:");
		for (var j=0; j<aStarBattle.GetLength(0); j++){
			for (var i=0; i<aStarBattle.GetLength(1); i++){
				if (aStarBattle[j,i] == null){
					Console.Write('_');
				} else {
					Console.Write("{0}", aStarBattle[j,i]!.f.ToString());
					//! tells the compiler that nullable reference is not null so we dont get a warrning
				}
			}
			Console.WriteLine();
		}*/

		while (open.Count > 0) {
			var current = getLowestFCost(open);
			open.Remove(current);
			closed.Add(current);

			if (current.y==to[0] && current.x==to[1]) {
				//Console.WriteLine("got to location -> reconstruct path");
				//reconstruct path
				var reconstructed = reconstructPath(current, starting);
				//Console.WriteLine("{0},{1} = {2}", reconstructed[0], reconstructed[1], reconstructed[2]);
				return reconstructed;
			}

			//Console.WriteLine("cur loc: {0} {1}", current.y, current.x);
			//get neighbours (traversable (check battle), not in closed (check closed))

			//top neighbour
			var topHandled = handleNeigbour(open, closed, aStarBattle, current, to, 0);
			open = (List<StarNode>)topHandled[0];
			closed = (List<StarNode>)topHandled[1];
			aStarBattle = (StarNode?[,])topHandled[2];
			
			//left neighbour
			var leftHandled = handleNeigbour(open, closed, aStarBattle, current, to, 1);
			open = (List<StarNode>)leftHandled[0];
			closed = (List<StarNode>)leftHandled[1];
			aStarBattle = (StarNode?[,])leftHandled[2];

			//right neighbour
			var rightHandled = handleNeigbour(open, closed, aStarBattle, current, to, 2);
			open = (List<StarNode>)rightHandled[0];
			closed = (List<StarNode>)rightHandled[1];
			aStarBattle = (StarNode?[,])rightHandled[2];

			//bottom neighbour
			var bottomHandled = handleNeigbour(open, closed, aStarBattle, current, to, 3);
			open = (List<StarNode>)bottomHandled[0];
			closed = (List<StarNode>)bottomHandled[1];
			aStarBattle = (StarNode?[,])bottomHandled[2];
		}

		return new int[] {0, 0, Int32.MaxValue};
	}

	private static int[] moveUnit(int j, int i, int type) {
		var locations = getOpponentLocations(j, i, type);

		var bestLoc = new int[]{j, i};
		var bestDist = Int32.MaxValue;
		//because opponent locations are got in reading order we dont need to worry here

		foreach (var l in locations) {
			// check if accessible and in the meantime get the best (a*)
			//Console.WriteLine("{0}, {1}", l[0], l[1]);
			var aStarResult = aStar(new int[]{j, i}, new int[]{l[0], l[1]});
			//if new best distance better than bestDist replace and take note of the location
			if (aStarResult[2]!=-1 && aStarResult[2] < bestDist) {
				bestDist = aStarResult[2];
				bestLoc[0] = aStarResult[0];
				bestLoc[1] = aStarResult[1];
			}
		}

		if (bestDist < Int32.MaxValue) {
			battle[bestLoc[0], bestLoc[1]].unit = battle[j, i].unit;
			battle[j, i].unit = null;
		}

		//Console.WriteLine("bestLoc: {0},{1} bestDist: {2}", bestLoc[0], bestLoc[1], bestDist);
		return bestLoc;
	}

	private static bool hasAnyOpponents(int y, int x) {
		var unitType = battle[y, x].unit!.type;
		//nested for, check if unit, check if opposite type
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				if (battle[j, i].unit != null) {
					if (battle[j, i].unit!.type != unitType) {
						return true;
					}
				}
			}
		}
		
		return false;
	}

	private static bool iteration () {
		// get play order
		var order = playOrder();

		foreach (var w in order) {
			var unit = battle[w[0],w[1]].unit;
			if (unit != null) {
				var unitY = w[0];
				var unitX = w[1];
				if (!hasAnyOpponents(unitY, unitX)) {
					return false;
				}

				// check if unit has opponent in range
				var hasOpponent = hasOpponentInRange(unitY, unitX, unit.type);
				//Console.WriteLine(hasOpponent);

				if (!hasOpponent) { // move first
					//find all opponents
					//find all valid adjacent locations to all oponents
					//find a* path to all locations
					var newLoc = moveUnit(unitY, unitX, unit.type);
					//Console.WriteLine("move {0},{1} to {2},{3}", unitY, unitX, newLoc[0], newLoc[1]);
					unitY = newLoc[0];
					unitX = newLoc[1];

					//break;
				}

				//try to attack
				hasOpponent = hasOpponentInRange(unitY, unitX, unit.type);
				if (hasOpponent) {
					var opponent = attackOpponentInRange(unitY, unitX); //new location
				}
			}
		}
		
		return true;
	}

	public static int sumHP() {
		var sum = 0;
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				if (battle[j, i].unit != null) {
					sum += battle[j,i].unit!.hp;
				}
			}
		}

		return sum;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);
		battle = new BattleLocation[lines.GetLength(0), lines[0].Length];

		for (var j=0; j<lines.GetLength(0); j++) {
			for (var i=0; i<lines[j].Length; i++) {
				if (lines[j][i] == '#') {
					battle[j,i] = new BattleLocation(false);
				} else {
					battle[j,i] = new BattleLocation(true);
					if (lines[j][i] == 'E') {
						var elf = new Warrior(1);
						battle[j,i].unit = elf;
					}
					if (lines[j][i] == 'G') {
						var goblin = new Warrior(2);
						battle[j,i].unit = goblin;
					}
				}
			}
		}

		var iterations = 0;

		/*Console.WriteLine("iteration {0}", iterations);
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				var loc = battle[j,i];
				if (!loc.accessable) {
					Console.Write("#");
				} else {
					if (loc.unit != null) {
						Console.Write(loc.unit.type);
					} else {
						Console.Write("_");
					}
				}
			}
			Console.WriteLine();
		}

		iteration();
		iterations++;

		Console.WriteLine("iteration {0}", iterations);
		for (var j=0; j<battle.GetLength(0); j++) {
			for (var i=0; i<battle.GetLength(1); i++) {
				var loc = battle[j,i];
				if (!loc.accessable) {
					Console.Write("#");
				} else {
					if (loc.unit != null) {
						Console.Write(loc.unit.type);
					} else {
						Console.Write("_");
					}
				}
			}
			Console.WriteLine();
		}*/

		while (true) {
			var stillOpponents = iteration();
			if (!stillOpponents) {
				break;
			}

			/*Console.WriteLine("iteration {0}", iterations);
			for (var j=0; j<battle.GetLength(0); j++) {
				for (var i=0; i<battle.GetLength(1); i++) {
					var loc = battle[j,i];
					if (!loc.accessable) {
						Console.Write("#");
					} else {
						if (loc.unit != null) {
							Console.Write(loc.unit.type);
						} else {
							Console.Write("_");
						}
					}
				}
				Console.WriteLine();
			}*/

			iterations++;
		}

		Console.WriteLine("iterations: {0}", iterations);
		var hpSum = sumHP();
		Console.WriteLine("hp remaining: {0}", hpSum);
		
		//iter
		// get unit order (reading order)
		// moving:
		// get all targets
		// get adjacent squares
		// get reachable (a*)
		// get nearest (reading order)
		// generate path / next step (a* + reading order)
		// attacking:
		// get all adjacent
		// get one with lowest hp (reading order)


		Console.WriteLine("AoC 15 part1: {0}", iterations * hpSum);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
