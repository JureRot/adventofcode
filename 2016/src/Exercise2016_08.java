import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class Exercise2016_08 {
    public static boolean[][] execute(String op, boolean[][] table) {
        boolean[][] new_table = new boolean[table.length][table[0].length]; //we reserve space for our updated version of table
        for (int i=0; i<table.length; i++) { //we fill it with the values from original
            for (int j=0; j<table[i].length; j++) {
                new_table[i][j] = table[i][j];
            }
        } //fucking shallow copies

        String[] op_array = op.split(" "); //we split using spaces

        if (op_array.length == 2) { //rect
            String[] para = op_array[1].split("x");

            int a = Integer.parseInt(para[0]);
            int b = Integer.parseInt(para[1]);

            for (int i=0; i<b; i++) { //from 0 to b (width = columns = second parameter of table)
                for (int j=0; j<a; j++) { //from 0 to a (height = rows = first parameter of table)
                    new_table[i][j] = true; //we set them true
                }
            }

        } else {
            if (op_array[1].equals("row")) { //row
                String[] para = op_array[2].split("="); //we split the third parameter further to get the row number

                int r = Integer.parseInt(para[1]); //helping vars
                int n = Integer.parseInt(op_array[4]);

                for (int j=0; j<new_table[r].length; j++) {
                    new_table[r][j] = table[r][Math.floorMod((j-n), new_table[r].length)]; //new cell is equal to the cell that was in the same row but n columns back/left (accounting for wrap around with mod)(Math.floorMod used because java % returns negative values)
                }

            } else { //column
                String[] para = op_array[2].split("="); //we split the third parameter further to get the column number

                int c = Integer.parseInt(para[1]); //helping vars
                int n = Integer.parseInt(op_array[4]);

                for (int i=0; i<new_table.length; i++) {
                    new_table[i][c] = table[Math.floorMod((i-n), new_table.length)][c]; //new cell is equal to the cell that was in the same column, but n rows back/up
                }
            }
        }
        return new_table;
    }

    public static void main(String[] args) throws FileNotFoundException {

        //starting vars
        boolean[][] display = new boolean[6][50]; //default value at init is false

        int numberLit = 0;

        Scanner sc = new Scanner(new File("src/input2016_08.txt"));
        while (sc.hasNextLine()) {
            String line = sc.nextLine();
            display = execute(line, display); //for each line we call method that executes the command and replace its return to our display (update it)
        }
        sc.close();


        for (int i=0; i<display.length; i++) { //we go over all cells and add if the cell is set true (lit)
            for (int j=0; j<display[i].length; j++) {
                if (display[i][j]) {
                    numberLit++;
                }
            }
        }

        System.out.println("1. number of pixels lit: " + numberLit);

        System.out.println("2. the display reads:");
        //second part (just a display this time)
        System.out.println();
        for (int i=0; i<display.length; i++) { //for each row
            for (int j=0; j<display[i].length; j++) { //for each colum in that row (in the same line)
                if (display[i][j]) { //if the value is true (lit)
                    System.out.print("X"); //we display X
                } else { //not lit
                    System.out.print(" "); //either spaece
                }
            }
            System.out.println(); //after the row we break line (go to new one)
        }
    }
}
