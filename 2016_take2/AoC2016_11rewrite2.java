import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;

class Node {
    public boolean[][] s; //state
    //0-3 for floors 1-4 [CG, CC, PG, PC, RG, RC, SG, SC, TG, TC]
    public int e; //elevator
    public int pathLen;

    public Node(boolean[][] state, int elevator, int pathLength) {
        this.s = state;
        this.e = elevator;
        this.pathLen = pathLength;
    }

    public boolean checkLegal() {
        for (int i=0; i<this.s.length; i++) { //for every floor
            for (int j=1; j<this.s[i].length; j+=2) { //for every chip (odd)
                if (this.s[i][j]) { //if chip pressent
                    if (!this.s[i][j-1]) { //if accompanying generator not pressent (format is always generatorA, chipA, generatorB, chipB, ...)
                        for (int k=0; k<this.s[i].length; k+=2) { //for every generator (even)
                            if (this.s[i][k]) { // if any generator pressent (cant be accompanying - we already checked)
                                return false; //we have a false state (fried chip)
                            }
                        }
                    }
                }
            }
        }
        return true; ///if we dont trip anywhere, we have legal state
    }

    public boolean checkGoal() {
        if (this.e!=3) {
            return false;
        } else {
            for (int i=0; i<this.s[0].length; i++) { //for every cell in a floor
                if (!this.s[this.s.length-1][i]) { //if any of the items in the last floor is not pressent
                    return false;
                }
            }
        }
        return true; //if we dont trip anywhere, we have goal state
    }

    public String getSignature() {
        String output = "";
        output += this.e; //first we add current floor number to the output
        for (int j=0; j<this.s[0].length; j++) { //for every cell
            for (int i=0; i<this.s.length; i++) { //for every floor
                if (this.s[i][j]) { //if element is here
                    output += i; //we add the floor number to the output
                }
            }
        }
        return output;
    }
}

