import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_25 {
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

        if (xValue != 0) {
            return Integer.parseInt(y);
        }
        return 1;
    }

    public static int out(int[] registers, String x) { //this is new, retuns the int in register x or if x not register, retuns x
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

        return xValue;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //again similar to 2016_12 and 2016_23

        //vars
        ArrayList<String[]> input = new ArrayList<>();
        int[] registers = new int[4]; //[a, b, c, d];
        boolean found = false;
        int sigLen = 0;
        boolean mismatch = false;

        Scanner sc = new Scanner(new File("input2016_25.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine().split(" "));
        }
        sc.close();

        int n = 0;
        while (!found) { //while input that results in repeating output not found

            registers[0] = n;
            registers[1] = 0;
            registers[2] = 0;
            registers[3] = 0;

            sigLen = 0;
            mismatch = false;

            int i = 0;
            while (!mismatch) { //while the outputs match the wanted clock signal
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
                    case "out":
                        int output = out(registers, input.get(i)[1]);
                        if (output == sigLen%2) { //if the output matches the wanted clock signal (wanted cs is 0, 1, 0, 1, ... which is counting 0++ mod 2 (odd(0) or even(1)))
                            sigLen++;

                            if (sigLen > 100) { //if signal is correct for 100 values, we stop it (it should go on forever, but i dont know how to check that)
                                found = true;
                                System.out.println("1. the lowest int that initializes clock signal: " + n);
                                mismatch = true; // not true, but we want to end the loop
                            }

                        } else { //if it doesnt match, we break and go to the next n (a register input)
                            mismatch = true;
                            break;
                        }
                        i++;
                        break;
                }
            }

            n++;
        }

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}