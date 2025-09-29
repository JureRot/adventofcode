using System.Text.RegularExpressions;

namespace aoc_2018_take2;

class Light {
	public int y;
	public int x;
	public int yVel;
	public int xVel;
	public static long yMin = Int64.MaxValue;
	public static long xMin = Int64.MaxValue;
	public static long yMax = Int64.MinValue;
	public static long xMax = Int64.MinValue;

	public Light(int y, int x, int yVel, int xVel) {
		this.y = y;
		this.x = x;
		this.yVel = yVel;
		this.xVel = xVel;
	}
}

class aoc_2018_10
{
    static string filename = "aoc_2018_10.txt";

	private static bool[,] createSky (HashSet<Light> lights) {
		var sky = new bool[Light.yMax+(Light.yMin*-1)+1,Light.xMax+(Light.xMin*-1)+1];

		foreach (var l in lights) {
			sky[l.y+(Light.yMin*-1),l.x+(Light.xMin*-1)] = true;
		}

		return sky;
	}

	private static void draw (bool[,] sky) {
		for (var j=0; j<sky.GetLength(0); j++) {
			for (var i=0; i<sky.GetLength(1); i++) {
				if (sky[j,i]) {
					Console.Write('#');
				} else {
					Console.Write('.');
				}
			}
			Console.WriteLine();
		}
	}

	private static HashSet<Light> iter (HashSet<Light> lights) {
		Light.yMin = Int32.MaxValue;
		Light.xMin = Int32.MaxValue;
		Light.yMax = Int32.MinValue;
		Light.xMax = Int32.MinValue;

		foreach (var l in lights) {
			l.y = l.y + l.yVel;
			l.x = l.x + l.xVel;

			if (l.y < Light.yMin) {
				Light.yMin = l.y;
			}
			if (l.y > Light.yMax) {
				Light.yMax = l.y;
			}
			if (l.x < Light.xMin) {
				Light.xMin = l.x;
			}
			if (l.x > Light.xMax) {
				Light.xMax = l.x;
			}
		}

		return lights;
	}

	private static HashSet<Light> reverseIter (HashSet<Light> lights) {
		Light.yMin = Int32.MaxValue;
		Light.xMin = Int32.MaxValue;
		Light.yMax = Int32.MinValue;
		Light.xMax = Int32.MinValue;

		foreach (var l in lights) {
			l.y = l.y - l.yVel;
			l.x = l.x - l.xVel;

			if (l.y < Light.yMin) {
				Light.yMin = l.y;
			}
			if (l.y > Light.yMax) {
				Light.yMax = l.y;
			}
			if (l.x < Light.xMin) {
				Light.xMin = l.x;
			}
			if (l.x > Light.xMax) {
				Light.xMax = l.x;
			}
		}

		return lights;
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		//var regexPattern = @"^[^<]*(<.*?>)[^<]*(<.*?)$";
		var regexPattern = @"^.*?<([^>]*)>.*?<([^>]*)>.*$";
		// matches everything but the contents of <>

		var lights = new HashSet<Light>();

		bool[,] sky;
		var area = Int64.MaxValue;
		var newArea = Int64.MaxValue;

        var lines = File.ReadAllLines(filename);
        foreach(var line in lines)
        {
			var trimmedLine = Regex.Replace(line, regexPattern, "$1, $2");
			trimmedLine = Regex.Replace(trimmedLine, @" *", ""); // removes all whitespace

			var lineArray = trimmedLine.Split(",");

			lights.Add(new Light(Convert.ToInt32(lineArray[1]), Convert.ToInt32(lineArray[0]), Convert.ToInt32(lineArray[3]), Convert.ToInt32(lineArray[2])));

			if (Convert.ToInt32(lineArray[1]) < Light.yMin) {
				Light.yMin = Convert.ToInt32(lineArray[1]);
			}
			if (Convert.ToInt32(lineArray[1]) > Light.yMax) {
				Light.yMax = Convert.ToInt32(lineArray[1]);
			}
			if (Convert.ToInt32(lineArray[0]) < Light.xMin) {
				Light.xMin = Convert.ToInt32(lineArray[0]);
			}
			if (Convert.ToInt32(lineArray[0]) > Light.xMax) {
				Light.xMax = Convert.ToInt32(lineArray[0]);
			}
        }

		newArea = (Light.yMax+(Light.yMin*-1)+1) * (Light.xMax+(Light.xMin*-1)+1);
		area = newArea;

		while (true) {
			iter(lights);
			newArea = (Light.yMax+(Light.yMin*-1)+1) * (Light.xMax+(Light.xMin*-1)+1);
			// dont create sky for each iteration because too big at the beginning

			if (newArea < area) {
				area = newArea;
			} else {
				reverseIter(lights); //because we dont generate sky for each iter we need to go one step back
				sky = createSky(lights);

				Console.WriteLine("AoC 10 part1:");
				draw(sky);
				break;
			}
		}

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

		var regexPattern = @"^.*?<([^>]*)>.*?<([^>]*)>.*$";

		var lights = new HashSet<Light>();

		var area = Int64.MaxValue;
		var newArea = Int64.MaxValue;

        var lines = File.ReadAllLines(filename);
        foreach(var line in lines)
        {
			var trimmedLine = Regex.Replace(line, regexPattern, "$1, $2");
			trimmedLine = Regex.Replace(trimmedLine, @" *", "");

			var lineArray = trimmedLine.Split(",");

			lights.Add(new Light(Convert.ToInt32(lineArray[1]), Convert.ToInt32(lineArray[0]), Convert.ToInt32(lineArray[3]), Convert.ToInt32(lineArray[2])));

			if (Convert.ToInt32(lineArray[1]) < Light.yMin) {
				Light.yMin = Convert.ToInt32(lineArray[1]);
			}
			if (Convert.ToInt32(lineArray[1]) > Light.yMax) {
				Light.yMax = Convert.ToInt32(lineArray[1]);
			}
			if (Convert.ToInt32(lineArray[0]) < Light.xMin) {
				Light.xMin = Convert.ToInt32(lineArray[0]);
			}
			if (Convert.ToInt32(lineArray[0]) > Light.xMax) {
				Light.xMax = Convert.ToInt32(lineArray[0]);
			}
        }

		newArea = (Light.yMax+(Light.yMin*-1)+1) * (Light.xMax+(Light.xMin*-1)+1);
		area = newArea;

		var counter = 0;

		while (true) {
			iter(lights);
			newArea = (Light.yMax+(Light.yMin*-1)+1) * (Light.xMax+(Light.xMin*-1)+1);

			if (newArea < area) {
				area = newArea;
			} else {
				Console.WriteLine("AoC 10 part2: {0}", counter);
				break;
			}

			counter++;
		}

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
