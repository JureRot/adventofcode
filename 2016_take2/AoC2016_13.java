import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;

class Location {
    public int x;
    public int y;
    public int pathLen;
    public int heuristic;
    public int cost; //total cost (g(n) + h(n) / pathlen+heuristic)

    public Location(int x, int y, int path) {
        this.x = x;
        this.y = y;
        this.pathLen = path;
        this.heuristic = Math.abs(31-this.x) + Math.abs(39-this.y); //constructs manhattan distance for heuristic //included hardcoded goal parameters
        this.cost = this.pathLen + this.heuristic;
    }

    public boolean checkLegal() { //checks if locatin is free (return true) of wall (return false)
        int input = 1350; //includes hardcoded input parameter

        if (this.x<0 || this.y<0) { //if any of the coordinates negative, the location is invalid
            return false;
        }

        //x*x + 3*x + 2*x*y + y + y*y plus input
        int temp = (this.x*this.x + 3*this.x + 2*this.x*this.y + this.y + this.y*this.y) + input;
        String bites = Integer.toBinaryString(temp);
        int count = 0;
        for (int i=0; i<bites.length(); i++) {
            if (bites.charAt(i) == '1') {
                count++;
            }
        }
        if (count%2 == 0) {
            return true;
        }
        return false;
    }

    public boolean checkGoal() {
        if (this.x==31 && this.y==39) { //includes hardcoded goal parameters
            return true;
        }
        return false;
    }

    public String getSignature() {
        String output = "";
        output += this.x + "," + this.y;

        return output;
    }
}

class AoC2016_13 {
    public static Location[] makeMoves(Location n) {
        Location[] output = new Location[4];
        //moves format: [up, down, left, right]
        
        output[0] = new Location(n.x, n.y-1, n.pathLen+1);
        output[1] = new Location(n.x, n.y+1, n.pathLen+1);
        output[2] = new Location(n.x-1, n.y, n.pathLen+1);
        output[3] = new Location(n.x+1, n.y, n.pathLen+1);

        return output;
    }

    public static Location[] pruneMoves(HashSet<String> visited, Location[] moves) {
        //moves format: [up, down, left, right]

        ArrayList<Location> passed = new ArrayList<>();

        for (int i=0; i<moves.length; i++) {
            if (moves[i].checkLegal() && !visited.contains(moves[i].getSignature())) {
                passed.add(moves[i]);
            }
        }

        Location[] output = new Location[passed.size()];
        for (int i=0; i<passed.size(); i++) {
            output[i] = passed.get(i);
        }

        return output;
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();

        //this problem could use 2016_11 bfs approach, but i would rather try with a* pathfinding algorithm

        //vars
        int input = 1350; //we will hardcode the input into the program
        LinkedList<Location> queue = new LinkedList<>();
        HashSet<String> visited = new HashSet<>();
        boolean found = false;

        //idea
        /*
        create all possible moves (up, down, left, right)
        prune moves (checkLegal), check if in visited
        add them to queue
        sort queue (costom comparator)
        check if first one is goal (checkGoal)
        if yes, return (location.pathLen)
        else, repeat
        */

        Location root = new Location(1, 1, 0);

        queue.add(root);
        visited.add(root.getSignature());
        //no need to sort here, ony one item

        while (!found) {
            if (queue.peek().checkGoal()) { //if the current node is the end, we output and end
                System.out.println("1. the minumum amount of steps: " + queue.remove().pathLen);
                found = true;
            }

            Location[] pruned = pruneMoves(visited, makeMoves(queue.remove())); //else, we take the first location (the most promissing), create all possible moves and prune them

            for (int j=0; j<pruned.length; j++) { //we add all moves (after pruning) to queue and to visited
                queue.add(pruned[j]);
                visited.add(pruned[j].getSignature());
            }

            queue.sort( new Comparator<Location>(){ // we create a custom comparator, that compares the total cost of node / Location (pathLen + heuristic)
                @Override
                public int compare(Location o1,Location o2){ //comparator must return 0 if equal, negative if first smaller and pozitive if second smaller
                    return o1.cost - o2.cost;
                }
                });
        }

        //second part
        //we try to floodfill the graph until the path len is less than 50
        queue.clear();
        visited.clear();
        found = false;

        queue.add(root);

        while (!found) {
            if (queue.peek().pathLen>50) { //if the smallest pathLen is more than 50 we are done, so we end
                System.out.println("2. the number of location we can visit with 50 steps or less: " + visited.size());
                found = true;
            }

            visited.add(queue.peek().getSignature()); //else, we add the current location to the visited and do than do as for part 1

            Location[] pruned = pruneMoves(visited, makeMoves(queue.remove()));

            for (int j=0; j<pruned.length; j++) {
                queue.add(pruned[j]);
            }

            queue.sort( new Comparator<Location>(){ // we create a different comparator here
                @Override
                    public int compare(Location o1,Location o2){ //we compare by pathLen, not the complete cost (effectively opposite of dijkstra) (thusly we floodfill the graph)
                        return o1.pathLen - o2.pathLen;
                    }
                });
        }

        //the second part is not optimal to use Location because it uses hardcoded heuristic (31,39)
        //but because we change the sorting comparator it does not effect the result

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}