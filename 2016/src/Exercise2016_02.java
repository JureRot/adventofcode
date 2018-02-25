import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Exercise2016_02 {
    public static int[] makeMove(int x, int y, char c) { //method for making a move for the first part
        int[] out = new int[2]; //reserve ouput
        int newX = x;
        int newY = y;

        switch (c) {
            case 'U': //up
                if (newX > 0) { //if currenty not already at the edge
                    newX--; //make a move (else it stays the same)
                }
                break;
            case 'D': //down
                if (newX < 2) {
                    newX++;
                }
                break;
            case 'L': //left
                if (newY > 0) {
                    newY--;
                }
                break;
            case 'R': //right
                if (newY < 2) {
                newY++;
            }
                break;
        }

        out[0] = newX;
        out[1] = newY;

        return out;
    }

    public static int[] makeMove2(int x, int y, char c, String[][] pad) { //method for making a move for part two
        int[] out = new int[2];
        int newX = x;
        int newY = y;

        switch (c) {
            case 'U': //up
                if (newX > 0) {
                    if (!pad[newX-1][newY].equals("-1")) { //if the move will not result in an invalid position
                        newX--;
                    }
                }
                break;
            case 'D':
                if (newX < 4) {
                    if (!pad[newX+1][newY].equals("-1")) {
                        newX++;
                    }
                }
                break;
            case 'L':
                if (newY > 0) {
                    if (!pad[newX][newY-1].equals("-1")) {
                        newY--;
                    }
                }
                break;
            case 'R':
                if (newY < 4) {
                    if (!pad[newX][newY+1].equals("-1")) {
                        newY++;
                    }
                }
                break;
        }

        out[0] = newX;
        out[1] = newY;

        return out;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ArrayList<String> input = new ArrayList<>();

        //starting vars
        String[][] keypad = new String[][]{{"1", "2", "3"}, {"4", "5", "6"}, {"7", "8", "9"}};
        int x = 1; //rows (up, down)
        int y = 1; //columns (left, right)
        String psswd = "";

        //second part
        String[][] keypad2 = new String[][]{{"-1", "-1", "1", "-1", "-1"}, {"-1", "2", "3", "4", "-1"}, {"5", "6", "7", "8", "9"}, {"-1", "A", "B", "C", "-1"}, {"-1", "-1", "D", "-1", "-1"}};
        //keypad2 hase additional keys (to make it square and not a diamond) with invalid values (that are checked in a helping metod)
        int x2 = 2;
        int y2 = 0;
        String psswd2 = "";


        Scanner sc = new Scanner(new File("src/input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();


        for (int i=0; i<input.size(); i++) { //for every line in input
            String curr_line = input.get(i);
            for (int j=0; j<curr_line.length(); j++) { //for every char in line
                char move = curr_line.charAt(j);
                int[] update = makeMove(x, y, move); //we make a move
                x = update[0]; //and update the positiion
                y = update[1];

                //second part
                int[] update2 = makeMove2(x2, y2, move, keypad2); //method for part 2 needs keypad, because it cheks if value invalid
                x2 = update2[0];
                y2 = update2[1];
            }
            psswd += keypad[x][y]; //after the line we write the button / char in code
            psswd2 += keypad2[x2][y2];
        }

        System.out.println("1. the password for the bathroom: " + psswd);

        System.out.println("2. the password for the bathroom on the weird keypad: " + psswd2);
    }
}
