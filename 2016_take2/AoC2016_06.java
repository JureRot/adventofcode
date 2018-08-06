import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

class AoC2016_06 {
    public static char getMostCommon(Map<Character, Integer> input) {
        char output = '_';
        int occurrences = Integer.MIN_VALUE;

        for (Map.Entry<Character, Integer> entry : input.entrySet()) {
            if (entry.getValue() > occurrences) {
                output = entry.getKey();
                occurrences = entry.getValue();
            }
        }

        return output;
    }

    public static char getLeastCommon(Map<Character, Integer> input) {
        char output = '_';
        int occurrences = Integer.MAX_VALUE;

        for (Map.Entry<Character, Integer> entry : input.entrySet()) {
            if (entry.getValue() < occurrences) {
                output = entry.getKey();
                occurrences = entry.getValue();
            }
        }

        return output;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        String message = "";
        Map<Character, Integer> pos1 = new HashMap<>(); //format: character:number_of_occurences in the column in the document
        Map<Character, Integer> pos2 = new HashMap<>();
        Map<Character, Integer> pos3 = new HashMap<>();
        Map<Character, Integer> pos4 = new HashMap<>();
        Map<Character, Integer> pos5 = new HashMap<>();
        Map<Character, Integer> pos6 = new HashMap<>();
        Map<Character, Integer> pos7 = new HashMap<>();
        Map<Character, Integer> pos8 = new HashMap<>();

        //second part
        String message2 = "";

        Scanner sc = new Scanner(new File("input2016_06.txt"));
        while (sc.hasNextLine()) {
            String line = sc.nextLine();

            pos1.put(line.charAt(0), pos1.getOrDefault(line.charAt(0), 0)+1); //for each char in line (according possition) (if not exist) creates new object in this map or (if already exists) increases the number of occurences of this char in this column
            pos2.put(line.charAt(1), pos2.getOrDefault(line.charAt(1), 0)+1);
            pos3.put(line.charAt(2), pos3.getOrDefault(line.charAt(2), 0)+1);
            pos4.put(line.charAt(3), pos4.getOrDefault(line.charAt(3), 0)+1);
            pos5.put(line.charAt(4), pos5.getOrDefault(line.charAt(4), 0)+1);
            pos6.put(line.charAt(5), pos6.getOrDefault(line.charAt(5), 0)+1);
            pos7.put(line.charAt(6), pos7.getOrDefault(line.charAt(6), 0)+1);
            pos8.put(line.charAt(7), pos8.getOrDefault(line.charAt(7), 0)+1);
        }
        sc.close();
        
        message += getMostCommon(pos1); //adds the most common char for each column
        message += getMostCommon(pos2);
        message += getMostCommon(pos3);
        message += getMostCommon(pos4);
        message += getMostCommon(pos5);
        message += getMostCommon(pos6);
        message += getMostCommon(pos7);
        message += getMostCommon(pos8);

        //second part
        message2 += getLeastCommon(pos1); // adds the least common char for each column
        message2 += getLeastCommon(pos2);
        message2 += getLeastCommon(pos3);
        message2 += getLeastCommon(pos4);
        message2 += getLeastCommon(pos5);
        message2 += getLeastCommon(pos6);
        message2 += getLeastCommon(pos7);
        message2 += getLeastCommon(pos8);

        System.out.println("1. the error-corrected message: " + message);

        System.out.println("2. the error-corrected message using modofied repetition code: " + message2);


        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}