import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class AoC2016_01 {
    public static void main(String[] args) throws IOException {
        String input = ""; //we (not even) reserve space for the input var

        Scanner sc = new Scanner(new File("src/input2016_01.txt")); //using scanner we read every line in the input file
        while (sc.hasNextLine()) {
            input += sc.nextLine();
        }
        sc.close(); //and we close the scanner (important) ((the new File closes on its own???))

        String[] input_array = input.split(", "); // here we only have one line, so we make an array out of it by spliting (if we would have more lines, we could execute the commands while reading with scanner)

        for (int i=0; i<input_array.length; i++) {
            System.out.println(input_array[i]);
        }
    }
}
