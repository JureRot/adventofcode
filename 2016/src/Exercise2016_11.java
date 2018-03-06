import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

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

public class Exercise2016_11 { //makes a arraylist of all combinations of len len of array (DFS approach)
    public static ArrayList<String[]> getCombinations(String[] array, int len) {
        ArrayList<String[]> out = new ArrayList<>();

        int[] combination = new int[len]; //we will save indexes in here (will change over the time, but at certain points will hold legitimate combinations)

        int pos = 0; //position (index) of the element in combination we are changing
        int index = 0; //index of element in array

        while (pos >= 0) {
            if (index <= (array.length + (pos - len))) { //if we havent reached the end of our array (havent exchanged the last element of combination with all the possible elements in array9
                combination[pos] = index; //we change the index in the value of the element at the current position

                if(pos == len-1){ //we composed the whole combination (current combination is long enough) (we changed the last element of current combination)
                    String[] inset = new String[len]; //we create new array and save it to output
                    for (int i=0; i<len; i++) {
                        inset[i] = array[combination[i]];
                    }
                    out.add(inset);
                    index++; // we change only index (next iteration will change only the last element of combination for the one after this one (this will repeat until we reach the last element in array)
                }
                else{ //until we still havent made the first combination (first len number of elements in array) we increase pos and index (next element of combination will be the next element in array)
                    index = combination[pos]+1;
                    pos++;
                }
            } else { //when we reach the end of the array we go one step back and change the second to last element in combination (not actually changed here. will be changed in the next iteration which will go over as if we havent yet reached the needed length of combination)(if the second to last elemetn is the last in array this will trigger multiple times in a row)
                pos--;
                if(pos > 0)
                    index = combination[pos]+1;
                else
                    index = combination[0]+1; //when we are backtracked enough that we are changing the first element in combination
            }
        }

        return out;
    }
    /*
    we start at the beginning (0)
    we increase pos and index until we reach the len of our combination
    now increase just index until we reach the end of the array (and overwrite the previous index at that (last) position)
    at this point we have all combinations which start with the first len-1 elements of array (only the last one is changing between them)
    now we decrease pos (and thus also index) and change the element second to last and repeat the previous step
    we backtrack like this until the first element of combination is len elements before the end of array (so the last combination includes the last len number of elements in array)

    imagining this is the easiest using the DFS on the tree
    we go down the tree until we reach the end (leaf)
    than we go one step back and check all the leaves at that branching
    and so on
     */


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

        String[] a = new String[]{"1", "2", "3", "4"};

        ArrayList<String[]> test = getCombinations(a, 3);

        for (int i=0; i<test.size(); i++) {
            for (int j=0; j<test.get(i).length; j++) {
                System.out.print(test.get(i)[j]);
            }
            System.out.println();
        }


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
