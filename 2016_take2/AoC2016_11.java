import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Scanner;

class Node {
    public boolean[][] state;
    //0-3 for floors 1-4, [hgen, hchip, lgen, lchip];
    public Node parent;
    public int e;
    public int pathLen;

    public Node(boolean[][] s, int e) {
        this.state = s;
        this.e = e;
    }

    public boolean checkLegal() {
        for (int i=0; i<this.state.length; i++) { //for every floor
            for (int j=1; j<this.state[i].length; j+=2) { //for every chip
                if (this.state[i][j]) { //if chip pressent
                    if (!this.state[i][j-1]) { //if not accompanying generator
                        for (int k=0; k<this.state[i].length; k+=2) {
                            if (this.state[i][k]) { //if any other generator pressent, we have false state
                                return false;
                            }
                        }
                    } else { //we have accompaning generator pressent, so this chip is safe
                        continue;
                    }
                }
            }
        }

        /*Node grandParent = this.parent.parent;
        if (Arrays.deepEquals(this.state, grandParent.state) && this.e==grandParent.e) { //if this node is same as its grandparent (we just made a step forward and a step back) we have a false state
            return false;
        }*/

        return true;
    }

    public boolean checkGoal() {
        if (this.e!=3) { //if elevator not on the last floor
            return false;
        } else {
            for (int i=0; i<this.state[3].length; i++) {
                if (!this.state[3][i]) { //if any of the items in not on the fourth floor
                    return false;
                }
            }
        }
        return true;
    }

    public int[] getAll() {
        int[] output = new int[5];
        output[0] = this.e;
        for (int j=0; j<this.state[0].length; j++) {
            for (int i=0; i<this.state.length; i++) {
                if (this.state[i][j]) {
                    output[j+1] = i;
                }
            }
        }
        
        return output;
    }
}

