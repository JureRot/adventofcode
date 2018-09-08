import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_21 {
    public static String swapPos(String str, int x, int y) {
        //swaps letters at x and y
        char a = str.charAt(x);
        char b = str.charAt(y);
        
        if (x < y) { //a (x) is first
            str = str.substring(0, x) + b + str.substring(x+1, y) + a + str.substring(y+1);
        } else { //b (y) is first
            str = str.substring(0, y) + a + str.substring(y+1, x) + b + str.substring(x+1);
        }

        return str;
    }

    public static String swapLet(String str, char a, char b) { //maybe change char with String
        //swaps letters a and b (actual letters, where a was, now is b; and reverse) (always ony one pair)
        int x = str.indexOf(a);
        int y = str.indexOf(b);

        if (x < y) { //a (x) is first
            str = str.substring(0, x) + b + str.substring(x+1, y) + a + str.substring(y+1);
        } else { //b (y) is first
            str = str.substring(0, y) + a + str.substring(y+1, x) + b + str.substring(x+1);
        }

        return str;
    }

    public static String rotateL(String str, int x) {
        //rotate x times left (move front to end x times)
        for (int i=0; i<x; i++) {
            str = str.substring(1) + str.charAt(0);
        }

        return str;
    }

    public static String rotateR(String str, int x) {
        //rotate x times left (move end to front x times)
        for (int i=0; i<x; i++) {
            str = str.charAt(str.length()-1) + str.substring(0, str.length()-1);
        }

        return str;
    }

    public static String rotateN(String str, char a) { //maybe change char with String
        //rotate (1 + index(a) (+1 if index(a)>=4)) times right
        int x = str.indexOf(a);
        int n = 1 + x;

        if (x >= 4) { //if index at least 4 we add one shift
            n += 1;
        }

        return rotateR(str, n);
    }

    public static String rotateNRev(String str, char a) { //maybe change char with String
        //reverse of rotateN (n = x/2 (+1 if x even or zero) or (+5 if odd or not zero)) works only for len 8 (more info in analysis)       
        int x = str.indexOf(a);
        int n = x / 2;

        if (x%2==1 || x==0) {
            n += 1;
        } else {
            n += 5;
        }

        return rotateL(str, n);
    }

    public static String reverse(String str, int x, int y) {
        //reverse substring from x to y (inclusive)
        String output = str.substring(0, x); //new temp string with unchanged part before the range

        for (int i=y; i>=x; i--) { //we go backward through range
            output += str.charAt(i);
        }

        output += str.substring(y+1); //we add the remaining unchanged part after the range

        return output;
    }

    public static String move(String str, int x, int y) {
        //moves leter at x to so that is now at y
        char a = str.charAt(x);

        str = str.replace(String.valueOf(a), ""); //remove char at x ((String) used, because replace can have char,char or str,str, (and we want str,str for ""))
        str = str.substring(0, y) + a + str.substring(y);

        return str;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        String password = "abcdefgh";

        //second part
        ArrayList<String[]> lines = new ArrayList<>();
        String password2 = "fbgdceah";

        Scanner sc = new Scanner(new File("input2016_21.txt"));
        while (sc.hasNextLine()) {
            String[] lineSplit = sc.nextLine().split(" ");

            if (lineSplit[0].equals("swap")) {
                if (lineSplit[1].equals("position")) { //swap position
                    password = swapPos(password, Integer.parseInt(lineSplit[2]), Integer.parseInt(lineSplit[5]));
                } else if (lineSplit[1].equals("letter")) { //swap letter
                    password = swapLet(password, lineSplit[2].charAt(0), lineSplit[5].charAt(0));
                }
            } else if (lineSplit[0].equals("rotate")) {
                if (lineSplit[1].equals("left")) { //rotate left
                    password = rotateL(password, Integer.parseInt(lineSplit[2]));
                } else if (lineSplit[1].equals("right")) { //rotate right
                    password = rotateR(password, Integer.parseInt(lineSplit[2]));
                } else if (lineSplit[1].equals("based")) { //rotate based on index
                    password = rotateN(password, lineSplit[6].charAt(0));
                }
            } else if (lineSplit[0].equals("reverse")) { //reverse
                password = reverse(password, Integer.parseInt(lineSplit[2]), Integer.parseInt(lineSplit[4]));

            } else if (lineSplit[0].equals("move")) { //move
                password = move(password, Integer.parseInt(lineSplit[2]), Integer.parseInt(lineSplit[5]));
            }

            //second part
            lines.add(lineSplit);
        }
        sc.close();

        System.out.println("1. password after scrambling 'abcdefgh': " + password);


        //second part (could be done by brute-force (checking all 8! (only 40320) possible inputs and checking the output))
        for (int i=lines.size()-1; i>=0; i--) { //we go in reverse
            String[] lineSplit = lines.get(i);
            if (lineSplit[0].equals("swap")) {
                if (lineSplit[1].equals("position")) { //swap position same in reverse
                    password2 = swapPos(password2, Integer.parseInt(lineSplit[2]), Integer.parseInt(lineSplit[5]));
                } else if (lineSplit[1].equals("letter")) { //swap letter same in reverse
                    password2 = swapLet(password2, lineSplit[2].charAt(0), lineSplit[5].charAt(0));
                }
            } else if (lineSplit[0].equals("rotate")) {
                if (lineSplit[1].equals("left")) { //rotate left becomes rotate right in reverse
                    password2 = rotateR(password2, Integer.parseInt(lineSplit[2]));
                } else if (lineSplit[1].equals("right")) { //rotate right becomes rotate left in reverse
                    password2 = rotateL(password2, Integer.parseInt(lineSplit[2]));
                } else if (lineSplit[1].equals("based")) { //rotate based on index has new function
                    password2 = rotateNRev(password2, lineSplit[6].charAt(0));
                }
            } else if (lineSplit[0].equals("reverse")) { //reverse is same in reverse (xD)
                password2 = reverse(password2, Integer.parseInt(lineSplit[2]), Integer.parseInt(lineSplit[4]));

            } else if (lineSplit[0].equals("move")) { //move reverses the parameters in reverse
                password2 = move(password2, Integer.parseInt(lineSplit[5]), Integer.parseInt(lineSplit[2]));
            }
        }

        System.out.println("2. password that is scrambeled into 'fbgdceah': " + password2);

        
        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");

    }
}