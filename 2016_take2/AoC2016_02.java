import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_02 {
    public static int[] makeMove(int x, int y, char move) {
        int[] output = new int[2];
        output[0] = x;
        output[1] = y;

        switch (move) {
            case 'U':
                if (x != 0) {
                    output[0]--;
                }
                break;
            case 'D':
                if (x != 2) {
                    output[0]++;
                }
                break;
            case 'L':
                if (y != 0) {
                    output[1]--;
                }
                break;
            case 'R':
                if (y != 2) {
                    output[1]++;
                }
                break;
        }

        return output;
    }

    public static void main(String[] args) throws IOException{
        
        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        //vars
        int x = 1;
        int y = 1;
        String combination = "";


        //idea
        //hashmap of int[] so you get 2D table of sorts wiht key of 1-9 so you get the graphing function of this also
        //double nested for-loop with a counter to do the filling
        //we dont need to use hasmpad, we can use a simple 2d int array
        
        //but i dont know how will this be done for second part

        int[][] keypad = new int[3][3];

        int c = 1; // we generate the keypad x[0-2], y[0-2] -> [1-9]
        for (int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                keypad[j][i] = c++; //j and i in the reverse order on purpose (so that x is the "horizontal" var), c is auto increased
            }
        }

        //second part

        for (int i=0; i<input.size(); i++) {
            String line = input.get(i);
            for (int j=0; j<line.length(); j++) {
                int[] update = makeMove(x, y, line.charAt(j));

                x = update[0];
                y = update[1];
            }
            combination += Integer.toString(keypad[x][y]);
        }

        System.out.println("1. the bathroom code is: " + combination);

    }
}