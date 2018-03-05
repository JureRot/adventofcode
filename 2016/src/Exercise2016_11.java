import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

class Node {
    Node() {

    }
}

public class Exercise2016_11 {
    public static void main(String[] args) throws FileNotFoundException {

        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { //we read input line by line and construct input ArrayList
            input.add(sc.nextLine());
        }
        sc.close();

        //idea: implement A* algorithm of searching the ideal path (or at least try to if you get a chance)
        /*
        we have a map of all nodes ((sorted) array for every floor, len (to get to node from S), total (value of len + heuristic),
        previous node)
        we will probably need more than one map (current for leaves and normal for all)
        map can be TreeMap and key number ("sorded" by time added)
        for every iteration we develop the node with the smallest total value -> combinations with len 2 for down and up (if both possible)
        we continue by A* rules and hope for the best
         */
    }
}
