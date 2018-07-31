import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_02 {
    public static void main(String[] args) throws IOException{
        
        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        //vars

        //idea
        //hashmap of int[] so you get 2D table of sorts wiht key of 1-9 so you get the graphing function of this also
        //double nested for-loop with a counter to do the filling
        //we dont need to use hasmpad, we can use a simple 2d int array
        
        int[][] keypad = new int[3][3];

        int c = 1;
        for( int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                keypad[j][i] = c++; //j and i in the reverse order on purpose, c is auto increased
            }
        }

        for (int i=0; i<keypad.length; i++) {
            for (int j=0; j<keypad[i].length; j++) {
                System.out.println(Integer.toString(i) + Integer.toString(j) + "-" + Integer.toString(keypad[i][j]));
            }
        }
    }
}