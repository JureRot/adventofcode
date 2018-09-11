import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Scanner;

class Duct {
    public int x;
    public int y;
    public int name; //-2:wall, -1:open; n:name

    public Duct(int row, int column, int n) {
        this.x = row;
        this.y = column;
        this.name = n;
    }

    public String getSig() {
        return (this.x + "-" + this.y);
    }
}

class AoC2016_24 {
    public static ArrayList<String> permutations(String prefix, String str, ArrayList<String> perms) { //taken from 2016_11 (more info there)
        if (str.length() == 0) {
            perms.add(prefix);
        } else {
            for (int i=0; i<str.length(); i++) {
                perms = permutations(prefix + str.charAt(i), str.substring(0, i) + str.substring(i+1, str.length()), perms);
            }
        }
        return perms;
    }

    public static ArrayList<Duct> makeMoves(Duct[][] map, HashSet<String> visited, int x, int y) { //makes all possible (and legal) moves
        ArrayList<Duct> output = new ArrayList<>();

        //we dont need to check if on the edge (if == 0), because the map has a wall border all the way around
        //up
        if (map[x-1][y].name!=-2 && !visited.contains((x-1)+"-"+y)) { //if up not wall and not already visited
            output.add(new Duct(x-1, y, -1)); //-1 = name is not really that important here, we will check if its final with x and y
        }
        //down
        if (map[x+1][y].name!=-2 && !visited.contains((x+1)+"-"+y)) {
            output.add(new Duct(x+1, y, -1));
        }
        //left
        if (map[x][y-1].name!=-2 && !visited.contains(x+"-"+(y-1))) {
            output.add(new Duct(x, y-1, -1));
        }
        //right
        if (map[x][y+1].name!=-2 && !visited.contains(x+"-"+(y+1))) {
            output.add(new Duct(x, y+1, -1));
        }
        
        return output;
    }

