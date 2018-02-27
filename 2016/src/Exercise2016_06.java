import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Exercise2016_06 {
    public static char getMostCommon(ArrayList<Character> column) { //returns the most comon char in the array list
        Map<Character, Integer> counts = new HashMap<>(); //we reserve space for map (k=char, v=number of apperences)

        char mostCommon = '_'; //reserve space for char and number of appearences
        int most = 0;

        for (int i=0; i<column.size(); i++) { //we go over arraylist
            counts.put(column.get(i), counts.getOrDefault(column.get(i), 0) + 1); //and for each char add 1 to the number of appearences (default number (if first) is 0 (this was akwardly done in the 2016_04 exercise))
        }

        for (Map.Entry<Character, Integer> kv : counts.entrySet()) { //we go over all entries in the map
            if (kv.getValue() > most) { //and if the current one is more common (has more appearences) we update the appropriate vars
                mostCommon = kv.getKey();
                most = kv.getValue();
            }
        }

        return mostCommon; //we return the most common
    }

    //second part
    public static char getLeastCommon(ArrayList<Character> column) { //returns the least common char (similar to the most common)
        Map<Character, Integer> counts = new HashMap<>();

        char leastCommon = '_';
        int least = Integer.MAX_VALUE; //different

        for (int i=0; i<column.size(); i++) {
            counts.put(column.get(i), counts.getOrDefault(column.get(i), 0) + 1);
        }

        for (Map.Entry<Character, Integer> kv : counts.entrySet()) {
            if (kv.getValue() < least) { //different
                leastCommon = kv.getKey();
                least = kv.getValue();
            }
        }

        return leastCommon;
    }

    public static void main(String[] args) throws FileNotFoundException {

        //starting vars
        String message = ""; //the final message
        //second part
        String message2 = "";

        ArrayList<Character> pos1 = new ArrayList<>(); //we reserve the space for every column in input
        ArrayList<Character> pos2 = new ArrayList<>();
        ArrayList<Character> pos3 = new ArrayList<>();
        ArrayList<Character> pos4 = new ArrayList<>();
        ArrayList<Character> pos5 = new ArrayList<>();
        ArrayList<Character> pos6 = new ArrayList<>();
        ArrayList<Character> pos7 = new ArrayList<>();
        ArrayList<Character> pos8 = new ArrayList<>();

        Scanner sc = new Scanner(new File("src/input2016_06.txt"));
        while (sc.hasNextLine()) { //for each line in the input
            String line = sc.nextLine();
            pos1.add(line.charAt(0)); //we add the appropriate character to appropriate arraylist
            pos2.add(line.charAt(1));
            pos3.add(line.charAt(2));
            pos4.add(line.charAt(3));
            pos5.add(line.charAt(4));
            pos6.add(line.charAt(5));
            pos7.add(line.charAt(6));
            pos8.add(line.charAt(7));
        }
        sc.close();

        message += getMostCommon(pos1); //on every column we call the getMostCommon method
        message += getMostCommon(pos2);
        message += getMostCommon(pos3);
        message += getMostCommon(pos4);
        message += getMostCommon(pos5);
        message += getMostCommon(pos6);
        message += getMostCommon(pos7);
        message += getMostCommon(pos8);

        //second part
        message2 += getLeastCommon(pos1); //for the second part we need to find the least common character
        message2 += getLeastCommon(pos2);
        message2 += getLeastCommon(pos3);
        message2 += getLeastCommon(pos4);
        message2 += getLeastCommon(pos5);
        message2 += getLeastCommon(pos6);
        message2 += getLeastCommon(pos7);
        message2 += getLeastCommon(pos8);


        System.out.println("1. the message using the most common letters: " + message);

        System.out.println("2. the message using the least common letters: " + message2);
    }
}
