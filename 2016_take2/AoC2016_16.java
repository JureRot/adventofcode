import java.util.ArrayList;

class AoC2016_16 {
    public static String ALtoString(ArrayList<Boolean> input) {
        String output = "";

        for (int i=0; i<input.size(); i++) { //for every item, if its true we add "1", if false we add "0"
            if (input.get(i)) {
                output += "1";
            } else {
                output += "0";
            }
        }

        return output;
    }

    public static ArrayList<Boolean> unfold(ArrayList<Boolean> input) {
        ArrayList<Boolean> output = (ArrayList<Boolean>)input.clone(); //shallow copy of input (need (ArrayList<Boolean>) at begining)

        output.add(false); // we add the 0 in between a and reverse(~a) (a0reverse(~a))

        for (int i=input.size()-1; i>=0; i--) { //we cant use output.size(), because the output will increase during the for loop
            output.add(!input.get(i)); //we go from back to front (thus we reverse) and we negate the value
        }

        return output;
    }

    public static ArrayList<Boolean> checksum(ArrayList<Boolean> input) {
        ArrayList<Boolean> tempIn = (ArrayList<Boolean>)input.clone();
        ArrayList<Boolean> output = new ArrayList<>();

        while (output.size()%2 == 0) { //while output len is even
            output.clear(); //we reset the output

            for (int i=0; i<tempIn.size(); i+=2) { //for every pair in input
                if (tempIn.get(i) == tempIn.get(i+1)) { //create a checksum (if same: 1(true); if different: 0(false))
                    output.add(true);
                } else {
                    output.add(false);
                }
            }
            
            tempIn = (ArrayList<Boolean>)output.clone(); //new in is the old out
        }

        return output;
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();

        //vars
        String input = "01111001100111011";
        ArrayList<Boolean> dragonCurve = new ArrayList<>();
        int len = 272;

        for (int i=0; i<input.length(); i++) { //from input string, we read 1 as true, 0 as false and create a Boolean ArrayList
            if (input.charAt(i) == '0') {
                dragonCurve.add(false);
            } else {
                dragonCurve.add(true);
            }
        }

        while (dragonCurve.size() < len) { //while the dragoncurve is too short, we unfold it
            dragonCurve = unfold(dragonCurve);
        }

        System.out.println("1. the checksum: " + ALtoString(checksum(new ArrayList<Boolean>(dragonCurve.subList(0,len)))));
        //we print the ArayList to string of checksum of substring lenght len of dragonCurve

        //part two
        //different length, else is the same
        len = 35651584;

        dragonCurve.clear(); //we clear the dragonCurve, and we try again, we could do it in the same loop, its just simpler this way

        for (int i=0; i<input.length(); i++) {
            if (input.charAt(i) == '0') {
                dragonCurve.add(false);
            } else {
                dragonCurve.add(true);
            }
        }

        while (dragonCurve.size() < len) {
            dragonCurve = unfold(dragonCurve);
        }

        System.out.println("2. the checksum for part 2: " + ALtoString(checksum(new ArrayList<Boolean>(dragonCurve.subList(0,len)))));


        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}