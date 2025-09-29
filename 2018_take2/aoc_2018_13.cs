namespace aoc_2018_take2;

class Cart {
	// state 0 = next is left; 1 = next is straight; 2 = next is right; %3 wrap around
	public int state = 0;
	// direction 0 = up; 1 = right; 2 = down; 3 = left
	public int direction;
	// which iter was the cart last moved (so we dont move it multiple times in the same iter)
	public int lastIter = 0;

	public Cart (int direction) {
		this.direction = direction;
	}
}

class CartLocation {
	// type 0 = empty; 1 = straight; 2 = curve; 3 = intersection
	public int type;
	// type variation for straight: 1 = up/down; 2 = left/right
	// type variation for curve: 1 = down/right, up/left (/); 2 = down/left, up/right (\)
	public int variation;
	public Cart? cart = null;

	public CartLocation(int type, int variation) {
		this.type = type;
		this.variation = variation;
	}
}

class aoc_2018_13
{
    static string filename = "aoc_2018_13.txt";

	static CartLocation[,] locations = new CartLocation[1,1];

	public static int[] iter (int iteration) {
		for (var j=0; j<locations.GetLength(0); j++) {
			for (var i=0; i<locations.GetLength(1); i++) {
				if (locations[j,i].cart != null) {
					var cart = locations[j,i].cart;
					if (cart != null && cart.lastIter < iteration) {
						var crash = moveCart(new int[]{j, i}, iteration);
						if (crash[0]!=-1 || crash[1]!=-1) {
							return new int[]{crash[0], crash[1]};
						}
					}
				}
			}
		}

		return new int[]{-1, -1};
	}

	public static int[] moveCart(int[] location, int iteration) {
		var cart = locations[location[0], location[1]].cart;
		
		if (cart != null) {
			var comingFrom = 0;
			var newY = -1;
			var newX = -1;

			switch (cart.direction) {
				case 0: // up
					comingFrom = 2;
					newY = location[0] - 1;
					newX = location[1];
					break;
				case 1: // right
					comingFrom = 3;
					newY = location[0];
					newX = location[1] + 1;
					break;
				case 2: // down
					comingFrom = 0;
					newY = location[0] + 1;
					newX = location[1];
					break;
				case 3: // left
					comingFrom = 1;
					newY = location[0];
					newX = location[1] - 1;
					break;
			}

			// check if exists (is within scope of array)
			if ((newY<0 || newY>=locations.GetLength(0)) || (newX<0 || newX>=locations.GetLength(1))) { // should not happen
				return new int[]{newY, newX};
			}
			// check if has path (type != 0)
			if (locations[newY, newX].type == 0) { // should not happen
				return new int[]{newY, newX};
			}

			// check if has cart
			if (locations[newY, newX].cart != null) { // crash
				return new int[]{newY, newX};
			}

			if (locations[newY, newX].type == 2) { // curve
				if (locations[newY, newX].variation == 1) { // /
					switch (comingFrom) {
						case 0:
							cart.direction = 3;
							break;
						case 1:
							cart.direction = 2;
							break;
						case 2:
							cart.direction = 1;
							break;
						case 3:
							cart.direction = 0;
							break;
					}
				} else if (locations[newY, newX].variation == 2) { // \
					switch (comingFrom) {
						case 0:
							cart.direction = 1;
							break;
						case 1:
							cart.direction = 0;
							break;
						case 2:
							cart.direction = 3;
							break;
						case 3:
							cart.direction = 2;
							break;
					}
				}
			}

			if (locations[newY, newX].type == 3) { // intersection
				// calculate new direction using %
				cart.direction = (cart.direction + (cart.state - 1) + 4) % 4;
				cart.state = (cart.state + 1) % 3;
			}

			cart.lastIter = iteration;

			// put the cart to the new location
			locations[newY, newX].cart = cart;
			locations[location[0], location[1]].cart = null;
		}

		return new int[]{-1, -1};
	}

	public static int iter2 (int iteration) {
		var numCrashes = 0;
		for (var j=0; j<locations.GetLength(0); j++) {
			for (var i=0; i<locations.GetLength(1); i++) {
				if (locations[j,i].cart != null) {
					var cart = locations[j,i].cart;
					if (cart != null && cart.lastIter < iteration) {
						var crash = moveCart2(new int[]{j, i}, iteration);
						if (crash) {
							numCrashes++;
						}
					}
				}
			}
		}

		return numCrashes;
	}

