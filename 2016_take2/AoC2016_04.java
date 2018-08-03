import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.Scanner;
import java.util.TreeMap;

class AoC2016_04 {
    public static String makeCheckSum (String input) {
        String output = "";

        //our input is already stripped of dashes so we dont have to do this here

        Map<Character, Integer> counters = new TreeMap<>(); // we create a treemap to store the character:number_of_occurrences pairs

        for (int i=0; i< input.length(); i++) { //we go over the string and for each char inrease the number or occurrences or create a new one and start from zero
            counters.put(input.charAt(i), counters.getOrDefault(input.charAt(i), 0) + 1);
        }

        outerloop:
        for (int i=input.length(); i>0; i--) { //we go from max possible number of occurrences (len of input) toward zero
            for (Map.Entry<Character, Integer> entry : counters.entrySet()) { //and we go over the map
                if (entry.getValue() == i) { //if number of occurrences matches 
                    output += entry.getKey(); // if yes we add that key (char) to the checksum
                    if (output.length() == 5) { // if we reach the len of checksum we break the whole loop (this happens only once)
                        break outerloop;
                    }
                }
            }
        }

        //because we use tree map instead of hash map we dont have to wory about alphabetically ordering chars with the same occurrences (because tree map is already soredy by key)

        return output;
    }

    public static void main(String[] args) throws IOException {
        //vars
        int sumIDs = 0;


        Scanner sc = new Scanner(new File("input2016_04.txt"));
        while (sc.hasNextLine()) { // we execute the code while running the scanner
            String line = sc.nextLine();
            String[] parts = new String[3]; //format: name (clean), sector id, checksum (given)
            String[] temp = line.split("[\\[\\]]"); //splity at [ or ] -> name(unclean)+sectorID, checksum
            parts[2] = temp[1]; //checksum is the second part of the split
            int locLastDash = temp[0].lastIndexOf("-"); //finds the last occurrence of "-" in the name+sectorID part
            String nameRaw = temp[0].substring(0, locLastDash); // name is the part before te last dash
            parts[0] = nameRaw.replace("-", ""); //and we remove all the dashes inbetween
            parts[1] = temp[0].substring(locLastDash + 1); //sector id is the part after the last dash (exclusively after, thus the + 1)

            if (makeCheckSum(parts[0]).equals(parts[2])) { //if name produces the same checksum as given
                sumIDs += Integer.parseInt(parts[1]); //we add the sector id to the sum (parsed from str to int)
            }

            //second part
            // rawname -> caesar_cypher(sectorID), save into file
            //search words "North Pole"
        }
        sc.close();

        System.out.println("1. the sum of the sector IDs of real rooms: " + Integer.toString(sumIDs));
    }
}