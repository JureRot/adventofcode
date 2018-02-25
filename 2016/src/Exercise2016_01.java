import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Exercise2016_01 {
    public static int[] makeMove(int x, int y, int dir, String move) {
        int[] out = new int[3];

        switch (dir) {
            case 0: //heading east
                if (move.charAt(0) == 'L') {
                    out[0] = x;
                    out[1] = y + Integer.parseInt(move.substring(1));
                    out[2] = 1;
                } else if (move.charAt(0) == 'R') {
                    out[0] = x;
                    out[1] = y - Integer.parseInt(move.substring(1));
                    out[2] = 3;
                }
                break;
            case 1: //heading north
                if (move.charAt(0) == 'L') {
                    out[0] = x - Integer.parseInt(move.substring(1));
                    out[1] = y;
                    out[2] = 2;
                } else if (move.charAt(0) == 'R') {
                    out[0] = x + Integer.parseInt(move.substring(1));
                    out[1] = y;
                    out[2] = 0;
                }
                break;
            case 2: //heading west
                if (move.charAt(0) == 'L') {
                    out[0] = x;
                    out[1] = y - Integer.parseInt(move.substring(1));
                    out[2] = 3;
                } else if (move.charAt(0) == 'R') {
                    out[0] = x;
                    out[1] = y + Integer.parseInt(move.substring(1));
                    out[2] = 1;
                }
                break;
            case 3: //heading south
                if (move.charAt(0) == 'L') {
                    out[0] = x + Integer.parseInt(move.substring(1));
                    out[1] = y;
                    out[2] = 0;
                } else if (move.charAt(0) == 'R') {
                    out[0] = x - Integer.parseInt(move.substring(1));
                    out[1] = y;
                    out[2] = 2;
                }
                break;
        }

        return out;
    }

    public static void main(String[] args) throws IOException {
        String input = "";

        Scanner sc = new Scanner(new File("src/input2016_01.txt"));
        while (sc.hasNextLine()) {
            input += sc.nextLine();
        }
        sc.close();

        String[] input_array = input.split(", ");

        int direction = 1; // 0->E, 1->N, 2->W, 3->S

        int distX = 0; //vertical distance +/-
        int distY = 0; //horizontal distance +/-

        //second part
        ArrayList<int[]> visited = new ArrayList<>();
        visited.add(new int[]{distX, distY});
        Boolean firstRepeat = false;
        int repeatX = 0;
        int repeatY = 0;

        for (int i=0; i<input_array.length; i++) {
            int[] update = makeMove(distX, distY, direction, input_array[i]);
            distX = update[0];
            distY = update[1];
            direction = update[2];

            //check if already visited or something
            //and not just the points where we turn, the straight in between as well
            //or something like this

        }

        System.out.println("1. the distance to the Easter Bunny HQ: " + Integer.toString(distX + distY));

        System.out.println("2. the distance to the Easter Bunny HQ acording to instructions on the back: " + Integer.toString(repeatX + repeatY));
    }
}
