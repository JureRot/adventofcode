namespace aoc_2018_take2;

class Node {
    public int minDistance = 999999;
    public HashSet<int> sources = new HashSet<int>();
}

class Neighbor {
    public int x = -1;
    public int y = -1;
    public int dist = 999999;

    public Neighbor(int y, int x, int dist) {
        this.y = y;
        this.x = x;
        this.dist = dist;
    }
}

class Sources {
    public int id = -1;
    public int x = -1;
    public int y = -1;

    public Sources(int id, int y, int x) {
        this.id = id;
        this.y = y;
        this.x = x;
    }
}

class aoc_2018_06
{
    static string filename = "aoc_2018_06.txt";

    private static Node[,] voronoi(Node[,] map) {
		// 2 iterations
		// filter downward and filter upward
		// note the min manhatthan distance from already seen for each iteration

        // iter 1
        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
                if (j==0 && i==0) {
                    continue;
                }

				// generate neighbours
                List<Neighbor> neighbors = new List<Neighbor>();

                if (j>0 && i>0) {
                    //left
                    var l = new Neighbor(j, i-1, 1);
                    neighbors.Add(l);
                    //up
                    var u = new Neighbor(j-1, i, 1);
                    neighbors.Add(u);
                    //uprleft
                    var ul = new Neighbor(j-1, i-1, 2);
                    neighbors.Add(ul);
                    //upright
                    if (i<map.GetLength(1)-1) {
                        var ur = new Neighbor(j-1, i+1, 2);
                        neighbors.Add(ur);
                    }
                } else {
                    if (j>0) { //y>0, x==0
                        //up
                        var u = new Neighbor(j-1, i, 1);
                        neighbors.Add(u);
                        //upright
                        if (i<map.GetLength(1)-1) {
                            var ur = new Neighbor(j-1, i+1, 2);
                            neighbors.Add(ur);
                        }
                    } else if (i>0) { //y==0, x>0
                        //left
                        var l = new Neighbor(j, i-1, 1);
                        neighbors.Add(l);
                    }
                }

                //check for each neighbor
                foreach(var n in neighbors) {
                    var neig = map[n.y,n.x];

                    //if larger -> ignore
                    //if same -> add to sources
                    //if smaller -> clear sources, write new smallest, add this to source

                    if (neig.minDistance+n.dist < map[j,i].minDistance) {
                        map[j,i].minDistance = neig.minDistance + n.dist;
                        map[j,i].sources.Clear();
                        foreach (var s in neig.sources) {
                            map[j,i].sources.Add(s);
                        }
                    } else if (neig.minDistance+n.dist == map[j,i].minDistance) {
                        foreach (var s in neig.sources) {
                            map[j,i].sources.Add(s);
                        }
                    }
                }
            }
        }

        // iter 2
        for (var j=map.GetLength(0)-1; j>=0; j--) {
            for (var i=map.GetLength(1)-1; i>=0; i--) {
                if (j==map.GetLength(0)-1 && i==map.GetLength(1)-1) {
                    continue;
                }

                List<Neighbor> neighbors = new List<Neighbor>();

                if (j<map.GetLength(0)-1 && i<map.GetLength(1)-1) {
                    //right
                    var r = new Neighbor(j, i+1, 1);
                    neighbors.Add(r);
                    //down
                    var d = new Neighbor(j+1, i, 1);
                    neighbors.Add(d);
                    //downright
                    var dr = new Neighbor(j+1, i+1, 2);
                    neighbors.Add(dr);
                    //downleft
                    if (i>0) {
                        var dl = new Neighbor(j+1, i-1, 2);
                        neighbors.Add(dl);
                    }
                } else {
                    if (j<map.GetLength(0)-1) {
						//down
						var d = new Neighbor(j+1, i, 1);
						neighbors.Add(d);
						//downleft
						if (i>0) {
							var dl = new Neighbor(j+1, i-1, 2);
							neighbors.Add(dl);
						}
                    } else if (i<map.GetLength(1)-1) {
                        //right
                        var r = new Neighbor(j, i+1, 1);
                        neighbors.Add(r);
                    }
                }

                foreach(var n in neighbors) {
                    var neig = map[n.y,n.x];

                    if (neig.minDistance+n.dist < map[j,i].minDistance) {
                        map[j,i].minDistance = neig.minDistance + n.dist;
                        map[j,i].sources.Clear();
                        foreach (var s in neig.sources) {
                            map[j,i].sources.Add(s);
                        }
                    } else if (neig.minDistance+n.dist == map[j,i].minDistance) {
                        foreach (var s in neig.sources) {
                            map[j,i].sources.Add(s);
                        }
                    }
                }
            }
        }

        return map;
    }

	public static int[,] sources(Node[,] map) {
		var res = new int[map.GetLength(0), map.GetLength(1)];

        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
				if (map[j,i].sources.Count == 1) {
					res[j,i] = map[j,i].sources.First();
				} else {
					res[j,i] = -1;
				}
            }
        }

		return res;
	}

	public static Dictionary<int, int> sums(int[,] srcs) {
		var res = new Dictionary<int, int>();

        for (var j=0; j<srcs.GetLength(0); j++) {
            for (var i=0; i<srcs.GetLength(1); i++) {
				if (!res.ContainsKey(srcs[j,i])) {
					res[srcs[j,i]] = 0;
				}
				res[srcs[j,i]]++;
            }
        }

		return res;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		// create map
        var map = new Node[1500, 1500];
		var yOffset = 500;
		var xOffset = 500;
        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
                map[j,i] = new Node();
            }
        }

		// insert source nodes
        var lines = File.ReadAllLines(filename);
        for (var i=0; i<lines.Length; i++)
        {
            var lineArray = lines[i].Split(", ");
            var x = Convert.ToInt32(lineArray[0]);
            var y = Convert.ToInt32(lineArray[1]);
            map[y+yOffset,x+xOffset].minDistance = 0;
            map[y+yOffset,x+xOffset].sources.Add(i);
        }

		// run voronoi
        map = voronoi(map);

		// create array of sources of voronoi
		var srcs = sources(map);

		// create a dictionary of source: count
		var sms = sums(srcs);

		// remove edges and collisions
		sms.Remove(-1);
		for (int j=0; j<srcs.GetLength(0); j++) {
			sms.Remove(srcs[j,0]);
			sms.Remove(srcs[j,srcs.GetLength(1)-1]);
		}
		for (int i=0; i<srcs.GetLength(1); i++) {
			sms.Remove(srcs[0,i]);
			sms.Remove(srcs[srcs.GetLength(0)-1,i]);
		}

		// get the largest of valid sources
		var maxCount = 0;
		var maxSrc = -1;

		foreach (var s in sms) {
			if (s.Value > maxCount) {
				maxCount = s.Value;
				maxSrc = s.Key;
			}
		}

        Console.WriteLine("AoC 06 part1: {0}", maxCount);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }


    private static int[,] voronoiSum(int[,] map, List<Sources> srcs) {
        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
				var distSum = 0;
				foreach (var s in srcs) {
					distSum += Math.Abs(j - s.y) + Math.Abs(i - s.x);
				}
				map[j,i] = distSum;
			}
		}

		return map;
	}

    private static int[,] cutoffRegion(int[,] map, int cutoff) {
        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
				if (map[j,i] < cutoff){
					map[j,i] = 1;
				} else {
					map[j,i] = 0;
				}
			}
		}

		return map;
	}

    private static int regionCount(int[,] map) {
		var sum = 0;

		// could flatten array and just sum it or do it directly in cutoffRegion()
        for (var j=0; j<map.GetLength(0); j++) {
            for (var i=0; i<map.GetLength(1); i++) {
				sum += map[j,i];
			}
		}
		return sum;
	}

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		var map = new int[1500,1500];
		var sources = new List<Sources>();
		var yOffset = 500;
		var xOffset = 500;
		var regionCutoff = 10000;

        var lines = File.ReadAllLines(filename);
        for (var i=0; i<lines.Length; i++)
        {
            var lineArray = lines[i].Split(", ");
            var x = Convert.ToInt32(lineArray[0]);
            var y = Convert.ToInt32(lineArray[1]);
			sources.Add(new Sources(i, y+yOffset, x+xOffset));
        }

		map = voronoiSum(map, sources);

		map = cutoffRegion(map, regionCutoff);

		var res = regionCount(map);

        Console.WriteLine("AoC 06 part2: {0}", res);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