class AoC2016_11rewrite2 {
    public static ArrayList<ArrayList<Node>> makeMoves(Node n) {
        ArrayList<ArrayList<Node>> output = new ArrayList<ArrayList<Node>>(); //always 4 inner Node[] inside Node[][] (up1, up2, down1, down2) (their individual lenghts are different)
        ArrayList<Node> up1 = new ArrayList<>();
        ArrayList<Node> up2 = new ArrayList<>();
        ArrayList<Node> down1 = new ArrayList<>();
        ArrayList<Node> down2 = new ArrayList<>();
        int e = n.e; //so we dont call it all the time (not really necessary)

        switch(e) {
            case 0: //first floor, up only (one or two)
                //for one
                for (int i=0; i<n.s[e].length; i++) { //for every cell on current floor
                    if (n.s[e][i]) { //if object is pressent
                        boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create a copy of current state
                        for (int x=0; x<n.s.length; x++) {
                            for (int y=0; y<n.s[x].length; y++) {
                                mod1[x][y] = n.s[x][y];
                            }
                        }

                        mod1[e][i] = false; //we modify, and add new element for up (we can only go up)
                        mod1[e+1][i] = true;
                        up1.add(new Node(mod1, e+1, n.pathLen+1));
                    }
                }


                //for two
                for (int i=0; i<n.s[e].length; i++) {
                    for (int j=i+1; j<n.s[e].length; j++) { //for every combination of two cells
                        if (n.s[e][i] && n.s[e][j]) { //if both object pressent
                            boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create a copy of current state
                            for (int x=0; x<n.s.length; x++) {
                                for (int y=0; y<n.s[x].length; y++) {
                                    mod1[x][y] = n.s[x][y];
                                }
                            }

                            mod1[e][i] = false; //we modify both elements and add new Node them to up (we can only go up)
                            mod1[e+1][i] = true;
                            mod1[e][j] = false;
                            mod1[e+1][j] = true;
                            up2.add(new Node(mod1, e+1, n.pathLen+1));
                        }
                    }
                }
                
                break;

            case 1: //second floor, up or down (one or two)
                //for one
                for (int i=0; i<n.s[e].length; i++) { //for every cell on current floor
                    if (n.s[e][i]) { //if object is pressent
                        boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create two copies of current state (otherwise the second oen affects the first (dont really know why??? (proabylby because Node.s is public)))
                        boolean[][] mod2 = new boolean[n.s.length][n.s[e].length];
                        for (int x=0; x<n.s.length; x++) {
                            for (int y=0; y<n.s[x].length; y++) {
                                mod1[x][y] = n.s[x][y];
                                mod2[x][y] = n.s[x][y];
                            }
                        }

                        mod1[e][i] = false; //we modify, and add new element for up
                        mod1[e+1][i] = true;
                        up1.add(new Node(mod1, e+1, n.pathLen+1));

                        mod2[e][i] = false; //we do the same for down
                        mod2[e-1][i] = true;
                        down1.add(new Node(mod2, e-1, n.pathLen+1));
                    }
                }


                //for two
                for (int i=0; i<n.s[e].length; i++) {
                    for (int j=i+1; j<n.s[e].length; j++) { //for every combination of two cells
                        if (n.s[e][i] && n.s[e][j]) { //if both object pressent
                            boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create two copies of current state
                            boolean[][] mod2 = new boolean[n.s.length][n.s[e].length];
                            for (int x=0; x<n.s.length; x++) {
                                for (int y=0; y<n.s[x].length; y++) {
                                    mod1[x][y] = n.s[x][y];
                                    mod2[x][y] = n.s[x][y];
                                }
                            }

                            mod1[e][i] = false; //we modify both elements and add new Node them to up
                            mod1[e+1][i] = true;
                            mod1[e][j] = false;
                            mod1[e+1][j] = true;
                            up2.add(new Node(mod1, e+1, n.pathLen+1));

                            mod2[e][i] = false; //we do the same for down
                            mod2[e-1][i] = true;
                            mod2[e][j] = false;
                            mod2[e-1][j] = true;
                            down2.add(new Node(mod2, e-1, n.pathLen+1));
                        }
                    }
                }

                break;

            case 2: //third floor, up or down (one or two)
                //for one
                for (int i=0; i<n.s[e].length; i++) { //for every cell on current floor
                    if (n.s[e][i]) { //if object is pressent
                        boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create two copies of current state
                        boolean[][] mod2 = new boolean[n.s.length][n.s[e].length];
                        for (int x=0; x<n.s.length; x++) {
                            for (int y=0; y<n.s[x].length; y++) {
                                mod1[x][y] = n.s[x][y];
                                mod2[x][y] = n.s[x][y];
                            }
                        }

                        mod1[e][i] = false; //we modify, and add new element for up
                        mod1[e+1][i] = true;
                        up1.add(new Node(mod1, e+1, n.pathLen+1));

                        mod2[e][i] = false; //we do the same for down
                        mod2[e-1][i] = true;
                        down1.add(new Node(mod2, e-1, n.pathLen+1));
                    }
                }


                //for two
                for (int i=0; i<n.s[e].length; i++) {
                    for (int j=i+1; j<n.s[e].length; j++) { //for every combination of two cells
                        if (n.s[e][i] && n.s[e][j]) { //if both object pressent
                            boolean[][] mod1 = new boolean[n.s.length][n.s[e].length]; //we create two copies of current state
                            boolean[][] mod2 = new boolean[n.s.length][n.s[e].length];
                            for (int x=0; x<n.s.length; x++) {
                                for (int y=0; y<n.s[x].length; y++) {
                                    mod1[x][y] = n.s[x][y];
                                    mod2[x][y] = n.s[x][y];
                                }
                            }

                            mod1[e][i] = false; //we modify both elements and add new Node them to up
                            mod1[e+1][i] = true;
                            mod1[e][j] = false;
                            mod1[e+1][j] = true;
                            up2.add(new Node(mod1, e+1, n.pathLen+1));

                            mod2[e][i] = false; //we do the same for down
                            mod2[e-1][i] = true;
                            mod2[e][j] = false;
                            mod2[e-1][j] = true;
                            down2.add(new Node(mod2, e-1, n.pathLen+1));
                        }
                    }
                }
                
                break;
            
            case 3: //fourth floor, up or down (one or two)
                //for one
                for (int i=0; i<n.s[e].length; i++) { //for every cell on current floor
                    if (n.s[e][i]) { //if object is pressent
                        boolean[][] mod2 = new boolean[n.s.length][n.s[e].length]; //we create a copy of current state
                        for (int x=0; x<n.s.length; x++) {
                            for (int y=0; y<n.s[x].length; y++) {
                                mod2[x][y] = n.s[x][y];
                            }
                        }

                        mod2[e][i] = false; //we can only go down
                        mod2[e-1][i] = true;
                        down1.add(new Node(mod2, e-1, n.pathLen+1));
                    }
                }

                //for two
                for (int i=0; i<n.s[e].length; i++) {
                    for (int j=i+1; j<n.s[e].length; j++) { //for every combination of two cells
                        if (n.s[e][i] && n.s[e][j]) { //if both object pressent
                            boolean[][] mod2 = new boolean[n.s.length][n.s[e].length]; //we create a copy of current state
                            for (int x=0; x<n.s.length; x++) {
                                for (int y=0; y<n.s[x].length; y++) {
                                    mod2[x][y] = n.s[x][y];
                                }
                            }

                            mod2[e][i] = false; //we can only go down
                            mod2[e-1][i] = true;
                            mod2[e][j] = false;
                            mod2[e-1][j] = true;
                            down2.add(new Node(mod2, e-1, n.pathLen+1));
                        }
                    }
                }
                
                break;
        }

        output.add(up1);
        output.add(up2);
        output.add(down1);
        output.add(down2);

        return output;
        //we don't prune illegal states here, so we can insure we don't have up1 and down1 empty on floors 1 and 2 (second and third) because we use this fact as a floor determiner in pruneMoves()
    }

