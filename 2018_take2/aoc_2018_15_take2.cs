namespace aoc_2018_take2;

public enum BattleUnitType {
	elf,
	goblin
}

class BattleUnit {
	public int hp;
	public int attack;
	public BattleUnitType type;

	public BattleUnit (int hp, int attack, BattleUnitType type) {
		this.hp = hp;
		this.attack = attack;
		this.type = type;
	}
}

class BattleFieldLocation {
	public bool walkable;
	public BattleUnit? unit;

	public int a_g = Int32.MaxValue;
	public int a_h = Int32.MaxValue;
	public int a_f = Int32.MaxValue;
	public BattleUnit? a_parent;

	public BattleFieldLocation (bool w) {
		walkable = w;
	}
	
	public BattleFieldLocation (bool w, BattleUnit u) {
		walkable = w;
		unit = u;
	}
	
	private void updateFValue () {
		a_f = a_g + a_h;
	}

	public void setAStarValues (int g, int h, BattleUnit? p = null) {
		a_g = g;
		a_h = h;
		updateFValue();
		a_parent = p;
	}
}


class aoc_2018_15_take2
{
    static string filename = "aoc_2018_15.txt";
	static BattleFieldLocation[,] battleField = new BattleFieldLocation[0,0];

	public static List<int[]> getTurnOrder() {
		List<int[]> result = new List<int[]>();

		for (var j=0; j<battleField.GetLength(0); j++) {
			for (var i=0; i<battleField.GetLength(1); i++) {
				if (battleField[j,i].unit != null) {
					result.Add(new int[]{j, i});
				}
			}
		}

		return result;
	}

	public static bool isNextToOpponent(int[] loc) {
		var unit = battleField[loc[0],loc[1]].unit;

		if (unit == null) {
			return false;
		}

		var type = unit.type;
		//up
		if (battleField[loc[0]-1,loc[1]].unit!=null && battleField[loc[0]-1,loc[1]].unit!.type!=type) { // need! to suppress the warning
			return true;
		}
		//left
		if (battleField[loc[0],loc[1]-1].unit!=null && battleField[loc[0],loc[1]-1].unit!.type!=type) {
			return true;
		}
		//right
		if (battleField[loc[0],loc[1]+1].unit!=null && battleField[loc[0],loc[1]+1].unit!.type!=type) {
			return true;
		}
		//down
		if (battleField[loc[0]+1,loc[1]].unit!=null && battleField[loc[0]+1,loc[1]].unit!.type!=type) {
			return true;
		}

		return false;
	}

	public static List<int[]> getOpponentLocations (int[] loc) {
		var result = new List<int[]>();
		var unit = battleField[loc[0],loc[1]].unit;

		if (unit == null) {
			return result;
		}

		var type = unit.type;

		for (var j=0; j<battleField.GetLength(0); j++) {
			for (var i=0; i<battleField.GetLength(1); i++) {
				if (j!=loc[0] || i!=loc[1]) {
					if (battleField[j,i].unit!=null && battleField[j,i].unit!.type!=type) {
						// add neighbouring locations
						//up
						if (battleField[j-1,i].walkable && battleField[j-1,i].unit==null) {
							result.Add(new int[]{j-1,i});
						}
						//left
						if (battleField[j,i-1].walkable && battleField[j,i-1].unit==null) {
							result.Add(new int[]{j,i-1});
						}
						//right
						if (battleField[j,i+1].walkable && battleField[j,i+1].unit==null) {
							result.Add(new int[]{j,i+1});
						}
						//down
						if (battleField[j+1,i].walkable && battleField[j+1,i].unit==null) {
							result.Add(new int[]{j+1,i});
						}
					}
				}
			}
		}

		return result;
	}

