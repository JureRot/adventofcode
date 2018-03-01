import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

class Bot {
    private int value1; //values of the 2 chips
    private int value2;
    private int low_to; //address of the lower chip (can be bot or output)
    private int low_bot; //specifies if address of lower chip is bot or output (-1=not set, 1=bot, 2=output)
    private int high_to;
    private int high_bot;

    public Bot () { //constructor
        this.value1 = -1; //sets all values to not set at creation (contructor could input parameters, but why)
        this.value2 = -1;
        this.low_to = -1;
        this.low_bot = -1;
        this.high_to = -1;
        this.high_bot = -1;
    }

    public boolean setValue(int v) { //takes a value and sets it an empty spot (if that fills up the bot and we have the instructions -> we call for execution of give (by executing compare and returning true)
        if (this.value1 == -1) { //if first value isn't set
            this.value1 = v; //we set it
            if (this.isFull() && this.hasInstructions()) { //if that fills up the bot, and we have instructions set (teoreticaly cant happen because we always fill the value1 first)
                this.compare(); //we execute compare
                return true; //and we return true (this will trigger method give)
            }
            return false; //if bot isn't full yet or we dont have instructions we return false (sign for do nothing)

        } else if (this.value2 == -1) { //if the first value was set, if the second isn't
            this.value2 = v; //we set the second value
            //if full and has instructions -> compare, give out (if give -> return true)
            if (this.isFull() && this.hasInstructions()) { //same as for the value1 (if full and instrucitions -> compare, return true to trigger give
                this.compare();
                return true;
            }
            return false;

        } else { //shouldn't happen but if both values are already set and we get a new one -> this is an error
            System.out.println("I'm sorry, Dave. I'm afraid I can't do that.");
            return false;
        }
    }

    public boolean setInstruction(int l, int lb, int h, int hb) {//sets instruction addresses and types
        this.low_to = l; //sets the lower and higher address and lower and higher type
        this.low_bot = lb;
        this.high_to = h;
        this.high_bot = hb;
        if (this.isFull() && this.hasInstructions()) { //if the bot was already full (and now that we have instructions) trigger give (same as in setValue())
            this.compare();
            return true;
        }
        return false;
    }

    public int[] getAll() { //returns all parameters of bot
        return new int[]{this.value1, this.value2, this.low_to, this.low_bot, this.high_to, this.high_bot};
    }

    private boolean isFull() { //returns true if both values are set
        if (this.value1!=-1 && this.value2!=-1) {
            return true;
        }
        return false;
    }

    private boolean hasInstructions() { //returns true if instructions are set (we have lower and higher addresses (as well as types))
        if (this.low_to!=-1 && this.high_to!=-1) {
            return true;
        }
        return false;
    }

    private void compare() { //exchanges the value1 and value2 such as, value1 < value2 (can do nothing if this is already met)
        if (this.value1 > this.value2) {
            int temp = this.value1;
            this.value1 = this.value2;
            this.value2 = temp;
        }
    }

    public void clear() { //clears the bot (this will be executed during give, so the bot can receive new values and instructions)
        this.value1 = -1;
        this.value2 = -1;
        this.low_to = -1;
        this.low_bot = -1;
        this.high_to = -1;
        this.high_bot = -1;
    }
}

class Update { //helping class for metod give (because we need to pass and return two Map[] parameters and one ArrayList parameter (this is the simple way of doing this)
    public static Map<Integer, Bot> bots;
    public static Map<Integer, ArrayList<Integer>> outputs;
    public static ArrayList<int[]> comparisons;

    public Update(Map<Integer, Bot> b, Map<Integer, ArrayList<Integer>> o, ArrayList<int[]> c) { //constructor
        this.bots = b;
        this.outputs = o;
        this.comparisons = c;
    }
    //by making all values public we dont need seters and geters (we can acces them directly)
}

public class Exercise2016_10 {
    public static Update give(Update state, int b) { //receives current state and bot name that is giving away its chips
        int[] b_stats = state.bots.get(b).getAll(); //we get all the bots values
        int v1 = b_stats[0]; //and assign them to helping vars (for easier understandig and clearer code)
        int v2 = b_stats[1];
        int l = b_stats[2];
        int lb = b_stats[3];
        int h = b_stats[4];
        int hb = b_stats[5];

        state.comparisons.add(new int[]{b, v1, v2}); //the bot that is giving away the values had to execute the comparison already (inside setValue() or setInstruction of itself) so we save his name and the values he compared

        state.bots.get(b).clear(); //after we have the value saved we can clear the bot

        if (lb == 2) { //if lower goes to output
            if (!state.outputs.containsKey(l)) { //if this output not yet created in current state
                state.outputs.put(l, new ArrayList<Integer>()); //we create a new one
            }
            state.outputs.get(l).add(v1); //add the lower value to the output

        } else { //if lower goes to bot
            if (!state.bots.containsKey(l)) { //if this bot doesn't exist yet
                state.bots.put(l, new Bot()); //we create it
            }
            boolean confirm = state.bots.get(l).setValue(v1); //and we add this value to it

            if (confirm) { //now if this (lower) bot is full and has instructions, we execute give of it
                Update update = give(new Update(state.bots, state.outputs, state.comparisons), l);
                state.bots = update.bots; //and we update the state values
                state.outputs = update.outputs;
                state.comparisons = update.comparisons;
            }
        }

        if (hb == 2) { //if higher goes to ouput (we do the same for the higher, just change the l to h and lb to hb)
            if (!state.outputs.containsKey(h)) {
                state.outputs.put(h, new ArrayList<Integer>());
            }
            state.outputs.get(h).add(v2);

        } else { //higher to bot
            if (!state.bots.containsKey(h)) {
                state.bots.put(h, new Bot());
            }
            boolean confirm = state.bots.get(h).setValue(v2);

            if (confirm) {
                Update update = give(new Update(state.bots, state.outputs, state.comparisons), h);
                state.bots = update.bots;
                state.outputs = update.outputs;
                state.comparisons = update.comparisons;
            }
        }

        return state; // we return the new state
    }