    public static ArrayList<String> pairs(String prefix, String str, ArrayList<String> perms) {
        if (str.length()<4) { //if we have less than two pairs (4 itmes) we cant make a swap
            perms.add(prefix + str); //so we add this complete permutation to perms and return
        } else { //else, we go over each pair (i+=2) and call this function again with extended prefix (old + current pair) and a new string (excluding current pair)
            for (int i=0; i<str.length(); i+=2) {
                perms = pairs(prefix + str.substring(i, i+2), str.substring(0, i) + str.substring(i+2), perms); //we add it to perms
            }
        }
        return perms;
    }

    public static Node[] pruneMoves(HashSet<String> visited, ArrayList<ArrayList<Node>> moves) {
        //moves format: [[up1], [up2], [down1], [down2]]

        //check if even legal
        for (int i=0; i<moves.size(); i++) { //for every combo (up1, up2, down1, down2)
            ArrayList<Node> combo = moves.get(i);
            int j=0;
            while (j<combo.size()) { //for every (new) Node within that combo
                if (!combo.get(j).checkLegal()) { //if Node not legal, we remove it
                    combo.remove(j);
                } else { //if it is legal, we continue to the next one
                    j++;
                }
            }
        }

        /*//check if already visited //THIS SHOULD BE DONE WITH HashSet (but cant be done if visited is int[], maybe too string???)
        for (int k=0; k<visited.size(); k++) { //for every element in visited
            int[] v = visited.get(k);
            for (int i=0; i<moves.size(); i++) { //for every combo (up1, up2, down1, down2)
                ArrayList<Node> combo = moves.get(i);
                int j=0;
                while (j<combo.size()) { //for every (new) Node within that combo
                    if (Arrays.equals(v, combo.get(j).getAll())) { //if new node equal to some already visited, we delete it
                        combo.remove(j);
                    } else { //else, we go to the next one
                        j++;
                    }
                }
            }
        }
        //this does work, but very slow, and it doesnt get any faster the longer it runs
        */

        //check if already visisted
        for (int i=0; i<moves.size(); i++) { //for every combo (up1, up2, down1, down2)
            ArrayList<Node> combo = moves.get(i);
            int j = 0;
            while (j<combo.size()) { //for every (new) Node within that combo
                if (visited.contains(combo.get(j).getSignature())) { //if visited already contains the signiture of new node, we remove it
                    combo.remove(j);
                } else { //else, we move to the next one
                    j++;
                }
            }
        }
        //this is blazzing fast compared to the upper approach

        //extra optimizations
        /* a)
        If you can move two items upstairs, don't bother bringing one item upstaris.
        If you can move one item downstairs, don't bother bringing two items downstairs.
        (but still try to move items downstaris even if you can move items upstaris)
        */
        if (moves.get(1).size()>0) { //if we can move two items up (up2), dont bother bringing one item up
            for (int i=0; i<moves.get(0).size(); i++) { //we remove all up1
                moves.get(0).remove(0); //we always remove first one, but too it len times
            }
        }

        if (moves.get(2).size()>0) { //if we can move one item down (down1), dont bother brigin two items down
            for (int i=0; i<moves.get(3).size(); i++) {
                moves.get(3).remove(0);
            }
        }

        /*b
        All pairs are interchangeable
        the following two states are equivalent:
        HG@0, HC@1, LG@2, LC@2
        LG@0, LC@1, HG@2, HC@2
        (=HG@2, HC@2, LG@0, LC@1)
        prune any state equivalent to (not just equal to) a state you have already seen!
        */
        for (int i=0; i<moves.size(); i++) { //for every combo (up1, up2, down1, down2)
            ArrayList<Node> combo = moves.get(i);
            int j=0;
            while (j<combo.size()) { //for every (new) Node within that combo
                String sig = combo.get(j).getSignature();

                ArrayList<String> perms = pairs("", sig.substring(1), new ArrayList<String>()); //we create all mirrors of the state (all pairs are interchangeable) (substring is to remove the elevator number)
                boolean match = false;

                for (int k=0; k<perms.size(); k++) {
                    if (visited.contains(sig.charAt(0) + perms.get(k))) { //we add the elevator back
                        match = true;
                    }
                }

                if (match) {
                    combo.remove(j);
                } else {
                    j++;
                }
            }
        }

        //ANOTHER  OPTIMIZATIN: DO EVERYTHING UNDER ONE FOR-WHILE LOOP NEST (NOT EVERY THING UNDER ITS OWN)

        int counter = 0;
        for (int i=0; i<moves.size(); i++) {
            ArrayList<Node> combo = moves.get(i);
            for (int j=0; j<combo.size(); j++) {
                counter++;
            }
        }

        Node[] output = new Node[counter];
        
        counter = 0;
        for (int i=0; i<moves.size(); i++) {
            ArrayList<Node> combo = moves.get(i);
            for (int j=0; j<combo.size(); j++) {
                output[counter++] = combo.get(j);
            }
        }

        return output;
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();

        //vars
        boolean[][] input = new boolean[4][10]; //reserve space for table //TO BE CHANGED TO [4][10] (or [4][14])
        //0-3 for floors 1-4 [CG, CC, PG, PC, RG, RC, SG, SC, TG, TC]
        int elevator = 0;
        LinkedList<Node> queue = new LinkedList<>();
        HashSet<String> visited = new HashSet<>();
        boolean found = false;

        //even tho we have input file, we wont use it, we will just hard-code the input into input array

        /* //input
        The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
        The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
        The third floor contains a thulium-compatible microchip.
        The fourth floor contains nothing relevant.
        */
        
        input[0][6] = true; //SG
        input[0][7] = true; //SC
        input[0][2] = true; //PG
        input[0][3] = true; //PC
        input[1][8] = true; //TG
        input[1][4] = true; //RG
        input[1][5] = true; //RC
        input[1][0] = true; //CG
        input[1][1] = true; //CC
        input[2][9] = true; //TC

        
        Node root = new Node(input, elevator, 0);

        queue.add(root);
        visited.add(root.getSignature());

        while (!found) {
            //System.out.println(visited.size());

            ArrayList<ArrayList<Node>> moves = makeMoves(queue.remove()); //we make all possible moves
            //<<up1>, <up2>, <down1>, <down2>>

            Node[] pruned = pruneMoves(visited, moves); //we remove the illegal and repeating moves

            for (int i=0; i<pruned.length; i++) { //we add them to queue and to visited locations
                queue.add(pruned[i]);
                visited.add(pruned[i].getSignature());

                if (pruned[i].checkGoal()) { //if we got to the end, we output and end
                    System.out.println("1. number of steps to solve: " + pruned[i].pathLen);
                    found = true;
                }
            }
        }

         //FOR TESTING
        //second part (works but takes like 5 mins)
        //we do the same thing as for part 1, just a little bigger
        boolean[][] input2 = new boolean[4][14];
        //0-3 for floors 1-4 [CG, CC, PG, PC, RG, RC, SG, SC, TG, TC, EG, EC, DG, DC]
        int elevator2 = 0;
        LinkedList<Node> queue2 = new LinkedList<>();
        HashSet<String> visited2 = new HashSet<>();
        boolean found2 = false;

        input2[0][6] = true; //SG
        input2[0][7] = true; //SC
        input2[0][2] = true; //PG
        input2[0][3] = true; //PC
        input2[1][8] = true; //TG
        input2[1][4] = true; //RG
        input2[1][5] = true; //RC
        input2[1][0] = true; //CG
        input2[1][1] = true; //CC
        input2[2][9] = true; //TC

        input2[0][10] = true; //EG //and add the new items
        input2[0][11] = true; //EC
        input2[0][12] = true; //DG
        input2[0][13] = true; //DC


        Node root2 = new Node(input2, elevator2, 0);

        queue2.add(root2);
        visited2.add(root2.getSignature());

        while (!found2) {

            ArrayList<ArrayList<Node>> moves = makeMoves(queue2.remove());

            Node[] pruned = pruneMoves(visited2, moves);

            for (int i=0; i<pruned.length; i++) {
                queue2.add(pruned[i]);
                visited2.add(pruned[i].getSignature());

                if (pruned[i].checkGoal()) {
                    System.out.println("2. number of steps to solve with extra objects: " + pruned[i].pathLen);
                    found2 = true;
                }
            }
        }
        

        //TO-DO
        //pruneMoves could be optimized, but aint nobody got time for that


        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}