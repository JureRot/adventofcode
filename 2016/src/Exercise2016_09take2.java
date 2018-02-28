import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Exercise2016_09take2 {
    public static long decompress(String s) { //this method isn't recursive (only a while loop)
        if (s.indexOf('(') == -1) { //if there arent any markers in the string
            return s.length(); // we just return the len of string
        } else {
            long len = 0; //we set the return var
            while (s.indexOf('(') != -1) { //while we still have ( in strin
                len += s.indexOf('('); //we add to len (because we will jump to that poin, thus we have to account for chars we will jump over)

                int i = s.indexOf('('); //we note the start and end of marker
                int j = s.indexOf(')');
                String[] marker = s.substring(i + 1, j).split("x"); //we get it and split it at x


                int a = Integer.parseInt(marker[0]); // we not the parameters
                int b = Integer.parseInt(marker[1]);

                len += a*b; //we increase the len by the number of chars that would appear if we decoded the marker (len of seleciont * number of repetitions)

                s = s.substring(j+1+a); //we jump to the point after the selection of the marker (j=location of ), +1=next char, +a= len of selection in the marker (not the actuall lenght of seletciont if re decompressed it (here we just add the number as if it was decompressed, but we dont actually do it, we just jump over as if we did))
            }
            len += s.length(); //we add the ramainder of the end of the string that isnt effectd by any marker

            return len;
        }
    }

    public static long decompress2(String s) { //this medthod is recursive (similar to the basic one)
        if (s.indexOf('(') == -1) { //if there arent any markers in the string
            return s.length();
        } else {
            long len = 0;
            while (s.indexOf('(') != -1) {
                len += s.indexOf('(');

                int i = s.indexOf('(');
                int j = s.indexOf(')');
                String[] marker = s.substring(i + 1, j).split("x");

                int a = Integer.parseInt(marker[0]);
                int b = Integer.parseInt(marker[1]);

                len += decompress2(s.substring(j+1, j+1+a)) * b; //here we go into recurison. get the value of the substring that the marker is effecting (not only the len of the effected area (in the basic one))(if that has any other markers, they will be decompressed as well and so on in depth) and multiply it by the number of repetitions specified by the marker

                s = s.substring(j+1+a);
            }
            len += s.length();

            return len;
        }
    }

    public static void main(String[] args) throws FileNotFoundException {
        /*
        IDEA:
        we use recursion to get get only the len of the string (not actully form the whole string)
         */
        String input = "";

        //starting vars
        long decomp = 0;
        long decomp2 = 0;

        Scanner sc = new Scanner(new File("src/input2016_09.txt"));
        sc.useDelimiter("");
        while (sc.hasNextLine()) { // we read the single line of input
            input = sc.nextLine();
        }
        sc.close();


        decomp = decompress(input);

        System.out.println("1. the length of decompressed input: " + decomp);


        decomp2 = decompress2(input);

        System.out.println("2. the length of decompressed input using v2: " + decomp2);
    }
}