class AoC2016_11 {
    public static ArrayList<Node> makeMove (Node n) {
        ArrayList<Node> temp = new ArrayList<>();
        //boolean[][] s = n.state; // NOT A GOOD COPY (NEED FOR-FOR LOOP) ((is this even needed???))
        int e = n.e;
        
        switch(e) {
            case 0: //first floor, only up (one or two)
                for (int i=0; i<n.state[e].length; i++) {
                    if (n.state[e][i]) { //if it is pressent
                        boolean[][] mod = new boolean[n.state.length][n.state[0].length]; //we create a copy of current state
                        for (int x=0; x<n.state.length; x++) {
                            for (int y=0; y<n.state[i].length; y++) {
                                mod[x][y] = n.state[x][y];
                            }
                        }

                        mod[e][i] = false; //we change the choosen elements to the next state
                        mod[e+1][i] = true;
                        Node modified = new Node(mod, e+1); //we create a new node and add the curret node as a parent
                        modified.parent = n;
                        modified.pathLen = n.pathLen+1;
                        temp.add(modified); //we add it into temp (all possible (even if illegal) moves)
                    }
                }

                for (int i=0; i<n.state[e].length; i++) {
                    for (int j=i+1; j<n.state[e].length; j++) {
                        if (n.state[e][i] && n.state[e][j]) {
                            //need a modified copy of s (or n.state) and temp.add(new Node(modified, e+1))
                            boolean[][] mod = new boolean[n.state.length][n.state[e].length];
                            for (int x=0; x<n.state.length; x++) {
                                for (int y=0; y<n.state[i].length; y++) {
                                    mod[x][y] = n.state[x][y];
                                }
                            }

                            mod[e][i] = false; //we modify both elements
                            mod[e+1][i] = true;
                            mod[e][j] = false;
                            mod[e+1][j] = true;
                            Node modified = new Node(mod, e+1); //create new node and add n as a parent
                            modified.parent = n;
                            modified.pathLen = n.pathLen+1;
                            temp.add(modified); //and add it to temp
                        }
                    }
                }

                break;
            case 1: //second floor, up or down (one or two)
                for (int i=0; i<n.state[e].length; i++) {
                    if (n.state[e][i]) { //if it is pressent
                        boolean[][] mod = new boolean[n.state.length][n.state[0].length]; //we create a copy of current state
                        for (int x=0; x<n.state.length; x++) {
                            for (int y=0; y<n.state[i].length; y++) {
                                mod[x][y] = n.state[x][y];
                            }
                        }

                        mod[e][i] = false; //we modify, create and add the element for up
                        mod[e+1][i] = true;
                        Node modified1 = new Node(mod, e+1);
                        modified1.parent = n;
                        modified1.pathLen = n.pathLen+1;
                        temp.add(modified1);

                        mod[e+1][i] = false; //and than the same for down (including rollbacking the modification for up)
                        mod[e-1][i] = true;
                        Node modified2 = new Node(mod, e-1); //here e different)
                        modified2.parent = n;
                        modified2.pathLen = n.pathLen+1;
                        temp.add(modified2);

                    }
                }

                for (int i=0; i<n.state[e].length; i++) {
                    for (int j=i+1; j<n.state[e].length; j++) {
                        if (n.state[e][i] && n.state[e][j]) {
                            //need a modified copy of s (or n.state) and temp.add(new Node(modified, e+1))
                            boolean[][] mod = new boolean[n.state.length][n.state[e].length];
                            for (int x=0; x<n.state.length; x++) {
                                for (int y=0; y<n.state[i].length; y++) {
                                    mod[x][y] = n.state[x][y];
                                }
                            }

                            mod[e][i] = false; //we modify both elements, create node and add it to temp for up
                            mod[e+1][i] = true;
                            mod[e][j] = false;
                            mod[e+1][j] = true;
                            Node modified1 = new Node(mod, e+1);
                            modified1.parent = n;
                            modified1.pathLen = n.pathLen+1;
                            temp.add(modified1);

                            mod[e+1][i] = false; //and than we do the same for down (including rollbacking the modification for up)
                            mod[e-1][i] = true;
                            mod[e+1][j] = false;
                            mod[e-1][j] = true;
                            Node modified2 = new Node(mod, e-1); //here e different)
                            modified2.parent = n;
                            modified2.pathLen = n.pathLen+1;
                            temp.add(modified2);
                        }
                    }
                }

                break;

            case 2: //third floor, up or down (one or two)
                for (int i=0; i<n.state[e].length; i++) {
                    if (n.state[e][i]) { //if it is pressent
                        boolean[][] mod = new boolean[n.state.length][n.state[0].length]; //we create a copy of current state
                        for (int x=0; x<n.state.length; x++) {
                            for (int y=0; y<n.state[i].length; y++) {
                                mod[x][y] = n.state[x][y];
                            }
                        }

                        mod[e][i] = false; //we modify, create and add the element for up
                        mod[e+1][i] = true;
                        Node modified1 = new Node(mod, e+1);
                        modified1.parent = n;
                        modified1.pathLen = n.pathLen+1;
                        temp.add(modified1);

                        mod[e+1][i] = false; //and than the same for down (including rollbacking the modification for up)
                        mod[e-1][i] = true;
                        Node modified2 = new Node(mod, e-1); //here e different)
                        modified2.parent = n;
                        modified2.pathLen = n.pathLen+1;
                        temp.add(modified2);

                    }
                }

                for (int i=0; i<n.state[e].length; i++) {
                    for (int j=i+1; j<n.state[e].length; j++) {
                        if (n.state[e][i] && n.state[e][j]) {
                            //need a modified copy of s (or n.state) and temp.add(new Node(modified, e+1))
                            boolean[][] mod = new boolean[n.state.length][n.state[e].length];
                            for (int x=0; x<n.state.length; x++) {
                                for (int y=0; y<n.state[i].length; y++) {
                                    mod[x][y] = n.state[x][y];
                                }
                            }

                            mod[e][i] = false; //we modify both elements, create node and add it to temp for up
                            mod[e+1][i] = true;
                            mod[e][j] = false;
                            mod[e+1][j] = true;
                            Node modified1 = new Node(mod, e+1);
                            modified1.parent = n;
                            modified1.pathLen = n.pathLen+1;
                            temp.add(modified1);

                            mod[e+1][i] = false; //and than we do the same for down (including rollbacking the modification for up)
                            mod[e-1][i] = true;
                            mod[e+1][j] = false;
                            mod[e-1][j] = true;
                            Node modified2 = new Node(mod, e-1); //here e different)
                            modified2.parent = n;
                            modified2.pathLen = n.pathLen+1;
                            temp.add(modified2);
                        }
                    }
                }

                break;

            case 3: //fourth floor, only down (one or two)
                for (int i=0; i<n.state[e].length; i++) {
                    if (n.state[e][i]) { //if it is pressent
                        boolean[][] mod = new boolean[n.state.length][n.state[0].length]; //we create a copy of current state
                        for (int x=0; x<n.state.length; x++) {
                            for (int y=0; y<n.state[i].length; y++) {
                                mod[x][y] = n.state[x][y];
                            }
                        }

                        mod[e][i] = false; //we change the choosen elements to the next state
                        mod[e-1][i] = true;
                        Node modified = new Node(mod, e-1); //we create a new node and add the curret node as a parent
                        modified.parent = n;
                        modified.pathLen = n.pathLen+1;
                        temp.add(modified); //we add it into temp (all possible (even if illegal) moves)
                    }
                }

                for (int i=0; i<n.state[e].length; i++) {
                    for (int j=i+1; j<n.state[e].length; j++) {
                        if (n.state[e][i] && n.state[e][j]) {
                            //need a modified copy of s (or n.state) and temp.add(new Node(modified, e+1))
                            boolean[][] mod = new boolean[n.state.length][n.state[e].length];
                            for (int x=0; x<n.state.length; x++) {
                                for (int y=0; y<n.state[i].length; y++) {
                                    mod[x][y] = n.state[x][y];
                                }
                            }

                            mod[e][i] = false; //we modify both elements
                            mod[e-1][i] = true;
                            mod[e][j] = false;
                            mod[e-1][j] = true;
                            Node modified = new Node(mod, e-1); //create new node and add n as a parent
                            modified.parent = n;
                            modified.pathLen = n.pathLen+1;
                            temp.add(modified); //and add it to temp
                        }
                    }
                }

                break;
        }

        return temp;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        boolean[][] starting = new boolean[4][4];
        int elevator = 0;
        LinkedList<Node> queue = new LinkedList<>();
        boolean found = false;
        LinkedList<int[]> visited = new LinkedList<>();

        /* //even though we have a input file, we won't use it, we will just hard-code the input
        Scanner sc = new Scanner(new File("input2016_11.txt"));
        while (sc.hasNextLine()) {
            System.out.println(sc.nextLine());
        }
        sc.close();
        */
        
        //testing
        /*
        The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
        The second floor contains a hydrogen generator.
        The third floor contains a lithium generator.
        The fourth floor contains nothing relevant.
        */
        
        starting[0][1] = true;
        starting[0][3] = true;
        starting[1][0] = true;
        starting[2][2] = true;

        Node root = new Node(starting, elevator);
        root.parent = root;
        root.pathLen = 0;

        queue.add(root);

        //TO DELUJE EXTRA POČAS, PROBI MOGOČ NA KOMPU, ČE BO KEJ HITREJ, SAM DVOMM ZA VEČJI UNOS (treba proonant podobne pare)
        //maybe make note of [elevator,HGfloor, HCfloor, LGfloor, LCfloor] and if it already exists, we dont include it
        //on top if [e, x, y, z, q] exists, we dont include [e, z, q, x, y]
        for (int k=0; k<100; k++) {
            ArrayList<Node> move = makeMove(queue.peek());

            for (int i=0; i<move.size(); i++) {
                Node m = move.get(i);
                if (m.checkLegal()) {
                    boolean repeat = false;
                    int[] mSig = m.getAll();
                    int[] mMirror = new int[mSig.length];
                    mMirror[0] = mSig[0];
                    mMirror[1] = mSig[3];
                    mMirror[2] = mSig[4];
                    mMirror[3] = mSig[1];
                    mMirror[4] = mSig[2];
                    for (int j=0; j<visited.size(); j++) {
                        if (Arrays.equals(mSig, visited.get(j))) {
                            /*if (Arrays.equals(mMirror, visited.get(j))) {
                                repeat = true;
                            }*/
                            repeat = true;
                            System.out.println("already " + k +" "+ i);
                        }
                    }
                    if (!repeat) {
                        queue.add(m);
                        visited.add(m.getAll());
                    }
                }
                
                if (m.checkGoal()) {
                    System.out.println("1. the number of steps:" + m.pathLen);
                    found = true;
                }
            }
            queue.remove();
        }

        //idea: bfs with agressive pruning (even the mirrored pairs or states) using linkedlist of nodes / states
        //node (location of elevator, generators and chips, len from start, parent, heuristic)
        //(possible optimization is dijkstra or a*)

        //make all possible moves
        //keep only the legal ones (maybe even compare for pair mirroring, 1:hg,hc; 2:lg,lc === 1:lg,lc; 2:hg,hc)
        //put them to linkedlist
        //check if first in list is goal
        //repeat


        //NEKI NE DELA PROU, NEKI PREVEČ REŽE, SAM JE OBETAVNO


        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}