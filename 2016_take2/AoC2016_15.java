import java.io.File;
import java.io.IOException;
import java.util.Scanner;

class AoC2016_15 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars


        Scanner sc = new Scanner(new File("input2016_15.txt"));
        while (sc.hasNextLine()) {
            System.out.println(sc.nextLine());
        }
        sc.close();


        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}