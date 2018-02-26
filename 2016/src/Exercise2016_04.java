import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Exercise2016_04 {
    public static boolean isReal(String name, String checksum) {
        //if checksum is orderd by number of appearences, secundarily alphabetically

        //idea, create checksum by the rules, compare (instead of actully checking if checksum is correct)
        //for creating use Map (HashMap) to store number of appearences of letters, than get keys, and sort by value ??? (dont know how yet)

        return true;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ArrayList<String> input = new ArrayList<>();

        //starting vars
        int sumOfSectors = 0;

        Scanner sc = new Scanner(new File("src/input2016_04.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        for (int i=0; i<input.size(); i++) {
            String[] line_array = input.get(i).split("[\\[\\]]");
            String[] fullName = line_array[0].split("-");
            String name = String.join("", Arrays.copyOfRange(fullName, 0, fullName.length-1));
            int sector = Integer.parseInt(fullName[fullName.length-1]);

            if (isReal(name, line_array[1])) {
                sumOfSectors += sector;
            }
        }
    }
}
