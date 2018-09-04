import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Stack;

class Room {
    public String text;
    public int x;
    public int y;

    public Room(String t, int x, int y) {
        this.text = t;
        this.x = x;
        this.y = y;
    }

    public boolean checkLegal() {
        if (this.x<0 || this.y<0 || this.x>3 || this.y>3) {
            return false;
        }
        return true;
    }

    public boolean checkGoal() {
        if (this.x==3 && this.y==3) {
            return true;
        }
        return false;
    }
}

class AoC2016_17 {
    public static ArrayList<Room> makeMove(Room r) throws NoSuchAlgorithmException {
        ArrayList<Room> output = new ArrayList<>();

        HashSet<Character> acceptableChars = new HashSet<>(); //we add acceptable chars (will use aC.contains)
        acceptableChars.add('b');
        acceptableChars.add('c');
        acceptableChars.add('d');
        acceptableChars.add('e');
        acceptableChars.add('f');

        //we create a hash of text of room
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(r.text.getBytes());
        byte[] digest = md.digest();

        char[] hexArray = "0123456789abcdef".toCharArray(); //more info in 2016_14.java
        char[] hexChars = new char[4]; //need only first 4 chars
        for (int i=0; i<2; i++) {
            int v = digest[i] & 0xff;
            hexChars[i * 2] = hexArray[v >>> 4];
            hexChars[i * 2 + 1] = hexArray[v & 0x0f];
        }
        String hexString = String.valueOf(hexChars);

        if (acceptableChars.contains(hexString.charAt(0))) { //for every direction, if char is acceptable, and if room at that position is legal, we add it to output
            Room up = new Room(r.text+"U", r.x, r.y-1);
            if (up.checkLegal()) {
                output.add(up);
            }
        }
        if (acceptableChars.contains(hexString.charAt(1))) {
            Room down = new Room(r.text+"D", r.x, r.y+1);
            if (down.checkLegal()) {
                output.add(down);
            }
        }
        if (acceptableChars.contains(hexString.charAt(2))) {
            Room left = new Room(r.text+"L", r.x-1, r.y);
            if (left.checkLegal()) {
                output.add(left);
            }
        }
        if (acceptableChars.contains(hexString.charAt(3))) {
            Room right = new Room(r.text+"R", r.x+1, r.y);
            if (right.checkLegal()) {
                output.add(right);
            }
        }

        return output;
    }

    public static void main(String[] args) throws NoSuchAlgorithmException {
        long startTime = System.nanoTime();

        //vars
        String input ="mmsxrhfx";
        Stack<Room> rooms = new Stack<>();
        String shortest = "";

        //second part
        String longest = ""; //could only use int to save length


        Room root = new Room(input, 0, 0); //we add the first room to the stack (we start at 0,0, need to get to 3,3)
        rooms.push(root);

        while (rooms.size()>0) {
            Room current = rooms.pop();

            if (current.checkGoal()) { //if current room is goal room, we check if shortest
                String temp = current.text.substring(input.length()); //text without the initial input (only path)
                if (shortest.length() == 0) { //if shortest not already set, we set it (same goes for longes, so no need to test)
                    shortest = temp;
                    
                    //second part
                    longest = temp;
                } else { //else, if current is shortest than previoust shortest, we set temp as new shortest
                    if (temp.length() < shortest.length()) {
                        shortest = temp;
                    }

                    //second part
                    if (temp.length() > longest.length()) {
                        longest = temp;
                    }
                }

                continue; //skip this iteration of while loop
            }
            
            ArrayList<Room> moves = makeMove(current); //we make all possible legal moves
            
            for (int i=0; i<moves.size(); i++) { //and add them to the stack
                rooms.push(moves.get(i));
            }
            
        }

        System.out.println("1. the shortest path to the vault: " + shortest);
        System.out.println("2. length of the longest path: " + longest.length());

        //idea: pop, checkgoal, make hash, make moves (with prune), push, repeat

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}