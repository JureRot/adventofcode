import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Exercise2016_04 {

    public static boolean isReal(String name, String checksum) { //checks if checksum is correct
        String createdChekcsum = "";
        //we will create our chekcsum by the rules, and compare it to the one given (instead of just checking if the one given is by the rules
        //this is simlar to the real world aplication where checksum is usually hash (so we make a new hash and compare to the one given)

        //the approach is a bit awkward, but it seems logical to me

        Map<Character, Integer> letters = new TreeMap<>(); //we create a (alphabeticaly) sorted map for letters (k= letter, v=number of appearences)

        for (int i=0; i<name.length(); i++) { //we have to init all the keys with 0 as value
            letters.put(name.charAt(i), 0);
        }
        for (int i=0; i<name.length(); i++) { //than we add all the repetitions
            letters.put(name.charAt(i), letters.get(name.charAt(i)) + 1);
        }

        /*ways of accesing map values (all of those are iterables (need iterator))
        Set<Character> k = letters.keySet();
        Collection<Integer> v = letters.values();
        Set<Map.Entry<Character, Integer>> kv = letters.entrySet();*/

        //Map<Integer, ArrayList<Character>> repetitions = new TreeMap<>(); //we could use arraylist (little less hassle, but i dont like to be too reliant on arraylist)
        Map<Integer, char[]> repetitions = new TreeMap<>(Collections.reverseOrder()); //we create a (numericaly) sorted (reverse) map (we group all the letters with the same number of appearences. because first map is oreder alphabeticaly, the letters inside the group are still in alphabetical order)) (k=number of appearences, v=array of letters)

        for (Map.Entry<Character,Integer> kv : letters.entrySet()) { //agains we have to init the value cells
            repetitions.put(kv.getValue(), new char[]{});
        }
        for (Map.Entry<Character,Integer> kv : letters.entrySet()){ //and than we fill the up
            char [] newValue = new char[repetitions.get(kv.getValue()).length+1]; //we create new array (1 longer)
            for (int i=0; i<repetitions.get(kv.getValue()).length; i++) { //add all the elements that vere already in the value array
                newValue[i] = repetitions.get(kv.getValue())[i];
            }
            newValue[newValue.length-1] = kv.getKey(); //and than we append the new one
            repetitions.put(kv.getValue(), newValue); //and we overwrite the value with the new (extented) array

        }

        for (char[] c : repetitions.values()) { //we go over the created map (k=num of appearences, v=char array)
            for (int ch=0; ch<c.length; ch++) { //and over value array
                if (createdChekcsum.length() < 5) { //and until the checksum is too short, we add the next most popular letter
                    createdChekcsum += c[ch];
                } else {
                    break;
                }
            }
        }

        if (checksum.equals(createdChekcsum)) { //if our created checksum matches the one given
            return true;
        }

        return false;
    }

    public static char rotate(char c, int n) { //executes ceasar cipher over a char for n shift
        for (int i=0; i<n; i++) { //n-times increases the char (very great and easy in java -> chars already seen as ascii codes)
            if (c == 'z') { //making sure the increment is cyclical (goes back to a)
                c = 'a';
            } else {
                c++;
            }
        }

        return c;
    }

    public static String decode(String name, int sector) { //decodes the name using sector number
        String out = "";

        for (int i=0; i<name.length(); i++) { //goes over string and calls rotate for every char that isn't "-"
            if (name.charAt(i) == '-') { //dashes become spaces
                out += " ";
            } else {
                out += rotate(name.charAt(i), sector);
            }
        }

        return out;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ArrayList<String> input = new ArrayList<>();

        //starting vars
        int sumOfSectors = 0;

        //second part
        int sectorWanted = 0;

        Scanner sc = new Scanner(new File("src/input2016_04.txt"));
        while (sc.hasNextLine()) {
            input.add(sc.nextLine());
        }
        sc.close();

        for (int i=0; i<input.size(); i++) {
            String[] line_array = input.get(i).split("[\\[\\]]"); //we split the line at [ or ] (regex) (first is name, second is chekcsum)
            String[] fullName = line_array[0].split("-"); //split name at - (first few are name, last is sector)
            String name = String.join("", Arrays.copyOfRange(fullName, 0, fullName.length-1)); // we combine the name together (without dashes not to effect most common letter)
            int sector = Integer.parseInt(fullName[fullName.length-1]); //sector is the last element in fullName

            if (isReal(name, line_array[1])) { //if checksum mathces
                sumOfSectors += sector; //we add the sector number

                //second part
                String encriptedName = String.join("-", Arrays.copyOfRange(fullName, 0, fullName.length-1)); //without sector but still with dashes (now we need them)
                String roomName = decode(encriptedName, sector); //we decode the name
                if (roomName.equals("northpole object storage")) { //this is hard coded from looking at the outputs (it had to do something with norhpole) (so if it has something with northpole)
                    sectorWanted = sector; //we remember the sector number
                }
            }
        }

        System.out.println("1. sum of sector ID's of the real rooms: " + sumOfSectors);

        System.out.println("2. sector where the northh pole objects are stored: " + sectorWanted);
    }
}
