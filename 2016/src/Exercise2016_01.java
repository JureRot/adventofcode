import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Exercise2016_01 {
    public static int[] makeMove(int x, int y, int dir, String move) {
        int[] out = new int[3]; //we decalre our output

        switch (dir) {
            case 0: //heading east
                if (move.charAt(0) == 'L') { // if headed east and turn left, we will be headed north
                    out[0] = x; //x is horizontal coordinate, and if we are heading north it doesn't change
                    out[1] = y + Integer.parseInt(move.substring(1)); //the vertical coordiante increases for the value listed (move without the first char) (because going north is in the positive direction)
                    out[2] = 1; //we set the direction as north (because we were headed east and we turned left)
                } else if (move.charAt(0) == 'R') { // if headed east and turn right, we will be headed south
                    out[0] = x; //x is horizontal coordinate, and if we are heading south it doesn't change
                    out[1] = y - Integer.parseInt(move.substring(1)); //the vertical coordiante decreases for the value listed (because going south is in the negative direction)
                    out[2] = 3; //we set the direction as south (because we were headed east and we turned right)
                }
                break;
            case 1: //heading north
                if (move.charAt(0) == 'L') { // and so on for all the others
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

        return out; //we return an array [newx, newy, newdirection] of integers
    }

    public static void main(String[] args) throws IOException {
        String input = ""; //we (not even) reserve space for the input var

        Scanner sc = new Scanner(new File("src/input2016_01.txt")); //using scanner we read every line in the input file
        while (sc.hasNextLine()) {
            input += sc.nextLine();
        }
        sc.close(); //and we close the scanner (important) ((the new File closes on its own???))

        String[] input_array = input.split(", "); // here we only have one line, so we make an array out of it by spliting (if we would have more lines, we could execute the commands while reading with scanner)

        //starting vars
        int direction = 1; // 0->E, 1->N, 2->W, 3->S
        int distX = 0; //vertical distance +/-
        int distY = 0; //horizontal distance +/-


        //second part
        ArrayList<int[]> visited = new ArrayList<>();
        visited.add(new int[]{distX, distY});
        Boolean firstRepeat = false;
        int repeatX = 0;
        int repeatY = 0;


        for (int i=0; i<input_array.length; i++) { //for every move command
            int[] update = makeMove(distX, distY, direction, input_array[i]); //we call the method that executes the move command

            //checking for second part
            if (!firstRepeat) { //if we haven crossed our path yet
                if (distX == update[0]) { //if x has stayed the same -> y changed
                    if (distY < update[1]) { //positive (we moved in the positive direction (negative just a little different)
                        for (int y=distY+1; y<=update[1]; y++) { //for every y from the previous to the new one
                            for (int k=0; k<visited.size(); k++) { // we go over every already visited location
                                if (Arrays.equals(visited.get(k), new int[]{distX, y})) { // and check if we already visited (using a unnamed temporary element)
                                    repeatX = distX; //we set the vars for second part
                                    repeatY = y;
                                    firstRepeat = true;
                                    break;
                                }
                            }
                            visited.add(new int[]{distX, y}); //after we chack we add it to the list of visited locations
                        }
                    } else { //negative
                        for (int y=distY-1; y>=update[1]; y--) { //(just a little different as possitive direction)
                            for (int k=0; k<visited.size(); k++) {
                                if (Arrays.equals(visited.get(k), new int[]{distX, y})) { //in already
                                    repeatX = distX;
                                    repeatY = y;
                                    firstRepeat = true;
                                    break;
                                }
                            }
                            visited.add(new int[]{distX, y});
                        }
                    }
                } else if (distY == update[1]) { //if y has stayed the same -> x changed (other than this it is pretty much the same)
                    if (distX < update[0]) { //positive
                        for (int x=distX+1; x<=update[0]; x++) {
                            for (int k=0; k<visited.size(); k++) {
                                if (Arrays.equals(visited.get(k), new int[]{x, distY})) {
                                    repeatX = x;
                                    repeatY = distY;
                                    firstRepeat = true;
                                    break;
                                }
                            }
                            visited.add(new int[]{x, distY});
                        }
                    } else { //negative
                        for (int x=distX-1; x>=update[0]; x--) {
                            for (int k=0; k<visited.size(); k++) {
                                if (Arrays.equals(visited.get(k), new int[]{x, distY})) {
                                    repeatX = x;
                                    repeatY = distY;
                                    firstRepeat = true;
                                    break;
                                }
                            }
                            visited.add(new int[]{x, distY});
                        }
                    }
                }
            }

            distX = update[0]; // we update the current location to the new one
            distY = update[1];
            direction = update[2]; //as well as direction


        }

        System.out.println("1. the distance to the Easter Bunny HQ: " + Integer.toString(Math.abs(distX) + Math.abs(distY))); // we output the first norm (manhattan norm) using abs() (could be different sign)

        System.out.println("2. the distance to the Easter Bunny HQ acording to instructions on the back: " + Integer.toString(Math.abs(repeatX) + Math.abs(repeatY)));
    }
}
