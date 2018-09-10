import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_23 {
    public static int[] cpy(int[] registers, String x, String y) {
        int xValue;

        switch (x) {
            case "a": //if x is one of register, we get the value from it
                xValue = registers[0];
                break;
            case "b":
                xValue = registers[1];
                break;
            case "c":
                xValue = registers[2];
                break;
            case "d":
                xValue = registers[3];
                break;
            default: //else, we just parse it straight from x
                xValue = Integer.parseInt(x);
                break;
        }

        switch (y) { //we get the right register to copy to
            case "a":
                registers[0] = xValue;
                break;
            case "b":
                registers[1] = xValue;
                break;
            case "c":
                registers[2] = xValue;
                break;
            case "d":
                registers[3] = xValue;
                break;
        }
        
        return registers;
    }

    public static int[] inc(int[] registers, String x) {
        switch (x) {
            case "a":
                registers[0]++;
                break;
            case "b":
                registers[1]++;
                break;
            case "c":
                registers[2]++;
                break;
            case "d":
                registers[3]++;
                break;
        }

        return registers;
    }

    public static int[] dec(int[] registers, String x) {
        switch (x) {
            case "a":
                registers[0]--;
                break;
            case "b":
                registers[1]--;
                break;
            case "c":
                registers[2]--;
                break;
            case "d":
                registers[3]--;
                break;
        }

        return registers;
    }

    public static int jnz(int[] registers, String x, String y) {
        int xValue;

        switch (x) {
            case "a": //if x is one of register, we get the value from it
                xValue = registers[0];
                break;
            case "b":
                xValue = registers[1];
                break;
            case "c":
                xValue = registers[2];
                break;
            case "d":
                xValue = registers[3];
                break;
            default: //else, we just parse it straight from x
                xValue = Integer.parseInt(x);
                break;
        }

        if (xValue != 0) { //here we need to be careful if y is reg
            int yValue;

            switch (y) { //we get the right register to copy to
                case "a":
                    yValue = registers[0];
                    break;
                case "b":
                    yValue = registers[1];
                    break;
                case "c":
                    yValue = registers[2];
                    break;
                case "d":
                    yValue = registers[3];
                    break;
                default:
                    yValue = Integer.parseInt(y);
            }

            return yValue; //another change, need to return int
        }
        return 1;
    }

    public static ArrayList<String[]> tgl(ArrayList<String[]> commands, int[] registers, String x, int currentLine) { //new func
        int xValue;

        switch (x) {
            case "a": //if x is one of register, we get the value from it
                xValue = registers[0];
                break;
            case "b":
                xValue = registers[1];
                break;
            case "c":
                xValue = registers[2];
                break;
            case "d":
                xValue = registers[3];
                break;
            default: //else, we just parse it straight from x
                xValue = Integer.parseInt(x);
                break;
        }

        int lineToChange = currentLine + xValue;

        if (lineToChange>=0 && lineToChange<=commands.size()-1) { //if line to change not out-of-bounds of program
            String[] toChange = commands.get(lineToChange);

            if (toChange.length == 2) { //one-argument instruction
                if (toChange[0].equals("inc")) { //if inc, make dec
                    toChange[0] = "dec";
                } else { //else, make inc
                    toChange[0] = "inc";
                }
            } else { //two-argument instruction
                if (toChange[0].equals("jnz")) { //if jnz, make cpy
                    toChange[0] = "cpy";
                } else { //else, make jnz
                    toChange[0] = "jnz";
                }
            }

            commands.set(lineToChange, toChange);
        }

        return commands;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //this is extention of 2016_12 (look for more info);

        //vars
        ArrayList<String[]> input = new ArrayList<>();
        int[] registers = new int[4]; //[a, b, c, d];

        registers[0] = 7; //we change a to 7 (keypad input)

        Scanner sc = new Scanner(new File("input2016_23.txt"));
        while (sc.hasNextLine()) {
            String[] line = sc.nextLine().split(" ");
            input.add(line);
        }
        sc.close();

        int i = 0;
        while (i<input.size()) {
            switch(input.get(i)[0]) {
                case "cpy":
                    int[] copy = cpy(registers, input.get(i)[1], input.get(i)[2]);
                    System.arraycopy(copy, 0, registers, 0, copy.length);
                    i++;
                    break;
                case "inc":
                    int[] increase = inc(registers, input.get(i)[1]);
                    System.arraycopy(increase, 0, registers, 0, increase.length);
                    i++;
                    break;
                case "dec":
                    int[] decrease = dec(registers, input.get(i)[1]);
                    System.arraycopy(decrease, 0, registers, 0, decrease.length);
                    i++;
                    break;
                case "jnz":
                    i += jnz(registers, input.get(i)[1], input.get(i)[2]);
                    break;
                case "tgl":
                    input = tgl(input, registers, input.get(i)[1], i);
                    i++;
                    break;
            }
        }

        System.out.println("1. the value in register a after executioin: " + registers[0]);


        //second part
        ArrayList<String[]> input2 = new ArrayList<>();
        int[] registers2 = new int[4]; //[a, b, c, d];

        registers2[0] = 12;

        Scanner sc2 = new Scanner(new File("input2016_23.txt"));
        while (sc2.hasNextLine()) {
            String[] line = sc2.nextLine().split(" ");
            input2.add(line);
        }
        sc2.close();

        i = 0;
        while (i<input2.size()) {
            switch(input2.get(i)[0]) {
                case "cpy":
                    int[] copy = cpy(registers2, input2.get(i)[1], input2.get(i)[2]);
                    System.arraycopy(copy, 0, registers2, 0, copy.length);
                    i++;
                    break;
                case "inc":
                    int[] increase = inc(registers2, input2.get(i)[1]);
                    System.arraycopy(increase, 0, registers2, 0, increase.length);
                    i++;
                    break;
                case "dec":
                    int[] decrease = dec(registers2, input2.get(i)[1]);
                    System.arraycopy(decrease, 0, registers2, 0, decrease.length);
                    i++;
                    break;
                case "jnz":
                    i += jnz(registers2, input2.get(i)[1], input2.get(i)[2]);
                    break;
                case "tgl":
                    input2 = tgl(input2, registers2, input2.get(i)[1], i);
                    i++;
                    break;
            }
        }

        System.out.println("2. the value in register a after executioin: " + registers2[0]);

        //second part is a bit slow (it takes like 2 min)
        //we could inplement miltiply and replace add loops with it (but i dont want to right now)
        //anyways, the result of the program is always a! + (x * y); where x and y are two big numbers (90plus) in the program
        //for this specific input the results are 7!+(96*91); and 12!+(96*91)

        //in the future, if you want, try to inplement multiply to replace add loops


        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}