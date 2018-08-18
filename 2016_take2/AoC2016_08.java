import java.io.File;
import java.io.IOException;
import java.util.Scanner;

class AoC2016_08 {
    public static int[][] rect (int[][] input, int x, int y) {
        for (int j=0; j<x; j++) { //i and j reversed because x is horizontal (thus second [])
            for (int i=0; i<y; i++) {
                input[i][j] = 1;
            }
        }

        return input;
    }

    public static int[][] row (int[][] input, int y, int n) {
        int[][] temp = new int[input.length][input[0].length]; // we manually make a copy of input table
        for (int i=0; i<input.length; i++) {
            for (int j=0; j<input[0].length; j++) {
                temp[i][j] = input[i][j];
            }
        } //fucking shallow copies

        for (int i=0; i<input[0].length; i++) {
            temp[y][i] = input[y][Math.floorMod((i-n), input[y].length)]; //new cell is equal to the cell that was in the same row but n columns back/left (accounting for wrap around with mod)(Math.floorMod used because java % returns negative values)
            //we set the new cell according to "n cells left of current cell mod len of row"
        }

        return temp;
    }

    public static int[][] column (int[][] input, int x, int n) {
        int[][] temp = new int[input.length][input[0].length]; // we manually make a copy of input table
        for (int i=0; i<input.length; i++) {
            for (int j=0; j<input[0].length; j++) {
                temp[i][j] = input[i][j];
            }
        } //fucking shallow copies

        for (int i=0; i<input.length; i++) {
            temp[i][x] = input[Math.floorMod((i-n), input.length)][x]; //new cell is equal to the cell that was in the same column, but n rows back/up
        }

        return temp;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        int[][] display = new int[6][50]; //already all zeros
        int numPixelsLit = 0;

        Scanner sc = new Scanner(new File("input2016_08.txt"));
        while (sc.hasNextLine()) {
            String[] splitLine = sc.nextLine().split(" |=");
            //rect AxB | rotate row y=A by B | rotate column x=A by B
            
            if (splitLine[0].equals("rect")) {
                String[] parameters = splitLine[1].split("x");
                display = rect(display, Integer.parseInt(parameters[0]), Integer.parseInt(parameters[1]));
            } else {
                if (splitLine[1].equals("row")) {
                    display = row(display, Integer.parseInt(splitLine[3]), Integer.parseInt(splitLine[5]));
                } else {
                    display = column(display, Integer.parseInt(splitLine[3]), Integer.parseInt(splitLine[5]));
                }
            }
        }
        sc.close();

        for (int i=0; i<display.length; i++) {
            for (int j=0; j<display[0].length; j++) {
                numPixelsLit += display[i][j];
            }
        }

        System.out.println("1. Number of pixels lit: " + Integer.toString(numPixelsLit));

        for (int i=0; i<display.length; i++) {
            for (int j=0; j<display[0].length; j++) {
                if (display[i][j] == 1) {
                    System.out.print("#");
                } else {
                    System.out.print(".");
                }
            }
            System.out.print("\n");
        }

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}