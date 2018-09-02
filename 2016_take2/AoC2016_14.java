import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Match {
    public int index;
    public char match;
    public int searched;
    
    public Match(char m, int i) {
        this.match = m;
        this.index = i;
        this.searched = 0;
    }
}

class AoC2016_14 {
    public static void main(String[] args) throws NoSuchAlgorithmException {
        long startTime = System.nanoTime();

        //vars
        String input = "jlmsuwbz";
        LinkedList<Match> matches = new LinkedList<>();
        int found = 0; //number of true matches (3 and 5)
        int counter = 0;
        boolean done = false;

        while (!done) { //while(!done)
            String both = input + counter++;

            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(both.getBytes()); //creates byte array (bytes[]) (array of bytes of each char)
            byte[] digest = md.digest(); //creates the hash into another bytes[]

            String hexString = "";

            for (int i=0; i<digest.length; i++) {
                hexString += String.format("%1$02x", digest[i]);
                // System.out.println(digest[i] +" "+ String.format("%1$02x", digest[i]));
            }

            int i = 0;
            while (i<matches.size()) { //checking for match5
                matches.get(i).searched++;

                if (matches.get(i).searched > 1000) { //if the match is too old, we remove it
                    matches.remove(i);
                } else {

                    String pat5 = "("+matches.get(i).match+")\\1\\1\\1\\1";
                    Pattern pattern5 = Pattern.compile(pat5);
                    Matcher match5 = pattern5.matcher(hexString);
                    
                    if (match5.find()) { //if the hexString contains 5 match of any previously found 3 matches
                        //System.out.println("match5 " + j);
                        found++; //we increase the found counter
                        if (found == 64) { //and if that counter is 64, we end
                            System.out.println("1. index that produces the 64th key: " + matches.get(i).index);
                            done = true;
                        }
                        matches.remove(i); //and we remove the found match
                    } else { //else we just go to the next 3 match already found (int matches)
                        i++;
                    }
                }
            }

            //check if any previous mathces have their 5 match in this

            Pattern pattern3 = Pattern.compile("(.)\\1\\1");
            Matcher match3 = pattern3.matcher(hexString);

            if (match3.find()) {
                //System.out.println(i);
                matches.add(new Match(hexString.charAt(match3.start()), counter-1));
            }

            //and than we save this into linked list (with some parameter to know wich char was repeating) (maybe arraylist)
            //for next 1000 repetitioin we check if occurence of 5 repeatin of the same char (so we need to note the number of repetitions for that)
            //if te repetition is found, the counter is increased (when it reaches 64 we output the counter (salt+counter))
            //if within 1000 repetitions we dont get an occurence, we throw it out of the linked list
            //we can create new class
        }

        //part two
        //we do the same, we just hash 2017 times instead of once (takes like half a minute)
        LinkedList<Match> matches2 = new LinkedList<>();
        int found2 = 0; //number of true matches (3 and 5)
        int counter2 = 0;
        boolean done2 = false;

        while (!done2) {
            String both = input + counter2++;

            String hexString = "";

            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest;
            for (int i=0; i<2017; i++) { //the difference, instead of doing it once, we do it 2017 times
                md.update(both.getBytes());
                digest = md.digest();
                
                /*for (int j=0; j<digest.length; j++) {
                    hexString += String.format("%1$02x", digest[j]); //string.format is very slow, we need an alternative
                }*/

                char[] hexArray = "0123456789abcdef".toCharArray(); //we create a char array (from which we will pull from)
                char[] hexChars = new char[digest.length * 2]; //we reserve place for hex chars (every byte into 2 hex chars)
                for (int j=0; j<digest.length; j++) { //for every byte
                    int v = digest[j] & 0xff; //we create int by and-ing (logical and) byte with 11111111 (ff)
                    hexChars[j * 2] = hexArray[v >>> 4]; //>>> logical shift (does not preserve signedness (negative, positive) just fills with zeros from left (unlike >> (arithmetic shift)))
                    //v is int represented with 8 bits, we shift them right 4 times (only keeping the leading 4) effectively geting a 4bit int from the leadng 4 bits of an 8bit int, and using it to get coresponding char
                    hexChars[j * 2 + 1] = hexArray[v & 0x0f]; //logical and 8bit int v with 00001111 (0f)
                    //create a 4bit int from 8bit int by anding it with 00001111 (first four are ignored (0andx = 0)), and using it to get a representing char
                }
                hexString = String.valueOf(hexChars); //we create a string from char[]

                both = hexString; //we copy it to both (in the next part of the program we need hexString, that is why we assign both strings(otherwise we could use only both))
            }

            int i = 0;
            while (i<matches2.size()) {
                matches2.get(i).searched++;

                if (matches2.get(i).searched > 1000) {
                    matches2.remove(i);
                } else {

                    String pat5 = "(" + matches2.get(i).match + ")\\1\\1\\1\\1";
                    Pattern pattern5 = Pattern.compile(pat5);
                    Matcher match5 = pattern5.matcher(hexString);
                    
                    if (match5.find()) {
                        found2++;
                        if (found2 == 64) {
                            System.out.println("2. index that produces the 64th key with key stretching: " + matches2.get(i).index);
                            done2 = true;
                        }
                        matches2.remove(i);
                    } else {
                        i++;
                    }
                }
            }

            Pattern pattern3 = Pattern.compile("(.)\\1\\1");
            Matcher match3 = pattern3.matcher(hexString);

            if (match3.find()) {
                matches2.add(new Match(hexString.charAt(match3.start()), counter2-1));
            }
        }


        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}