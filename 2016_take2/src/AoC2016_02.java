import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class AoC2016_02 {
    public static void main(String[] args) throws IOException {

        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("src/input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }

        // vars
        //hashmap of int[] so you get 2D table of sorts wiht key of 1-9 so you get the graphing function of this also
        //double nested for-loop with a counter to do the filling

        int c = 1;
        for(int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                System.out.println(Integer.toString(i) + Integer.toString(j) + "-" + Integer.toString(c++));
            }
        }

        //we dont need to use hasmpad, we can use a simple 2d int arraylist
    }

}
