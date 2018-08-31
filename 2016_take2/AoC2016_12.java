import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_12 {
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

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        ArrayList<String[]> input = new ArrayList<>();
        int[] registers = new int[4]; //[a, b, c, d];

        Scanner sc = new Scanner(new File("input2016_12.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine().split(" "));
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
            }
        }

        System.out.println("1. the value in register a after executioin: " + registers[0]);

        //part two (we do the same thing, but with c originally on 1 (instead of 0))
        int[] registers2 = new int[4];
        registers2[2] = 1;

        i = 0;
        while (i<input.size()) {
            switch(input.get(i)[0]) {
                case "cpy":
                    int[] copy = cpy(registers2, input.get(i)[1], input.get(i)[2]);
                    System.arraycopy(copy, 0, registers2, 0, copy.length);
                    i++;
                    break;
                case "inc":
                    int[] increase = inc(registers2, input.get(i)[1]);
                    System.arraycopy(increase, 0, registers2, 0, increase.length);
                    i++;
                    break;
                case "dec":
                    int[] decrease = dec(registers2, input.get(i)[1]);
                    System.arraycopy(decrease, 0, registers2, 0, decrease.length);
                    i++;
                    break;
                case "jnz":
                    i += jnz(registers2, input.get(i)[1], input.get(i)[2]);
                    break;
            }
        }

        System.out.println("2. the value in register a after executioin with c on 1: " + registers2[0]);

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}