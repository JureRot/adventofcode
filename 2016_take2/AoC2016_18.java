import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class AoC2016_18 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        String input = "";
        ArrayList<ArrayList<Boolean>> map = new ArrayList<ArrayList<Boolean>>(); //true: ^, false: . (araylist<bool> for each row)
        int row = 0;
        int rowsNeed = 40;
        int count = 0;

        //second part
        int rowsNeed2 = 400000;


        Scanner sc = new Scanner(new File("input2016_18.txt"));
        while (sc.hasNextLine()) {
            input = sc.nextLine();
        }
        sc.close();


        map.add(new ArrayList<Boolean>()); //new row (first in this case)
        map.get(row).add(false); //left out of bounds safe tile

        for (int i=0; i<input.length(); i++) { //we add all the tiles (^->true, .->false)
            if (input.charAt(i) == '^') {
                map.get(row).add(true);
            } else {
                map.get(row).add(false);
            }
        }

        map.get(row).add(false); //right out of bounds safe tile

        
        for (int i=0; i<rowsNeed2-1; i++) { //includes second part (till the needed row (-1 to remove the input/first one))

            ArrayList<Boolean> prev = map.get(row); //previous line (just for easy syntax)
            
            row++; //switch to new row, add that row to map, and fill the out-of-bounds
            map.add(new ArrayList<Boolean>());
            map.get(row).add(false); //l oob safe tile
            
            
            for (int j=1; j<prev.size()-1; j++) { //from 1, till len-1 (leave the oob tiles)
                Boolean l = prev.get(j-1);
                Boolean c = prev.get(j);
                Boolean r = prev.get(j+1);
                
                if (l&c&!r || !l&c&r || l&!c&!r || !l&!c&r) { //if any of the conditions are met, we have true(^)
                    map.get(row).add(true);
                } else { //else, false(.)
                    map.get(row).add(false);
                }
            }
            
            map.get(row).add(false); //r oob safe tile


            if (row == rowsNeed-1) { //if the first part is met
                for (int k=0; k<map.size(); k++) { //we count the falses (safe tiles)
                    for (int l=1; l<map.get(k).size()-1; l++) {
                        if (!map.get(k).get(l)) {
                            count++;
                        }
                    }
                }
        
                System.out.println("1. number of safe tiles: " + count); //and output
                count = 0; //we clear the counter for second part
            }
        }

        for (int i=0; i<map.size(); i++) { //after the for loop we count the safe tiles again
            for (int j=1; j<map.get(i).size()-1; j++) {
                if (!map.get(i).get(j)) {
                    count++;
                }
            }
        }

        System.out.println("2. number of safe tiles after more rows: " + count);
        

        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}