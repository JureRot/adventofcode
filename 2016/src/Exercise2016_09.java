import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Exercise2016_09 {
    public static String decompress(String input) {
        int i = 0;

        while (i<input.length()) { //we go over entire string (that will increaes in length during)

            if (input.charAt(i) == '(') { //if char is ( -> signaling the start of the marker
                int j = i+1;
                String marker = "";

                while (input.charAt(j) != ')') { //go over until you find the end of the maker while appending the chars to the string
                    marker += input.charAt(j);
                    j++;
                }

                String[] para = marker.split("x"); //split the marker
                int a = Integer.parseInt(para[0]); //helping vars
                int b = Integer.parseInt(para[1]);

                String repeat = "";

                for (int x=j+1; x<j+1+a; x++) { //from the end of the marker+1 till that position+len of repetition
                    repeat += input.charAt(x); //form repetition
                }

                String input_add = "";

                for (int x=0; x<b; x++) { //for number of repeats
                    input_add += repeat; //add repetition
                }

                input = input.substring(0, i) + input_add + input.substring(j + a + 1); //input is now-> till this poin the same, than we have the repetition repeated and than same as before after that part

                i += a*b; //we jump to the point after repettions
            } else { //if not start of marker we just go next
                i++;
            }
        }

        return input;
    }

    /*public static String decompress2(String input) { ;
        int i = input.length()-1;

        while (i >= 0) {
            System.out.println(input.charAt(i));
            if (input.charAt(i) == ')') {
                int j = i-1;
                String marker = "";

                while (input.charAt(j) != '(') {
                    marker = input.charAt(j) + marker;
                    j--;
                }

                String[] para = marker.split("x");
                int a = Integer.parseInt(para[0]);
                int b = Integer.parseInt(para[1]);

                String repeat = "";

                for (int x=i+1; x<i+1+a; x++) {
                    repeat += input.charAt(x);
                }

                String input_add = "";

                for (int x=0; x<b; x++) {
                    input_add += repeat;
                }

                input = input.substring(0, j) + input_add + input.substring(i + a + 1);

                i = j-1;
            } else {
                i--;
            }
        }
        return input;
    }*/ //o fuck its not recursive from behind, mb

    public static String decompress2(String input) { //very simmilar to first one
        int i = 0;

        while (i<input.length()) {
            System.out.println(i +" "+ i/(input.length() + 0.0));
            if (input.charAt(i) == '(') {
                int j = i+1;
                String marker = "";

                while (input.charAt(j) != ')') {
                    marker += input.charAt(j);
                    j++;
                }

                String[] para = marker.split("x");
                int a = Integer.parseInt(para[0]);
                int b = Integer.parseInt(para[1]);

                String repeat = "";

                for (int x=j+1; x<j+1+a; x++) {
                    repeat += input.charAt(x);
                }

                String input_add = "";

                for (int x=0; x<b; x++) {
                    input_add += repeat;
                }

                input = input.substring(0, i) + input_add + input.substring(j + a + 1);

                //i += a*b; //the only difference, we stay at the same poin
            } else {
                i++;
            }
        }

        return input;
    }


    public static void main(String[] args) throws FileNotFoundException {
        String input = "";

        //starting vars
        String decomp = "";
        String decomp2 = "";

        Scanner sc = new Scanner(new File("src/input2016_09.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) {
            input = sc.nextLine();
        }
        sc.close();

        decomp = decompress(input);

        System.out.println("1. the length of decompressed input: " + decomp.length());


        //second part
        decomp2 = decompress2(input); //this takes a shit ton of time, not sure if it actually finishes

        System.out.println("2. the length of decompressed input using v2: " + decomp2.length());

    }
}