    public static int AstarLen(Duct[][] map, Duct start, Duct end) {
        //similar to 2016_13 (look for more detail)

        LinkedList<int[]> queue = new LinkedList<>();
        HashSet<String> visited = new HashSet<>();
        boolean found = false;
        int shortest = 0;

        queue.add(new int[]{start.x, start.y, 0, 0+(Math.abs(start.x-end.x) + Math.abs(start.y-end.y))});
        visited.add(start.getSig());


        while (!found) {
            if (queue.peek()[0]==end.x && queue.peek()[1]==end.y) { //if current top of stack is goal
                shortest = queue.remove()[2];
                found = true;
                continue; //maybe even break;
            }

            int[] current = queue.remove();

            ArrayList<Duct> moves = makeMoves(map, visited, current[0], current[1]);

            for (int i=0; i<moves.size(); i++) {
                Duct m = moves.get(i);
                queue.add(new int[]{m.x, m.y, current[2]+1, current[2]+(Math.abs(m.x-end.x)+Math.abs(m.y-end.y))});
                visited.add(m.getSig());
            }

            queue.sort( new Comparator<int[]>(){ // we create a custom comparator, that compares heuristic (pathlen + len to end)
                @Override
                public int compare(int[] o1, int[] o2){ //comparator must return 0 if equal, negative if first smaller and pozitive if second smaller
                    return o1[3] - o2[3];
                }
            });
        }

        return shortest;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars prep
        int rows = 0;
        int columns = 0;

        Scanner scTest = new Scanner(new File("input2016_24.txt")); //just to get the size of the map (could just hardcode)
        while (scTest.hasNextLine()) {
            rows++;
            columns = scTest.nextLine().length();
        }
        scTest.close();


        //vars (for real now)
        Duct[][] map = new Duct[rows][columns];
        rows = 0; //reuse rows for next part
        ArrayList<int[]> locations = new ArrayList<>(); //format [number, row, column]
        HashMap<Integer, int[]> locDistances = new HashMap<>(); //0:(to0, to1, ...); 1:(to0, to1, ...)...
        int fewestNumSteps = Integer.MAX_VALUE;
        String shortesPath = ""; //not really needed, for testing

        //second part
        int fewestNumSteps2 = Integer.MAX_VALUE;
        String shortesPath2 = "";

        Scanner sc = new Scanner(new File("input2016_24.txt"));
        while (sc.hasNextLine()) {
            String line = sc.nextLine();
            for (int i=0; i<line.length(); i++) {
                char duct = line.charAt(i);
                switch(duct) {
                    case '#':
                        map[rows][i] = new Duct(rows, i, -2);
                        break;
                    case '.':
                        map[rows][i] = new Duct(rows, i, -1);
                        break;
                    default:
                        map[rows][i] = new Duct(rows, i, Integer.parseInt(Character.toString(duct)));
                        locations.add(new int[]{Integer.parseInt(Character.toString(duct)), rows, i});
                        break;
                }
            }
            rows++;
        }
        sc.close();

        //we sort the arraylist by location name (not totaly needed, i just want to have order)
        Collections.sort(locations, new Comparator<int[]>(){ // we create a custom comparator, that compares the location names int[0]
            public int compare(int[] o1,int[] o2){ //comparator must return int: 0 if equal, negative if first smaller and pozitive if second smaller
                return o1[0] - o2[0];
            }
        });


        for (int i=0; i<locations.size(); i++) { //we construct locDistances
            locDistances.put(locations.get(i)[0], new int[locations.size()]);
        }

        //find and set distances between all pairs of locations
        for (int i=0; i<locations.size(); i++) { //for every possible pair of locations
            for (int j=i+1; j<locations.size(); j++) {
                //locations format: int[number, row, column]
                int[] a = locations.get(i);
                int[] b = locations.get(j);
                
                int distance = AstarLen(map, map[a[1]][a[2]], map[b[1]][b[2]]); //we get the distance between the two nodes

                int[] aLenghts = locDistances.get(a[0]); //we get
                int[] bLenghts = locDistances.get(b[0]);
                aLenghts[b[0]] = distance; //change
                bLenghts[a[0]] = distance;
                locDistances.put(a[0], aLenghts); //and update the distances in HashMap accordingly
                locDistances.put(b[0], bLenghts);

            }
        }


        String prePerms = ""; //we get all but the starting node in string (on which we will permute)
        for (int i=1; i<locations.size(); i++) {
            prePerms += locations.get(i)[0];
        }

        ArrayList<String> perms = permutations("", prePerms, new ArrayList<String>()); //we create all permutations

        //brute-force TSP
        for (int i=0; i<perms.size(); i++) {
            String perm = perms.get(i);
            int first = 0;
            int second = 0;

            int totalLen = 0;

            for (int j=0; j<perm.length(); j++) {
                second = Integer.parseInt(perm.charAt(j) +"");
                totalLen += locDistances.get(first)[second];
                first = second;
            }

            if (totalLen < fewestNumSteps) {
                fewestNumSteps = totalLen;
                shortesPath = "0" + perm;
            }

            //second part (back to 0)
            totalLen += locDistances.get(first)[0];

            if (totalLen < fewestNumSteps2) {
                fewestNumSteps2 = totalLen;
                shortesPath2 = "0" + perm + "0";
            }
        }

        System.out.println("1. fewest number of steps to visit all locations: " + fewestNumSteps);

        System.out.println("1. fewest number of steps to visit all locations and back: " + fewestNumSteps2);


        /*
        idea:  
        we first make a map of all possible nodes by reading the input
        nodes are ducts either wall, passage or location
        we also make a list of locations we need to visit [name, row, column]

        next we need to construct complete graph of distances of between all locations
        (this is represented as locDistances map (name_of_location: int[Dto0, Dto1, ...]))
        so, we go over all pairs (double for loop),
        find the dinstance between two nodes (a* with the help of makeMove)
        and set those distances in locDistances

        now we have a complete graph of all the distances

        now we need to solve the traveling salesman problem on this graph
        we do this by making all peremutations of locations (excluding the starting one (0))
        and check which of the sums of distances between them is the smallest

        tl,dr:
        find all locations in graph
        find all the shortest distances between them with a*
        brute-force the TSP on those distances (using permutations)

        p.s.: be careful of the formats of vars (not all are simple, most are int arrays)
        */
        
        //THIS IS SOMEWHAT OVERBUILT
        //the actual operations are fast, economic and verbose, but a bit hard to program and understand at fist

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}