import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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

    public static String CaesarCypher(String input, int n) {
        String output = "";

        for (int i=0; i<input.length(); i++) {
            int ch = (int) input.charAt(i); //get ascii value (Character.getNumericValue(ch) does something different)
            
            if (ch == 45) { //if character "-" change it to " "
                ch = 32;
            } else {
                ch -= 97; //we normalize ('a' = 97, so it becomes 0)
                ch += n; //we add the sector ID
                ch %= 26; //we use mod so if we went three and a half times aroud, we count only the half thing
                ch += 97; //and we denormalize the values
            }

            output += (char) ch; //append to the output the char representation of the ascii code
        }

        output += " - " + Integer.toString(n);

        return output;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        int sumIDs = 0;

        //second part
        ArrayList<String> decodedLines = new ArrayList<>();


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
            decodedLines.add(CaesarCypher(nameRaw, Integer.parseInt(parts[1]))); //we add the decoded name to a list
        }
        sc.close();

        Path file = Paths.get("output2016_04.txt"); //gets / creates a path to the file you want to write to
        Files.write(file, decodedLines, Charset.forName("UTF-8")); //to the path, every element in list is a line and the charset is utf-8

        System.out.println("1. the sum of the sector IDs of real rooms: " + Integer.toString(sumIDs));

        System.out.println("2. the room names are saved into 'output2016_04.txt' file. Search parameter: 'northpole object storage'");

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}