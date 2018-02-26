import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Exercise2016_04 {

    public static boolean isReal(String name, String checksum) {
        //if checksum is orderd by number of appearences, secundarily alphabetically

        //idea, create checksum by the rules, compare (instead of actully checking if checksum is correct)
        //for creating use Map (HashMap) to store number of appearences of letters, than get keys, and sort by value ??? (dont know how yet)

        String createdChekcsum = "";

        Map<Character, Integer> letters = new TreeMap<>();

        for (int i=0; i<name.length(); i++) {
            letters.put(name.charAt(i), 0);
        }
        for (int i=0; i<name.length(); i++) {
            letters.put(name.charAt(i), letters.get(name.charAt(i)) + 1);
        }

        /*Set<Character> k = letters.keySet();
        Collection<Integer> v = letters.values();
        Set<Map.Entry<Character, Integer>> kv = letters.entrySet();*/

        //Map<Integer, ArrayList<Character>> repetitions = new TreeMap<>(); //we could use arraylist
        Map<Integer, char[]> repetitions = new TreeMap<>(Collections.reverseOrder());

        for (Map.Entry<Character,Integer> kv : letters.entrySet()) {
            //repetitions.put(kv.getValue(), new ArrayList<>());
            repetitions.put(kv.getValue(), new char[]{});
        }
        for (Map.Entry<Character,Integer> kv : letters.entrySet()){
            //System.out.println(kv.getKey() +" "+ kv.getValue());
            /*ArrayList<Character> newValue = new ArrayList<>(repetitions.get(kv.getValue()));
            newValue.add(kv.getKey());
            repetitions.put(kv.getValue(), newValue);*/
            //CREATE NEW CHAR[] ARRAY FROM KV.GETVALUE() AND ADD ADIDITONAL LETTER???
            char [] newValue = new char[repetitions.get(kv.getValue()).length+1];
            for (int i=0; i<repetitions.get(kv.getValue()).length; i++) {
                newValue[i] = repetitions.get(kv.getValue())[i];
            }
            newValue[newValue.length-1] = kv.getKey();
            repetitions.put(kv.getValue(), newValue);

        }

        for (char[] c : repetitions.values()) {
            for (int ch=0; ch<c.length; ch++) {
                if (createdChekcsum.length() < 5) {
                    createdChekcsum += c[ch];
                } else {
                    break;
                }
            }
        }

        if (checksum.equals(createdChekcsum)) {
            return true;
        }

        return false;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ArrayList<String> input = new ArrayList<>();

        //starting vars
        int sumOfSectors = 0;

        Scanner sc = new Scanner(new File("src/input2016_04.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        for (int i=0; i<input.size(); i++) {
            String[] line_array = input.get(i).split("[\\[\\]]");
            String[] fullName = line_array[0].split("-");
            String name = String.join("", Arrays.copyOfRange(fullName, 0, fullName.length-1));
            int sector = Integer.parseInt(fullName[fullName.length-1]);

            if (isReal(name, line_array[1])) {
                sumOfSectors += sector;

                //second part
                //decode
            }
        }

        System.out.println("1. sum of sector ID's of the real rooms: " + sumOfSectors);
    }
}