	public static void clearAStarNodes () {
		for (var j=0; j<battleField.GetLength(0); j++) {
			for (var i=0; i<battleField.GetLength(1); i++) {
				var loc = battleField[j,i];
				loc.a_g = Int32.MaxValue;
				loc.a_h = Int32.MaxValue;
				loc.a_g = Int32.MaxValue;
				loc.a_parent = null;
			}
		}
	}

	public static int getDistance(int[] from, int[] to) {
		var result = 0;

		result += Math.Abs(from[0]-to[0]);
		result += Math.Abs(from[1]-to[1]);

		return result;
	}

	public static int[]? aStar(int[] from, int[] to) {
		// if no path is found return null
		// else return firststep_y, firststep_y, pathlength
		Console.WriteLine("{0},{1} -> {2},{3}", from[0], from[1], to[0], to[1]);

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
		List<BattleFieldLocation> open = new List<BattleFieldLocation>();
		List<BattleFieldLocation> closed = new List<BattleFieldLocation>();

		battleField[from[0],from[1]].setAStarValues(0, getDistance(from, to)*100, null);
		open.Add(battleField[from[0],from[1]]);
		open.OrderBy(n => n.a_f);

		/*while (open.Count > 0) {

		}*/

		clearAStarNodes();
		return null;
	}

	public static int[]? findUnitMove(int[] currLoc) {
		//if next to opponent
		if (isNextToOpponent(currLoc)) {
			Console.WriteLine("next to opponent");
			return null;
		}

		// else return new location
		// get opponent locations
		var targets = getOpponentLocations(currLoc);
		if (targets.Count > 0) {
			Console.WriteLine("has targets");
			// note best path
			foreach (var t in targets) {
				Console.Write("{0},{1}; ", t[0], t[1]);
				// execute a*
				aStar(currLoc, t);
				// if none paths found return null
				// else return first step of shortest path (reading order)
			}
			Console.WriteLine();
		} // else end battle i guess

		return currLoc;
	}

	public static int[] moveUnit(int[] currLoc) {
		// find location
		var nextLoc = findUnitMove(currLoc);
		// if not null, move the unit and return new location
		if (nextLoc != null) {
			var unit = battleField[currLoc[0],currLoc[1]].unit;
			battleField[nextLoc[0],nextLoc[1]].unit = unit;
			battleField[currLoc[0],currLoc[1]].unit = null;

			return nextLoc;
		}

		return currLoc;
	}

	public static void turn() {
		// get turn order
		List<int[]> turnOrder = getTurnOrder();

		// foreach unit in turn order
		foreach (int[] t in turnOrder) {
			var unitY = t[0];
			var unitX = t[1];
			Console.WriteLine("{0}, {1}", unitY, unitX);

			// move unit if needed
			var newLoc = moveUnit(new int[]{unitY, unitX});
			unitY = newLoc[0];
			unitX = newLoc[1];

			// make unit attack if possible
			// check if no more opponents so the battle ends
		}
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);
		battleField = new BattleFieldLocation[lines.GetLength(0), lines[0].Length];

		for (var j=0; j<lines.GetLength(0); j++) {
			for (var i=0; i<lines[j].Length; i++) {
				//Console.Write(lines[j][i]);
				var location = lines[j][i];
				if (location == '#') {
					Console.Write('#');
					battleField[j,i] = new BattleFieldLocation(false);
				} else if (location == '.') {
					Console.Write('_');
					battleField[j,i] = new BattleFieldLocation(true);
				} else if (location == 'E') {
					var elf = new BattleUnit(200, 3, BattleUnitType.elf);
					battleField[j,i] = new BattleFieldLocation(true, elf);
					Console.Write('e');
				} else if (location == 'G') {
					var goblin = new BattleUnit(200, 3, BattleUnitType.goblin);
					battleField[j,i] = new BattleFieldLocation(true, goblin);
					Console.Write('g');
				}
			}
			Console.WriteLine();
		}

		turn();

		Console.WriteLine("AoC 15 part2 part1: {0}", "bla");

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
