import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class AoC2016_01 {
    public static int[] makeMove(int x, int y, int d, String move) {
        int[] output = new int[3];

        switch (d) {
            case 0: // if current direction N
                if (move.charAt(0) == 'L') { // if we move left
                    output[0] = x - Integer.parseInt(move.substring(1)); // we set the new x value (we cant use Character.getNumericValue(move.charAt(1)) because the number can have multiple digits)
                    output[1] = y; // we keep the same y value
                    output[2] = 3; // we change the direction to W
                } else { // if we move right
                    output[0] = x + Integer.parseInt(move.substring(1)); //same but we add instead of subtracting
                    output[1] = y;
                    output[2] = 1; // here we are heading into E direction
                }
                break;
            case 1: // if current direction E
                if (move.charAt(0) == 'L') { //and we do the same for others
                    output[0] = x;
                    output[1] = y + Integer.parseInt(move.substring(1));
                    output[2] = 0;
                } else {
                    output[0] = x;
                    output[1] = y - Integer.parseInt(move.substring(1));
                    output[2] = 2;
                }
                break;
            case 2: // if current direction S
                if (move.charAt(0) == 'L') {
                    output[0] = x + Integer.parseInt(move.substring(1));
                    output[1] = y;
                    output[2] = 1;
                } else {
                    output[0] = x - Integer.parseInt(move.substring(1));
                    output[1] = y;
                    output[2] = 3;
                }
                break;
            case 3: // if curret directoion W
                if (move.charAt(0) == 'L') {
                    output[0] = x;
                    output[1] = y - Integer.parseInt(move.substring(1));
                    output[2] = 2;
                } else {
                    output[0] = x;
                    output[1] = y + Integer.parseInt(move.substring(1));
                    output[2] = 0;
                }
                break;
        }

        return output;
    }

    public static ArrayList<Object> makeMove2(int x, int y, int d, String move, ArrayList<int[]> visted, boolean checkTwo) {
        ArrayList<Object> output = new ArrayList<Object>();
        int temp_x = x;
        int temp_y = y;
        int temp_d = d;
        ArrayList<int[]> temp_visited = visted;
        boolean crossed = !checkTwo; // if we still checking for crossings (chekcTwo=true) we havent found it yet (crossed=false)
        int[] crossing = new int[2];

        switch (d) {
            case 0: // if current direction N
                if (move.charAt(0) == 'L') { // if we move left
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) { // for every step in specified direction
                        temp_x--; // we change the heading value by one (here decreases x because we are hading towards W)
                        if (!crossed) { // if we haven't encountered a crossing yet
                            for (int j = 0; j < temp_visited.size(); j++) { // for every element in visited
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) { // we check if is equal to curent location with unnamed object
                                    // if we have already visited this location and is this the first occurence of this situation (visiting the same location twice)
                                    crossed = true; // we change the bool and set the location
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y}); //we add location to the visited
                        }
                    }
                    //temp_y = y; // we keep the same y value
                    temp_d = 3; // we change the direction to W
                } else { // if we move right
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) { // same but with ++ instead of --
                        temp_x++;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    //temp_y = y;
                    temp_d = 1; // here we are heading into E direction
                }
                break;
            case 1: // if current direction E
                if (move.charAt(0) == 'L') { //and we do the same for others
                    //temp_x = x;
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_y++;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    temp_d = 0;
                } else {
                    //temp_x = x;
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_y--;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    temp_d = 2;
                }
                break;
            case 2: // if current direction S
                if (move.charAt(0) == 'L') {
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_x++;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    //temp_y = y;
                    temp_d = 1;
                } else {
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_x--;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    //temp_y = y;
                    temp_d = 3;
                }
                break;
            case 3: // if curret directoion W
                if (move.charAt(0) == 'L') {
                    //temp_x = x;
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_y--;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    temp_d = 2;
                } else {
                    //temp_x = x;
                    for (int i=0; i<Integer.parseInt(move.substring(1)); i++) {
                        temp_y++;
                        if (!crossed) {
                            for (int j = 0; j < temp_visited.size(); j++) {
                                if (Arrays.equals(temp_visited.get(j), new int[]{temp_x, temp_y})) {
                                    crossed = true;
                                    crossing[0] = temp_x;
                                    crossing[1] = temp_y;
                                }
                            }
                            temp_visited.add(new int[]{temp_x, temp_y});
                        }
                    }
                    temp_d = 0;
                }
                break;
        }

        //output format (int x, int y, int d, new visited, bool first_crossing, [int[] crossing])

        output.add(temp_x);
        output.add(temp_y);
        output.add(temp_d);
        output.add(temp_visited);
        if (checkTwo && crossed) { // we havent had a crossing yet at the begining and we found it (we have it at the end) (if we already have crossing at the beginning (chekcTwo = false) => crossed is true, so we need the &&)
            output.add(true);
            output.add(crossing);
        } else {
            output.add(false);
        }
        return output;
    }

    public static void main(String[] args) throws IOException {
        String input = ""; //we (not even) reserve space for the input var

        Scanner sc = new Scanner(new File("src/input2016_01.txt")); //using scanner we read every line in the input file
        while (sc.hasNextLine()) {
            input += sc.nextLine();
        }
        sc.close(); //and we close the scanner (important) ((the new File closes on its own???))

        String[] input_array = input.split(", "); // here we only have one line, so we make an array out of it by spliting (if we would have more lines, we could execute the commands while reading with scanner)

        //starting possition
        int x = 0;
        int y = 0;
        int d = 0; //direction (0=N, 1=E, 2=S, 3=W)

        //second part
        ArrayList<int[]> visited = new ArrayList<>();
        visited.add(new int[]{x, y});
        Boolean firstRepeat = false;
        int x2 = 0;
        int y2 = 0;

        for (int i=0; i<input_array.length; i++) {
            /*int[] update = makeMove(x, y, d, input_array[i]);

            x = update[0];
            y = update[1];
            d = update[2];*/

            ArrayList<Object> update = makeMove2(x, y, d, input_array[i], visited, !firstRepeat);

            //update format (int x, int y, int d, new visited, bool first_crossing, [int[] crossing])

            x = (int) update.get(0); // we update the vars (we need the "(int)" because they are all Object classes)
            y = (int) update.get(1);
            d = (int) update.get(2);

            visited = (ArrayList<int[]>) update.get(3); // and the visited locations

            if ((boolean) update.get(4)) { // if we found the first crossing
                firstRepeat = true; // we change the parameters and save the location
                x2 = ((int[]) update.get(5))[0];
                y2 = ((int[]) update.get(5))[1];

            }
        }

        System.out.println("1. the distance to the Easter Bunny HQ: " + Integer.toString(Math.abs(x) + Math.abs(y))); // we output the first norm (manhattan norm) using abs() (could be different sign)

        //second part
        System.out.println("2. the distance to the Easter Bunny HQ acording to instructions on the back: " + Integer.toString(Math.abs(x2) + Math.abs(y2)));

    }
}
