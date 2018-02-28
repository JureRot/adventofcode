import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class Exercise2016_09take3 {
    public static void main(String[] args) throws FileNotFoundException {
        /*
        IDEA:
        make array of weights of characters (weigt is the number of times after decompression)
        normal character acts as 1, if we encounter a marker, we multiply its selection by the number of repetitions (and set the weight of the marker to 0)
        at the end we summ the array
         */
        String input = ""; //reserve space for some needed vars

        //starting vars
        long decomp = 0;
        long decomp2 = 0;

        int[] weights;

        //second part
        int[] weights2;


        Scanner sc = new Scanner(new File("src/input2016_09.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { // we read the single line of input
            input = sc.nextLine();
        }
        sc.close();


        weights = new int[input.length()]; //we create a int array of len of input (cell for each char)
        Arrays.fill(weights, 1); //and we fill it with default weights (1)

        //second part
        weights2 = new int[input.length()];
        Arrays.fill(weights2, 1);

        int i = 0;

        while (i < input.length()) { //we go over entire string
            if (input.charAt(i) == '(') { //if we encounter the start of the marker
                int j = i+1;
                while (input.charAt(j) != ')') { // we find the end of the marker
                    j++;
                }

                String[] para = input.substring(i+1, j).split("x");
                int a = Integer.parseInt(para[0]); //we get the marker parameters
                int b = Integer.parseInt(para[1]);

                for (int n=i; n<j+1; n++) { //we change the weight of the marker to 0 (after decopression the marker would disappear)
                    weights[n] = 0;
                }
                for (int n=j+1; n<j+1+a; n++) { //we multiply the values in the area of repetition by the number of repetitions
                    weights[n] = weights[n] * b;
                }

                i = j+1+a; // we jump over to the end of the area of repetition and continue (this does not account decompressed lenght, because here we dont actually decompress (exten) the string, we just preted as if)
            } else { //if we encounter normal character we just go to the next (the weight is already at 1, which is correct)
                i++;
            }

        }

        for (int k=0; k<weights.length; k++) { // we go over the array and sum its parts (we could use -> int sum = IntStream.of(a).sum();
            decomp += weights[k];
        }


        System.out.println("1. the length of decompressed input: " + decomp);


        //second part (very similar)
        i = 0;

        while (i < input.length()) {
            if (input.charAt(i) == '(') {
                int j = i+1;
                while (input.charAt(j) != ')') {
                    j++;
                }
                String[] para = input.substring(i+1, j).split("x");
                int a = Integer.parseInt(para[0]);
                int b = Integer.parseInt(para[1]);

                for (int n=i; n<j+1; n++) {
                    weights2[n] = 0;
                }
                for (int n=j+1; n<j+1+a; n++) {
                    weights2[n] = weights2[n] * b;
                }

                //i = j+1+a;
                i++; //the only idfference (we dont skip the repetition area, becausewe need to check inside it as well (so we just go to the next char)
            } else {
                i++;
            }

        }

        for (int k=0; k<weights2.length; k++) {
            decomp2 += weights2[k];
        }

        System.out.println("2. the length of decompressed input using v2: " + decomp2);
    }
}
