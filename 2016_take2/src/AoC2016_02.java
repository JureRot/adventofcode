import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class AoC2016_02 {
    public static void main(String[] args) throws IOException {

        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("src/input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }

        System.out.println(input.size());
    }
}
