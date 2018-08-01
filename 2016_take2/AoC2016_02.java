import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_02 {
    public static int[] makeMove(int x, int y, char move) { //checks and exectues the move for part 1
        int[] output = new int[2];
        output[0] = x;
        output[1] = y;

        switch (move) {
            case 'U':
                if (x != 0) {
                    output[0]--;
                }
                break;
            case 'D':
                if (x != 2) {
                    output[0]++;
                }
                break;
            case 'L':
                if (y != 0) {
                    output[1]--;
                }
                break;
            case 'R':
                if (y != 2) {
                    output[1]++;
                }
                break;
        }

        return output;
    }

    static int[] makeMove2 (int x, int y, char move) { //makes the move, NO checking
        int[] output = new int[2];
        output[0] = x;
        output[1] = y;

        switch (move) {
            case 'U':
                output[0]--;
                break;
            case 'D':
                output[0]++;
                break;
            case 'L':
                output[1]--;
                break;
            case 'R':
                output[1]++;
                break;
        }

        return output;
    }

    public static int[] checkSecond (int x, int y, char move) { //2016_02analysis has more explanations
        int[] output = new int[2]; //for safekeeping
        output[0] = x;
        output[1] = y;

        int temp_x = x-2; //we normalize (so the middle of the keypad is 0,0)
        int temp_y = y-2;

        if (Math.abs(temp_x) + Math.abs(temp_y) != 2) { //not on the edge (radius less than 2)
            output = makeMove2(x, y, move);
        } else { //we have an edge case
            /*
            r = 2*x + y (we make a simple function so we have nonrepeating outputs)
            possible outcomes -> r (possible direction)
            0,-2  -> -2 (right)
            0,2   -> 2 (left)
            -2,0  -> -4 (down)
            2,0   -> 4 (up)
            1,-1  -> 1 (up, right)
            1,1   -> 3 (up, left)
            -1,-1 -> -3 (down right)
            -1,1  -> -1 (down, left)

                    -4
                -3      -1
            -2              +2
                +1      +3
                    +4
            */

            int r = 2*temp_x + temp_y;

            switch (move) {
                case 'U':
                    if (r==1 || r==4 || r==3) {
                        output = makeMove2(x, y, move);
                    }
                    break;
                case 'D':
                    if (r==-3 || r==-4 || r==-1) {
                        output = makeMove2(x, y, move);
                    }
                    break;
                case 'L':
                    if (r==-1 || r==2 || r==3) {
                        output = makeMove2(x, y, move);
                    }
                    break;
                case 'R':
                if (r==-3 || r==-2 || r==1) {
                    output = makeMove2(x, y, move);
                }
                break;
            }
        }

        return output;
    }

    public static void main(String[] args) throws IOException{
        
        ArrayList<String> input = new ArrayList<>();

        Scanner sc = new Scanner(new File("input2016_02.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        //vars
        int x = 1;
        int y = 1;
        String combination = "";


        //idea
        //hashmap of int[] so you get 2D table of sorts wiht key of 1-9 so you get the graphing function of this also
        //double nested for-loop with a counter to do the filling
        //we dont need to use hasmpap, we can use a simple 2d int array

        int[][] keypad = new int[3][3];

        int c = 1; //we generate the keypad x[0-2], y[0-2] -> [1-9]
        for (int j=0; j<3; j++) {
            for (int i=0; i<3; i++) {
                keypad[j][i] = c++; //j and i in the reverse order on purpose (so that x is the "horizontal" var), c is auto increased
            }
        }

        //second part
        int x2 = 2;
        int y2 = 0;
        String combination2 = "";

        String[][] keypad2 = new String[5][5];

        keypad2[0][2] = "1"; //here we manualy create the keypad table, because the function would be complex
        keypad2[1][1] = "2";
        keypad2[1][2] = "3";
        keypad2[1][3] = "4";
        keypad2[2][0] = "5";
        keypad2[2][1] = "6";
        keypad2[2][2] = "7";
        keypad2[2][3] = "8";
        keypad2[2][4] = "9";
        keypad2[3][1] = "A";
        keypad2[3][2] = "B";
        keypad2[3][3] = "C";
        keypad2[4][2] = "D";


        for (int i=0; i<input.size(); i++) { //for every line
            String line = input.get(i);
            for (int j=0; j<line.length(); j++) { //for every char
                char command = line.charAt(j);

                int[] update = makeMove(x, y, command); //we make a move (method checks if the move is possible)

                x = update[0]; //and we update the values
                y = update[1];

                
                //second part
                int[] update2 = checkSecond(x2, y2, command); //we pass the values to the method that checks if move is possible and if it is, it automatically calls the makeMove2 metod
                
                x2 = update2[0]; //and we update this values too
                y2 = update2[1];

            }
            combination += Integer.toString(keypad[x][y]); //after each line we remember the position / keypad value
            combination2 += keypad2[x2][y2]; //we saved strings here, so we dont need to parse to string
        }

        System.out.println("1. the bathroom code is: " + combination);

        System.out.println("2. the bathroom code on the weird keypad: " + combination2);
    }
}