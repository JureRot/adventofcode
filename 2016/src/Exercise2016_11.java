import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Exercise2016_11 {
    public static void main(String[] args) throws FileNotFoundException {

        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("src/input2016_10.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { //we read input line by line and construct input ArrayList
            input.add(sc.nextLine());
        }
        sc.close();

        //idea: implement A* algorithm of searching the ideal path (or at least try to if you get a chance)
    }
}
