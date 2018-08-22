import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

class Bot {
    private int valueLow;
    private int addressLow;
    private int valueHigh;
    private int addressHigh;
    private int[] compared;

    public Bot() { //constructor (could intake values, but we wont have them all at the creation, so we will use setters)
        valueLow = -999; //we cant use null, so we use a specific value that we will check against
        addressLow = -999;
        valueHigh = -999;
        addressHigh = -999;
        compared = new int[]{-999, -999}; //just so we dont get NullPointerException
    }

    public boolean setValue(int v) { //bolean to signal to give values
        if (valueLow == -999) { //we always fill low first
            valueLow = v;
        } else { // we already have one value, we need to compare
            if (valueLow < v) {
                valueHigh = v;
            } else {
                valueHigh = valueLow;
                valueLow = v;
            }
            compared = new int[]{valueLow, valueHigh}; //create compared set (we will check this for the answer)
        }

        if (valueLow!=-999 && valueHigh!=-999 && addressLow!=-999 && addressHigh!=999) { //if all the prerequisites are fullfiled we give the values out (done externally)
            return true;
        }
        return false;
    }

    public boolean setAddress(int l, int h) {
        addressLow = l;
        addressHigh = h;
        
        if (valueLow!=-999 && valueHigh!=-999 && addressLow!=-999 && addressHigh!=999) { //if all the prerequisites are fullfiled we give the values out (done externally)
            return true;
        }
        return false;
    }

    public int[] getAll() {
        return new int[]{valueLow, addressLow, valueHigh, addressHigh};
    }

    public int[] getCompared() {
        return compared;
    }
}

class AoC2016_10 {
    public static Map<Integer, Bot> give(Map<Integer, Bot> input, int b) { //THIS NEEDS TO RECURSIVELY GIVE OUT ALL VALUES, STARTING WITH BOT b AND RETURN NEW MAP
        Map<Integer, Bot> temp = new HashMap<>(input); //create copy of input
        int[] all = temp.get(b).getAll();
        //vLow, aLow, vHigh, aHigh

        boolean check1 = temp.get(all[1]).setValue(all[0]); //we give to low and check if it cascades further
        if (check1) {
            temp = give(temp, all[1]);
        }

        boolean check2 = temp.get(all[3]).setValue(all[2]); //and the same for high
        if (check2) {
            temp = give(temp, all[3]);
        }

        return temp;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        Map<Integer, Bot> bots = new HashMap<Integer, Bot>(); //outputs are negative 100+n (so we don't have -0)

        //second part
        int multValues = 1;

        Scanner sc = new Scanner(new File("input2016_10.txt"));
        while (sc.hasNextLine()) {
            String[] splitLine = sc.nextLine().split(" ");
            if (splitLine[0].equals("bot")) {
                //bot 127 gives low to bot 159 and high to bot 54 (bot can be output)

                int b = Integer.parseInt(splitLine[1]); // bot in question
                if (!bots.containsKey(b)) { //if we dont have this bot yet
                    bots.put(b, new Bot());
                }

                int l; //we get the low bot or output(-(100+n))
                if (splitLine[5].equals("bot")) {
                    l = Integer.parseInt(splitLine[6]);
                } else {
                    l = -(100 + Integer.parseInt(splitLine[6]));
                }

                if (!bots.containsKey(l)) { //and we create them in advance (if we dont already have them)
                    bots.put(l, new Bot());
                }

                int h; //and the same for high
                if (splitLine[10].equals("bot")) { //we add addresses
                    h = Integer.parseInt(splitLine[11]);
                } else {
                    h = -(100 + Integer.parseInt(splitLine[11]));
                }

                if (!bots.containsKey(h)) {
                    bots.put(h, new Bot());
                }

                boolean check = bots.get(b).setAddress(l, h);
                if (check) {//if true, we need to give the values away
                    bots = give(bots, b); //we call a recursive function
                }
                
            } else if (splitLine[0].equals("value")) { //we add value
                //value 43 goes to bot 106

                int b = Integer.parseInt(splitLine[5]); // bot in question
                if (!bots.containsKey(b)) { //if we dont have this bot yet
                    bots.put(b, new Bot());
                }

                int v = Integer.parseInt(splitLine[1]);

                boolean check = bots.get(b).setValue(v);
                if (check) { //if true, we need to give the values away
                    bots = give(bots, b); //we call a recursive function
                }
            }
        }
        sc.close();

        for (Map.Entry<Integer, Bot> entry : bots.entrySet()) {
            int[] compared = entry.getValue().getCompared();
            if (compared[0]==17 && compared[1]==61) {
                System.out.println("1. number of bot that compared 17 and 61: " + entry.getKey());
            }

            if (entry.getKey()==-100 || entry.getKey()==-101 || entry.getKey()==-102) { //if we see the outputs 0, 1 or 2 we multiply their value (not yet in compred, so we use getAll())
                multValues *= entry.getValue().getAll()[0];
            }
        }

        System.out.println("2. multipllication of the numbers in outputs 0, 1 and 2: "+ multValues);

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}