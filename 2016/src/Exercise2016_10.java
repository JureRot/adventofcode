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
    private int high_to;

    public Bot () { //constructor
        this.value1 = -1;
        this.value2 = -1;
        this.low_to = -1;
        this.high_to = -1;
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

    public boolean setInstruction(int l, int h) {
        //should we check if already have instruction (can they overwrite each other, i guess yes)
        this.low_to = l;
        this.high_to = h;
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
    public void give() {
        this.value1 = -1;
        this.value2 = -1;
        //do we clear the instructions as well???
        this.low_to = -1;
        this.high_to = -1;
    }
}

public class Exercise2016_10 {
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
        Map<Integer, ArrayList<Integer>> outputs = new HashMap<>();


        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        for (int i=0; i<input.size(); i++) {
            System.out.print(input.get(i) + ", ");
            String[] line_array = input.get(i).split(" ");
            if (line_array.length == 6) {
                System.out.println("value");
            } else {
                System.out.println("gives");
            }
        }
    }
}
