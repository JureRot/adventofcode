namespace aoc_2018_take2;

class aoc_2018_11
{
    static string filename = "aoc_2018_11.txt";
	static public int[,,] GRID2 = new int[301,300,300];

	private static int powerLevel (int x, int y, int rank) {
		var res = 0;
		var rackId = x + 10;
		res += rackId * y;
		res = res + rank;
		res *= rackId;
		res = (res / 100) % 10;
		res -= 5;

		return res;
	}

	private static int[] findMax(int[,] grid) {
		var max = 0;
		var yMax = 0;
		var xMax = 0;

		for (var j=1; j<grid.GetLength(0)-1; j++) {
			for (var i=1; i<grid.GetLength(1)-1; i++) {
				var sum = grid[j-1,i-1]
					+ grid[j-1,i]
					+ grid[j-1,i+1]
					+ grid[j,i-1]
					+ grid[j,i]
					+ grid[j,i+1]
					+ grid[j+1,i-1]
					+ grid[j+1,i]
					+ grid[j+1,i+1];
				if (sum > max) {
					max = sum;
					yMax = j;
					xMax = i;
				}
			}
		}

		return new int[]{xMax, yMax};
		// this is not really correct
		// it worked because indexing is off by 1 and the windows is always 3
	}

	private static int[] findMax2(int[,] grid, int window = 3) {
		// make it variable for window size
		// method: sub the trailing edge, add the leading edge

		var max = 0;
		var yMax = 0;
		var xMax = 0;

		var prevSum = Int32.MinValue;

		for (var j=0; j<grid.GetLength(0)-(window-1); j++) {
			for (var i=0; i<grid.GetLength(1)-(window-1); i++) {
				var sum = prevSum;
				if (sum == Int32.MinValue) { //create sum
					sum = 0;
					for (var l=0; l<window; l++) {
						for (var k=0; k<window; k++) {
							sum += grid[j+l,i+k];
						}
					}
				} else { //update sum
					var trailing = 0;
					var leading = 0;
					for (var e=0; e<window; e++) {
						trailing += grid[j+e,i-1];
						leading += grid[j+e,i+window-1];
					}
					sum -= trailing;
					sum += leading;
				}

				if (sum > max) {
					max = sum;
					yMax = j+1;
					xMax = i+1;
				}

				prevSum = sum;
			}

			prevSum = Int32.MinValue;
		}

		return new int[]{max, xMax, yMax};
	}

	private static int[] findMax3(int window = 3) {
		// make it variable for window size
		// method: dynamic programming (sub the halfs or thirds of windows)

		var max = 0;
		var yMax = 0;
		var xMax = 0;

		for (var j=0; j<GRID2.GetLength(1)-(window-1); j++) {
			for (var i=0; i<GRID2.GetLength(2)-(window-1); i++) {
				if (window == 1) {
					GRID2[window,j,i] = GRID2[0,j,i];

					if (GRID2[window,j,i] > max) {
						max = GRID2[window,j,i];
						yMax = j+1;
						xMax = i+1;
					}
				} else {
					var sum = 0;
					if (window%2 == 0) {
						//sum 4 halves
						var scope = window / 2;
						sum += GRID2[scope,j,i]
							+ GRID2[scope,j,i+scope]
							+ GRID2[scope,j+scope,i]
							+ GRID2[scope,j+scope,i+scope];
						GRID2[window,j,i] = sum;
					} else if (window%3 == 0) {
						// sum 9 thirds
						var scope = window / 3;
						sum += GRID2[scope,j,i]
							+ GRID2[scope,j,i+scope]
							+ GRID2[scope,j,i+(2*scope)]
							+ GRID2[scope,j+scope,i]
							+ GRID2[scope,j+scope,i+scope]
							+ GRID2[scope,j+scope,i+(2*scope)]
							+ GRID2[scope,j+(2*scope),i]
							+ GRID2[scope,j+(2*scope),i+scope]
							+ GRID2[scope,j+(2*scope),i+(2*scope)];
						GRID2[window,j,i] = sum;
					} else { //special case
						//get floor half plus one column cross (care to not count them middle twice)
						var scope = window / 2; // int division is floor by default
						sum += GRID2[scope,j,i]
							+ GRID2[scope,j,i+(scope+1)]
							+ GRID2[scope,j+(scope+1),i]
							+ GRID2[scope,j+(scope+1),i+(scope+1)];

						for (var c=0; c<window; c++) {
							sum += GRID2[0,j+c,i+scope];
							sum += GRID2[0,j+scope,i+c];
						}
						sum -= GRID2[0,j+scope,i+scope]; // this is counted twice, so we remove it

						GRID2[window,j,i] = sum;
					}

					if (sum > max) {
						max = sum;
						yMax = j+1;
						xMax = i+1;
					}
				}
			}
		}

		return new int[]{max, xMax, yMax};
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = Convert.ToInt32(File.ReadAllLines(filename)[0]);

		var grid = new int[300,300];
		
		for (var j=0; j<grid.GetLength(0); j++) {
			for (var i=0; i<grid.GetLength(1); i++) {
				grid[j,i] = powerLevel(i+1, j+1, line);
			}
		}

		var biggest = findMax(grid);

		Console.WriteLine("AoC 11 part1: {0},{1}", biggest[0], biggest[1]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var line = Convert.ToInt32(File.ReadAllLines(filename)[0]);

		var grid = new int[300,300];
		
		for (var j=0; j<grid.GetLength(0); j++) {
			for (var i=0; i<grid.GetLength(1); i++) {
				var pl = powerLevel(i+1, j+1, line);
				grid[j,i] = pl;
				GRID2[0,j,i] = pl;
			}
		}

		var biggest = Int32.MinValue;
		var biggestCoords = new int[]{0,0,0};

		//version 1 (slow)
		for (var i=1; i<=300; i++) {
			var curr = findMax2(grid, i);
			if (curr[0] > biggest) {
				biggest = curr[0];
				biggestCoords[0] = curr[1];
				biggestCoords[1] = curr[2];
				biggestCoords[2] = i;
			}
		}

		Console.WriteLine("AoC 11 part2.1: {0},{1},{2}", biggestCoords[0], biggestCoords[1], biggestCoords[2]);


		biggest = Int32.MinValue;
		biggestCoords = new int[]{0,0,0};

		//version 2 (fast)
		for (var i=1; i<=300; i++) {
			var curr = findMax3(i);
			if (curr[0] > biggest) {
				biggest = curr[0];
				biggestCoords[0] = curr[1];
				biggestCoords[1] = curr[2];
				biggestCoords[2] = i;
			}
		}

		Console.WriteLine("AoC 11 part2.2: {0},{1},{2}", biggestCoords[0], biggestCoords[1], biggestCoords[2]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
