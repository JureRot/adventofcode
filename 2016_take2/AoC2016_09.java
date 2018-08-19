import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Scanner;

class AoC2016_09 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        String input = "";

        Scanner sc = new Scanner(new File("input2016_09.txt"));
        input += sc.nextLine();
        sc.close();

        int l = input.length();

        int i = 0;
        while (i<input.length()) {
            if (input.charAt(i) == '(') {
                int j = i+1;
                while (input.charAt(j) != ')') {
                    j++;
                }
                String[] decodents = input.substring(i+1, j).split("x");
                //i is the open bracket "(" location
                //j is the closed bracket ")" location
                
                //from l we need to subtract ((j+1)-i) (the len of decoder instruction part (AxB) and the first repetition (already pressent, is replaced with new repeptitions))
                //and to l we need to add decodents[0]*decodents[1] (len of all drecripted text (len of repeptition times number of repeptitions))
                
                //i is increased to j+decodents[0] (the location of ")" plus the len of repetition) so we look from decripted onward (no recursion)
                
                l -= ((j+1) - i) + Integer.parseInt(decodents[0]);
                l += Integer.parseInt(decodents[0]) * Integer.parseInt(decodents[1]);
                i = j + Integer.parseInt(decodents[0]);
                
            }
            i++;
        }


        
        //second part (will try a little differently, with weights)
        /*
        IDEA:
        make array of weights of characters (weigt is the number of times after decompression)
        normal character acts as 1, if we encounter a marker, we multiply its selection by the number of repetitions (and set the weight of the marker to 0)
        at the end we summ the array
        (this could be used for the first part also (just increase the i correctly))
        */

        int[] weights = new int[input.length()]; //we reserve the array and will it with default values (1 at first)
        Arrays.fill(weights, 1);

        long l2 = 0; //l2 becomes too long for int
        
        i = 0;
        while (i<input.length()) {
            if (input.charAt(i) == '(') {
                int j = i+1;
                while (input.charAt(j) != ')') {
                    j++;
                }
                String[] decodents = input.substring(i+1, j).split("x");
                
                for (int k=i; k<j+1; k++) { //we change the weight of the marker to 0 (after decopression the marker would disappear)
                    weights[k] = 0;
                }

                for (int k=j+1; k<j+1+Integer.parseInt(decodents[0]); k++) { //we multiply the values in the area of repetition by the number of repetitions (still works for recursive decompressions, becasue the weight is multiplied for every repetition)
                    weights[k] *= Integer.parseInt(decodents[1]);
                }

                i = j; //we step to the end of the marker (not over the repeating area)
            }
            i++;
        }

        for (int j=0; j<weights.length; j++) { //we add the valuse of the whole string (j instead of i because i already used)
            l2 += weights[j];
        }

        System.out.println("1. Decompressed length: " + l);

        System.out.println("2. Decompressed lenght recursively: " + l2);

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}