    public static void main(String[] args) throws FileNotFoundException {
        /*
        idea:
        make a class of bot and make a map of all bots
        every bot has 2 values (low and high) and instruction who to give those values
        every bot can get values (probably if it doesn have both full)
        every bot can give values (only if both are full)
        trigger -> if filled up give them away / when get instruction, if have both give them away

        this can probaby be made with only map<bot number, [value1, value2, low_to, high_to] and methods isFull, has instructions (but i want to practice oop)
         */

        ArrayList<String> input = new ArrayList<>();

        //starting vars
        Map<Integer, Bot> bots = new HashMap<>();
        Map<Integer, ArrayList<Integer>> outputs = new HashMap<>(); //outpus cant be combined with bots because even negative values wouldn't work (-0 isn't valid key)
        ArrayList<int[]> comparisons = new ArrayList<>(); //[bot, value1, value2]

        int wantedBot = 0; //bot comparing 17 and 61 chips

        //second part
        int productOutputs = 1; //product of chips in outputs 0, 1 and 2


        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { //we read input line by line and construct input ArrayList
            input.add(sc.nextLine());
        }
        sc.close();



        for (int i=0; i<input.size(); i++) { //for every line line in input
            String[] line_array = input.get(i).split(" "); //we split the line
            if (line_array.length == 6) { //if command "value x goes to bot x"
                int b = Integer.parseInt(line_array[5]); //we set helping vars
                int v = Integer.parseInt(line_array[1]);

                if (!bots.containsKey(b)) { //if bot doesn't yet exist
                    bots.put(b, new Bot()); //we make it
                }

                boolean confirm = bots.get(b).setValue(v); //we give bot the value

                if (confirm) { //if bot is now full and has instructions, we execute give of this bot
                    Update update = give(new Update(bots, outputs, comparisons), b);
                    bots = update.bots; //we update the values of bots, outputs and comparisons
                    outputs = update.outputs;
                    comparisons = update.comparisons;
                }

            } else { //if command "bot x gives low to [b/o] x and high to [b/o] x"
                int b = Integer.parseInt(line_array[1]); //we set helping vars
                int l = Integer.parseInt(line_array[6]);
                int lb = 1;
                int h = Integer.parseInt(line_array[11]);
                int hb = 1;

                if (line_array[5].equals("output")) { //if lower is output instead of bot  we change the lb
                    lb = 2;
                }
                if (line_array[10].equals("output")) { //if higher is output instead of bot we change hb
                    hb = 2;
                }

                if (!bots.containsKey(b)) { //if bot doesn't yet exist we create it
                    bots.put(b, new Bot());
                }

                boolean confirm = bots.get(b).setInstruction(l, lb, h, hb); //we give the instructions (addresses and types) to the bot

                if (confirm) { //if bot was already full (and now has instructions) we execute give of the bot
                    Update update = give(new Update(bots, outputs, comparisons), b);
                    bots = update.bots; //and update the values
                    outputs = update.outputs;
                    comparisons = update.comparisons;

                }
            }
        }

        for (int i=0; i<comparisons.size(); i++) { // we go over ArrayList of comparisons
            if (comparisons.get(i)[1]==17 && comparisons.get(i)[2]==61) { //and where the values compared are 17 and 61 (stated in the exercise instructions)
                wantedBot = comparisons.get(i)[0]; //we remember the name
            }
        }

        System.out.println("1. bot comparing 17 and 61 chips: " + wantedBot);


        //second part
        for (Map.Entry<Integer, ArrayList<Integer>> kv : outputs.entrySet()) { //for all outputs (kv combinations)
            if (kv.getKey()==0 || kv.getKey()==1 || kv.getKey()==2) { //if key (output name) is 0, 1 or 2
                productOutputs *= kv.getValue().get(0); //we muultiply the values by the first chip (in reality they all have just one chip)
            }
        }

        System.out.println("2. product of chips in outputs 0, 1 and 2: " + productOutputs);
    }

    /*
    this was a fun one
    of course is wasnt the easiest one (especially because we implemented few new classes just to solve a problem we could solve with Map[] and some logic)
    but thus we have much more clear view of the code and approach and a much more flexible platform for similar problems (plus we practice oop in java)
     */
}
