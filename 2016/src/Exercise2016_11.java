import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;
import java.util.regex.Pattern;

class Node {
    public String[] f4;
    public String[] f3;
    public String[] f2;
    public String[] f1;
    public int e;
    public int l;
    public int t;
    public int prev;
    public boolean legit;

    Node(String[] f4, String[] f3, String[] f2, String[] f1, int e, int l, int prev) {
        this.f4 = f4;
        this.f3 = f3;
        this.f2 = f2;
        this.f1 = f1;
        this.e = e;
        this.l = l;
        this.t = this.getT();
        this.prev = prev;
        this.legit = isLegit();
    }

    public boolean isLegit() {
        outerloop4: //label for outer loop so we can break or continue the outer loop from within the inner one
        for (int i=0; i<this.f4.length; i++) { //for every element on fourt floor
            if (this.f4[i].charAt(1) == 'M') { //if it is microchip (second char is M)
                Pattern p1 = Pattern.compile(this.f4[i].charAt(0) + "G"); //we create a regex pater for his generator (the first char plus G)
                for (int j = 0; j < this.f4.length; j++) { //we go over all elements on the same floor
                    if (p1.matcher(this.f4[j]).matches()) { //if we found it (the chip is powered and is not in danger fro mother generators)
                        continue outerloop4; //we continue the outer loop (this means we skip this iteration of the loop but don't break it)
                    }
                }
                Pattern p2 = Pattern.compile("[^" + this.f4[i].charAt(0) + "]G"); //if the corresponding generator isn't found we create a regex patter of (whatever letter but the one as in the chip plus G) (generator that isn't for this microship)
                for (int j = 0; j < this.f4.length; j++) {
                    if (p2.matcher(this.f4[j]).matches()) { //if we found a generator that isn't compatible with the chip
                        return false; //we return false (thus node isn't legit)
                    }
                }
            }
        }

        outerloop3: //we do the same for all other floors
        for (int i=0; i<this.f3.length; i++) {
            if (this.f3[i].charAt(1) == 'M') {
                Pattern p1 = Pattern.compile(this.f3[i].charAt(0) + "G");
                for (int j = 0; j < this.f3.length; j++) {
                    if (p1.matcher(this.f3[j]).matches()) {
                        continue outerloop3;
                    }
                }
                Pattern p2 = Pattern.compile("[^" + this.f3[i].charAt(0) + "]G");
                for (int j = 0; j < this.f3.length; j++) {
                    if (p2.matcher(this.f3[j]).matches()) {
                        return false;
                    }
                }
            }
        }

        outerloop2:
        for (int i=0; i<this.f2.length; i++) {
            if (this.f2[i].charAt(1) == 'M') {
                Pattern p1 = Pattern.compile(this.f2[i].charAt(0) + "G");
                for (int j = 0; j < this.f2.length; j++) {
                    if (p1.matcher(this.f2[j]).matches()) {
                        continue outerloop2;
                    }
                }
                Pattern p2 = Pattern.compile("[^" + this.f2[i].charAt(0) + "]G");
                for (int j = 0; j < this.f2.length; j++) {
                    if (p2.matcher(this.f2[j]).matches()) {
                        return false;
                    }
                }
            }
        }

        outerloop1:
        for (int i=0; i<this.f1.length; i++) {
            if (this.f1[i].charAt(1) == 'M') {
                Pattern p1 = Pattern.compile(this.f1[i].charAt(0) + "G");
                for (int j = 0; j < this.f1.length; j++) {
                    if (p1.matcher(this.f1[j]).matches()) {
                        continue outerloop1;
                    }
                }
                Pattern p2 = Pattern.compile("[^" + this.f1[i].charAt(0) + "]G");
                for (int j = 0; j < this.f1.length; j++) {
                    if (p2.matcher(this.f1[j]).matches()) {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    private int getT() {
        return this.l + this.f3.length + 2*this.f2.length + 3*this.f1.length;
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
        sc.close(); //input file not used in this exericse, we hard code the input

        //all.put(0, new Node(new String[]{}, new String[]{"LG"}, new String[]{"HG"}, new String[]{"HM", "LM"}, 1, 0, -1));
        //leaves.put(0, new Node(new String[]{}, new String[]{"LG"}, new String[]{"HG"}, new String[]{"HM", "LM"}, 1, 0, -1));

        all.put(0, new Node(new String[]{}, new String[]{"TM"}, new String[]{"TG", "RG", "RM", "CG", "CM"}, new String[]{"SG", "SM", "PG", "PM"}, 1, 0, -1));
        leaves.put(0, new Node(new String[]{}, new String[]{"TM"}, new String[]{"TG", "RG", "RM", "CG", "CM"}, new String[]{"SG", "SM", "PG", "PM"}, 1, 0, -1));

        int counter = 1;

        while (true) {
            int smallest_t = Integer.MAX_VALUE;
            int smallest_n = -1;

            for (Map.Entry<Integer, Node> entry : leaves.entrySet()) {
                if (entry.getValue().t < smallest_t) {
                    smallest_t = entry.getValue().t;
                    smallest_n = entry.getKey();
                }
            }

            Node current = leaves.get(smallest_n);
            System.out.println(current.l);

            if (current.e==4 && current.f1.length==0 && current.f2.length==0 && current.f3.length==0) {
                System.out.println("1. minimum number of steps: " + current.l);
                break;
            }

            ArrayList<Node> newOnes;
            ArrayList<String[]> one;
            ArrayList<String[]> two;

            switch (current.e) {
                case 1:
                    newOnes = new ArrayList<>();

                    one = getCombinations(current.f1, 1);

                    for (int i = 0; i < one.size(); i++) { //up (will also need for down)
                        String[] f4 = current.f4.clone();
                        String[] f3 = current.f3.clone();
                        String[] f2 = new String[current.f2.length + 1];
                        for (int j = 0; j < current.f2.length; j++) {
                            f2[j] = current.f2[j];
                        }
                        f2[f2.length - 1] = one.get(i)[0];
                        String[] f1 = new String[current.f1.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f1.length; j++) {
                            if (!current.f1[j].equals(one.get(i)[0])) {
                                f1[j_index] = current.f1[j];
                                j_index++;
                            }
                        }

                        Node candidate = new Node(f4, f3, f2, f1, 2, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }

                    if (current.f1.length >= 2) {
                        two = getCombinations(current.f1, 2);

                        for (int i = 0; i < two.size(); i++) { //up (will also need for down
                            String[] f4 = current.f4.clone();
                            String[] f3 = current.f3.clone();
                            String[] f2 = new String[current.f2.length + 2];
                            for (int j = 0; j < current.f2.length; j++) {
                                f2[j] = current.f2[j];
                            }
                            f2[f2.length - 2] = two.get(i)[0];
                            f2[f2.length - 1] = two.get(i)[1];
                            String[] f1 = new String[current.f1.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f1.length; j++) {
                                if (!current.f1[j].equals(two.get(i)[0]) && !current.f1[j].equals(two.get(i)[1])) {
                                    f1[j_index] = current.f1[j];
                                    j_index++;
                                }
                            }

                            Node candidate = new Node(f4, f3, f2, f1, 2, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                    }

                    for (int i = 0; i < newOnes.size(); i++) {
                        all.put(counter, newOnes.get(i));
                        leaves.put(counter++, newOnes.get(i));
                    }
                    leaves.remove(smallest_n);
                    break;
                case 2:
                    newOnes = new ArrayList<>();

                    one = getCombinations(current.f2, 1);

                    for (int i = 0; i < one.size(); i++) { //up
                        String[] f4 = current.f4.clone();
                        String[] f3 = new String[current.f3.length + 1];
                        for (int j = 0; j < current.f3.length; j++) {
                            f3[j] = current.f3[j];
                        }
                        f3[f3.length - 1] = one.get(i)[0];
                        String[] f2 = new String[current.f2.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f2.length; j++) {
                            if (!current.f2[j].equals(one.get(i)[0])) {
                                f2[j_index] = current.f2[j];
                                j_index++;
                            }
                        }
                        String[] f1 = current.f1.clone();

                        Node candidate = new Node(f4, f3, f2, f1, 3, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }
                    for (int i = 0; i < one.size(); i++) { //down
                        String[] f4 = current.f4.clone();
                        String[] f3 = current.f3.clone();
                        String[] f2 = new String[current.f2.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f2.length; j++) {
                            if (!current.f2[j].equals(one.get(i)[0])) {
                                f2[j_index] = current.f2[j];
                                j_index++;
                            }
                        }
                        String[] f1 = new String[current.f1.length + 1];
                        for (int j = 0; j < current.f1.length; j++) {
                            f1[j] = current.f1[j];
                        }
                        f1[f1.length - 1] = one.get(i)[0];


                        Node candidate = new Node(f4, f3, f2, f1, 1, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }

                    if (current.f2.length >= 2) {
                        two = getCombinations(current.f2, 2);

                        for (int i = 0; i < two.size(); i++) { //up
                            String[] f4 = current.f4.clone();
                            String[] f3 = new String[current.f3.length + 2];
                            for (int j = 0; j < current.f3.length; j++) {
                                f3[j] = current.f3[j];
                            }
                            f3[f3.length - 2] = two.get(i)[0];
                            f3[f3.length - 1] = two.get(i)[1];
                            String[] f2 = new String[current.f2.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f2.length; j++) {
                                if (!current.f2[j].equals(two.get(i)[0]) && !current.f2[j].equals(two.get(i)[1])) {
                                    f2[j_index] = current.f2[j];
                                    j_index++;
                                }
                            }
                            String[] f1 = current.f1.clone();

                            Node candidate = new Node(f4, f3, f2, f1, 3, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                        for (int i = 0; i < two.size(); i++) { //down
                            String[] f4 = current.f4.clone();
                            String[] f3 = current.f3.clone();
                            String[] f2 = new String[current.f2.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f2.length; j++) {
                                if (!current.f2[j].equals(two.get(i)[0]) && !current.f2[j].equals(two.get(i)[1])) {
                                    f2[j_index] = current.f2[j];
                                    j_index++;
                                }
                            }
                            String[] f1 = new String[current.f1.length + 2];
                            for (int j = 0; j < current.f1.length; j++) {
                                f1[j] = current.f1[j];
                            }
                            f1[f1.length - 2] = two.get(i)[0];
                            f1[f1.length - 1] = two.get(i)[1];


                            Node candidate = new Node(f4, f3, f2, f1, 1, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                    }

                    for (int i = 0; i < newOnes.size(); i++) {
                        all.put(counter, newOnes.get(i));
                        leaves.put(counter++, newOnes.get(i));
                    }
                    leaves.remove(smallest_n);
                    break;
                case 3:
                    newOnes = new ArrayList<>();

                    one = getCombinations(current.f3, 1);

                    for (int i = 0; i < one.size(); i++) { //up
                        String[] f4 = new String[current.f4.length + 1];
                        for (int j = 0; j < current.f4.length; j++) {
                            f4[j] = current.f4[j];
                        }
                        f4[f4.length - 1] = one.get(i)[0];
                        String[] f3 = new String[current.f3.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f3.length; j++) {
                            if (!current.f3[j].equals(one.get(i)[0])) {
                                f3[j_index] = current.f3[j];
                                j_index++;
                            }
                        }
                        String[] f2 = current.f2.clone();
                        String[] f1 = current.f1.clone();

                        Node candidate = new Node(f4, f3, f2, f1, 4, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }
                    for (int i = 0; i < one.size(); i++) { //down
                        String[] f4 = current.f4.clone();
                        String[] f3 = new String[current.f3.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f3.length; j++) {
                            if (!current.f3[j].equals(one.get(i)[0])) {
                                f3[j_index] = current.f3[j];
                                j_index++;
                            }
                        }
                        String[] f2 = new String[current.f2.length + 1];
                        for (int j = 0; j < current.f2.length; j++) {
                            f2[j] = current.f2[j];
                        }
                        f2[f2.length - 1] = one.get(i)[0];
                        String[] f1 = current.f1.clone();


                        Node candidate = new Node(f4, f3, f2, f1, 2, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }

                    if (current.f3.length >= 2) {
                        two = getCombinations(current.f3, 2);

                        for (int i = 0; i < two.size(); i++) { //up
                            String[] f4 = new String[current.f4.length + 2];
                            for (int j = 0; j < current.f4.length; j++) {
                                f4[j] = current.f4[j];
                            }
                            f4[f4.length - 2] = two.get(i)[0];
                            f4[f4.length - 1] = two.get(i)[1];
                            String[] f3 = new String[current.f3.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f3.length; j++) {
                                if (!current.f3[j].equals(two.get(i)[0]) && !current.f3[j].equals(two.get(i)[1])) {
                                    f3[j_index] = current.f3[j];
                                    j_index++;
                                }
                            }
                            String[] f2 = current.f2.clone();
                            String[] f1 = current.f1.clone();

                            Node candidate = new Node(f4, f3, f2, f1, 4, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                        for (int i = 0; i < two.size(); i++) { //down
                            String[] f4 = current.f4.clone();
                            String[] f3 = new String[current.f3.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f3.length; j++) {
                                if (!current.f3[j].equals(two.get(i)[0]) && !current.f3[j].equals(two.get(i)[1])) {
                                    f3[j_index] = current.f3[j];
                                    j_index++;
                                }
                            }
                            String[] f2 = new String[current.f2.length + 2];
                            for (int j = 0; j < current.f2.length; j++) {
                                f2[j] = current.f2[j];
                            }
                            f2[f2.length - 2] = two.get(i)[0];
                            f2[f2.length - 1] = two.get(i)[1];
                            String[] f1 = current.f1.clone();


                            Node candidate = new Node(f4, f3, f2, f1, 2, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                    }

                    for (int i = 0; i < newOnes.size(); i++) {
                        all.put(counter, newOnes.get(i));
                        leaves.put(counter++, newOnes.get(i));
                    }
                    leaves.remove(smallest_n);
                    break;
                case 4:
                    newOnes = new ArrayList<>();

                    one = getCombinations(current.f4, 1);

                    for (int i = 0; i < one.size(); i++) { //down
                        String[] f4 = new String[current.f4.length - 1];
                        int j_index = 0;
                        for (int j = 0; j < current.f4.length; j++) {
                            if (!current.f4[j].equals(one.get(i)[0])) {
                                f4[j_index] = current.f4[j];
                                j_index++;
                            }
                        }
                        String[] f3 = new String[current.f3.length + 1];
                        for (int j = 0; j < current.f3.length; j++) {
                            f3[j] = current.f3[j];
                        }
                        f3[f3.length - 1] = one.get(i)[0];
                        String[] f2 = current.f2.clone();
                        String[] f1 = current.f1.clone();

                        Node candidate = new Node(f4, f3, f2, f1, 3, current.l + 1, smallest_n);
                        if (candidate.legit) {
                            newOnes.add(candidate);
                        }
                    }

                    if (current.f4.length >= 2) {
                        two = getCombinations(current.f4, 2);

                        for (int i = 0; i < two.size(); i++) { //down
                            String[] f4 = new String[current.f4.length - 2];
                            int j_index = 0;
                            for (int j = 0; j < current.f4.length; j++) {
                                if (!current.f4[j].equals(two.get(i)[0]) && !current.f4[j].equals(two.get(i)[1])) {
                                    f4[j_index] = current.f4[j];
                                    j_index++;
                                }
                            }
                            String[] f3 = new String[current.f3.length + 2];
                            for (int j = 0; j < current.f3.length; j++) {
                                f3[j] = current.f3[j];
                            }
                            f3[f3.length - 2] = two.get(i)[0];
                            f3[f3.length - 1] = two.get(i)[1];
                            String[] f2 = current.f2.clone();
                            String[] f1 = current.f1.clone();

                            Node candidate = new Node(f4, f3, f2, f1, 3, current.l + 1, smallest_n);
                            if (candidate.legit) {
                                newOnes.add(candidate);
                            }
                        }
                    }

                    for (int i = 0; i < newOnes.size(); i++) {
                        Node n = newOnes.get(i);
                        boolean exists = false;
                        for (Map.Entry<Integer, Node> existent : all.entrySet()) {
                            Node already = existent.getValue();
                            if (Arrays.equals(n.f4, already.f4) &&
                                    Arrays.equals(n.f3, already.f3) &&
                                    Arrays.equals(n.f2, already.f2) &&
                                    Arrays.equals(n.f1, already.f1) &&
                                    n.e == already.e) {
                                exists = true;
                            }
                        }
                        if (!exists) {
                            all.put(counter, newOnes.get(i));
                            leaves.put(counter++, newOnes.get(i));
                        }
                    }
                    leaves.remove(smallest_n);
                    break;
            }
        }

        //till now is one iteration (i think) now we just put this in a while loop


        /*
        a) crate starting node and put it into leaves (and all)
        b) get combinations of the floor with the elevator (1 and 2)
        c) make nodes from combinations for elevator up and down (if possible)
        d) keep all legit nodes and put them into leaves
        e) remove current node from leaves
        f) find the node in leaves with the smallest total
        g) use that node as the new current
        h) repeat b) -> until you find the last node (e=4, all on f4)
        i) return number of counter (same as l of final node)
         */


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
