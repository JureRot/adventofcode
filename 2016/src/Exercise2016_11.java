import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeMap;

class Node {
    public String[] f4;
    public String[] f3;
    public String[] f2;
    public String[] f1;
    public int e;
    public int l;
    public int t;
    public int prev;

    Node(String[] f4, String[] f3, String[] f2, String[] f1, int e, int l, int t, int prev) {
        this.f4 = f4;
        this.f3 = f3;
        this.f2 = f2;
        this.f1 = f1;
        this.e = e;
        this.l = l;
        this.t = t;
        this.prev = prev;
    }

    public boolean isLegit() {

        return false;
    }
}

public class Exercise2016_11 {
    public static void main(String[] args) throws FileNotFoundException {

        ArrayList<String> input = new ArrayList<>();

        //starting vars
        Map<Integer, Node> all = new TreeMap<>();
        Map<Integer, Node> leaves = new TreeMap<>();

        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { //we read input line by line and construct input ArrayList
            input.add(sc.nextLine());
        }
        sc.close();

        //need to get combinatiations len 1 and 2 of array



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
