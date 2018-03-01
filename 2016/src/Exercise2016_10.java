import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

class Bot {
    private int value1;
    private int value2;
    private int low_to;
    private int low_bot; //-1=not set, 1=bot, 2=output
    private int high_to;
    private int high_bot;

    public Bot () { //constructor
        this.value1 = -1;
        this.value2 = -1;
        this.low_to = -1;
        this.low_bot = -1;
        this.high_to = -1;
        this.high_bot = -1;
    }

    public boolean setValue(int v) {
        if (this.value1 == -1) {
            this.value1 = v;
            //if full and has instructions -> compare, give out (if give -> return true)
            if (this.isFull() && this.hasInstructions()) {
                this.compare();
                return true;
            }
            return false;

        } else if (this.value2 == -1) {
            this.value2 = v;
            //if full and has instructions -> compare, give out (if give -> return true)
            if (this.isFull() && this.hasInstructions()) {
                this.compare();
                return true;
            }
            return false;

        } else {
            System.out.println("I'm sorry, Dave. I'm afraid I can't do that.");
            return false;
        }
    }

    public boolean setInstruction(int l, int lb, int h, int hb) {
        //should we check if already have instruction (can they overwrite each other, i guess yes)
        this.low_to = l;
        this.low_bot = lb;
        this.high_to = h;
        this.high_bot = hb;
        //if has instructions and is full -> compare, give out (if give -> return true)
        if (this.isFull() && this.hasInstructions()) {
            this.compare();
            return true;
        }
        return false;
    }

    public int[] getValues() {
        return new int[]{this.value1, this.value2};
    }

    public int[] getInstructions() {
        return new int[]{this.low_to, this.high_to};
    }

    public int[] getAll() {
        return new int[]{this.value1, this.value2, this.low_to, this.low_bot, this.high_to, this.high_bot};
    }

    public void setAll(int v1, int v2, int l, int lb, int h, int hb) {
        this.value1 = v1;
        this.value2 = v2;
        this.low_to = l;
        this.low_bot = lb;
        this.high_to = h;
        this.high_bot = hb;
    }

    private boolean isFull() {
        if (this.value1!=-1 && this.value2!=-1) {
            return true;
        }
        return false;
    }

    private boolean hasInstructions() {
        if (this.low_to!=-1 && this.high_to!=-1) {
            return true;
        }
        return false;
    }

    //compare (the comparision must be saved somehow)
        //idea: compare just rearanges the values (value1 = low, value2 = high)
    private void compare() {
        if (this.value1 > this.value2) {
            int temp = this.value1;
            this.value1 = this.value2;
            this.value2 = temp;
        }
    }

    //give (what if the bot we are giving to doesn't exist yet? -> must be implemented outiside)
        //give is implemented outside the class (here we just wipe the values and instructions)
        //outisde: gets values (remembers for comparison sake) and gives them to bots specified in instructions (if not exists makes new). after all we call give
    public void clear() {
        this.value1 = -1;
        this.value2 = -1;
        //do we clear the instructions as well???
        this.low_to = -1;
        this.high_to = -1;
    }
}

public class Exercise2016_10 {
    public static Map[] give(Map<Integer, Bot> bots, Map<Integer, ArrayList<Integer>> outputs, int b) { //recursively distributes the values
        int[] b_stats = bots.get(b).getAll();
        for (int i=0; i<b_stats.length; i++) {
            System.out.println(b_stats[i]);
        }

        return new Map[]{bots, outputs};
    }

    public static void main(String[] args) throws FileNotFoundException {
        /*
        idea:
        make a class of bot and make a map of all bots
        every bot has 2 values (low and high) and instruction who to give those values
        every bot can get values (probably if it doesn have both full)
        every bot can give values (only if both are full)
        trigger -> if filled up give them away / when get instruction, if have both give them away

        this can probaby be made with only map<bot number, [value1, value2, low_to, high_to] and metdods isFull, has instructions (but i want to practice oop)
         */

        ArrayList<String> input = new ArrayList<>();

        //starting vars
        Map<Integer, Bot> bots = new HashMap<>();
        Map<Integer, ArrayList<Integer>> outputs = new HashMap<>(); // maybe outputs in bots as negative number ?? (nah -0 is not valid)


        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();


        for (int i=0; i<input.size(); i++) {
            String[] line_array = input.get(i).split(" ");
            if (line_array.length == 6) {
                int b = Integer.parseInt(line_array[5]);
                int v = Integer.parseInt(line_array[1]);

                if (!bots.containsKey(b)) {
                    bots.put(b, new Bot());
                }

                boolean confirm = bots.get(b).setValue(v);

                if (confirm) { //this can trigger a domino effect (recursive method)
                    System.out.println("give ");
                    //Map[]{bots, outputs} = Give(bots, outputs, b, l, h); (and inside make sure the domino effect can be solved with recursion)
                    Map[] update = give(bots, outputs, b);
                    bots = update[0];
                    outputs = update[1];
                }

            } else {
                int b = Integer.parseInt(line_array[1]);
                int l = Integer.parseInt(line_array[6]);
                int lb = 1;
                int h = Integer.parseInt(line_array[11]);
                int hb = 1;

                if (line_array[5].equals("output")) {
                    lb = 2;
                }
                if (line_array[10].equals("output")) {
                    hb = 2;
                }

                if (!bots.containsKey(b)) {
                    bots.put(b, new Bot());
                }

                boolean confirm = bots.get(b).setInstruction(l, lb, h, hb);

                if (confirm) {
                    System.out.println("give");
                }
            }
        }
    }
}