	public static bool moveCart2(int[] location, int iteration) {
		var cart = locations[location[0], location[1]].cart;
		
		if (cart != null) {
			var comingFrom = 0;
			var newY = -1;
			var newX = -1;

			switch (cart.direction) {
				case 0: // up
					comingFrom = 2;
					newY = location[0] - 1;
					newX = location[1];
					break;
				case 1: // right
					comingFrom = 3;
					newY = location[0];
					newX = location[1] + 1;
					break;
				case 2: // down
					comingFrom = 0;
					newY = location[0] + 1;
					newX = location[1];
					break;
				case 3: // left
					comingFrom = 1;
					newY = location[0];
					newX = location[1] - 1;
					break;
			}

			// check if exists (is within scope of array)
			if ((newY<0 || newY>=locations.GetLength(0)) || (newX<0 || newX>=locations.GetLength(1))) { // should not happen
				return true;
			}
			// check if has path (type != 0)
			if (locations[newY, newX].type == 0) { // should not happen
				return true;
			}

			// check if has cart
			if (locations[newY, newX].cart != null) { // crash
				//remove both carts
				locations[location[0], location[1]].cart = null;
				locations[newY, newX].cart = null;
				return true;
			}

			if (locations[newY, newX].type == 2) { // curve
				if (locations[newY, newX].variation == 1) { // /
					switch (comingFrom) {
						case 0:
							cart.direction = 3;
							break;
						case 1:
							cart.direction = 2;
							break;
						case 2:
							cart.direction = 1;
							break;
						case 3:
							cart.direction = 0;
							break;
					}
				} else if (locations[newY, newX].variation == 2) { // \
					switch (comingFrom) {
						case 0:
							cart.direction = 1;
							break;
						case 1:
							cart.direction = 0;
							break;
						case 2:
							cart.direction = 3;
							break;
						case 3:
							cart.direction = 2;
							break;
					}
				}
			}

			if (locations[newY, newX].type == 3) { // intersection
				// calculate new direction using %
				cart.direction = (cart.direction + (cart.state - 1) + 4) % 4;
				cart.state = (cart.state + 1) % 3;
			}

			cart.lastIter = iteration;

			// put the cart to the new location
			locations[newY, newX].cart = cart;
			locations[location[0], location[1]].cart = null;
		}

		return false;
	}

	private static int[] findCart() {
		for (var j=0; j<locations.GetLength(0); j++) {
			for (var i=0; i<locations.GetLength(1); i++) {
				if (locations[j,i].cart != null) {
					return new int[]{j, i};
				}
			}
		}

		return new int[]{-1, -1};
	}

    public static void part1()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);

		locations = new CartLocation[lines.Count(),lines[0].Length];
		
		Cart cart;

		for (var j=0; j<lines.Count(); j++) {
			for (var i=0; i<lines[j].Length; i++) {
				switch (lines[j][i]) {
					case '|': //ud
						locations[j,i] = new CartLocation(1, 0);
						break;
					case '-': //lr
						locations[j,i] = new CartLocation(1, 1);
						break;
					case '/': //lu / rd
						locations[j,i] = new CartLocation(2, 1);
						break;
					case '\\': //ld / ur
						locations[j,i] = new CartLocation(2, 2);
						break;
					case '+': //udlr
						locations[j,i] = new CartLocation(3, 0);
						break;
					case '^': //ud
						locations[j,i] = new CartLocation(1, 0);
						cart = new Cart(0);
						locations[j,i].cart = cart;
						break;
					case 'v': //ud
						locations[j,i] = new CartLocation(1, 0);
						cart = new Cart(2);
						locations[j,i].cart = cart;
						break;
					case '<': //lr
						locations[j,i] = new CartLocation(1, 1);
						cart = new Cart(3);
						locations[j,i].cart = cart;
						break;
					case '>': //lr
						locations[j,i] = new CartLocation(1, 1);
						cart = new Cart(1);
						locations[j,i].cart = cart;
						break;
					default:
						locations[j,i] = new CartLocation(0, 0);
						break;
				}
			}
		}

		var iteration = 1;
		var res = new int[]{-1, -1};

		while (res[0]==-1 && res[1]==-1) {
			res = iter(iteration);
			iteration++;
		}

		Console.WriteLine("AoC 13 part1: {0},{1}", res[1], res[0]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }

    public static void part2()
    {
        var watch = System.Diagnostics.Stopwatch.StartNew();

        var lines = File.ReadAllLines(filename);

		locations = new CartLocation[lines.Count(),lines[0].Length];
		var numCarts = 0;
		
		Cart cart;

		for (var j=0; j<lines.Count(); j++) {
			for (var i=0; i<lines[j].Length; i++) {
				switch (lines[j][i]) {
					case '|': //ud
						locations[j,i] = new CartLocation(1, 0);
						break;
					case '-': //lr
						locations[j,i] = new CartLocation(1, 1);
						break;
					case '/': //lu / rd
						locations[j,i] = new CartLocation(2, 1);
						break;
					case '\\': //ld / ur
						locations[j,i] = new CartLocation(2, 2);
						break;
					case '+': //udlr
						locations[j,i] = new CartLocation(3, 0);
						break;
					case '^': //ud
						locations[j,i] = new CartLocation(1, 0);
						cart = new Cart(0);
						locations[j,i].cart = cart;
						numCarts++;
						break;
					case 'v': //ud
						locations[j,i] = new CartLocation(1, 0);
						cart = new Cart(2);
						locations[j,i].cart = cart;
						numCarts++;
						break;
					case '<': //lr
						locations[j,i] = new CartLocation(1, 1);
						cart = new Cart(3);
						locations[j,i].cart = cart;
						numCarts++;
						break;
					case '>': //lr
						locations[j,i] = new CartLocation(1, 1);
						cart = new Cart(1);
						locations[j,i].cart = cart;
						numCarts++;
						break;
					default:
						locations[j,i] = new CartLocation(0, 0);
						break;
				}
			}
		}

		var iteration = 1;
		var numCrashes = 0;

		while (numCarts > 1) {
			numCrashes = iter2(iteration);
			numCarts -= numCrashes * 2;
			iteration++;
		}
		//iter2(iteration); // no need for another iteration

		var res = findCart();

		Console.WriteLine("AoC 13 part2: {0},{1}", res[1], res[0]);

        watch.Stop();
        var elapsed = watch.ElapsedMilliseconds;
        Console.WriteLine("Elapsed time: {0}ms", elapsed);
    }
}
