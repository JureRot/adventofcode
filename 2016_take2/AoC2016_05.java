import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

class AoC2016_05 {
    public static void main(String[] args) throws NoSuchAlgorithmException {
        
        long startTime = System.nanoTime();//for timing the program

        //vars
        String input = "ffykfhsq";
        int salt = 0;

        String psswd = "";

        //second part
        String psswd2 = "________"; //"empty" string
        int psswd2counter = 0; //number of psswd2 chars already found

        System.out.println("Program takes a while to return the result. Please be patient.");

        while (psswd.length() < 8 || psswd2counter<8) { //while we haven't found the first or the second password

            String current = input + Integer.toString(salt++); //we create input for the current iteration and automatically increase the salt for the next iteration

            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(current.getBytes()); //creates byte array (bytes[]) (array of bytes of each char)
            byte[] digest = md.digest(); //creates the hash into another bytes[]

            String hash = ""; //temp storage for the first part of the hash in hex string format

            for (int i=0; i<4; i++) { //we convert only the firs few bytes (the ones we need) to save time (three for the firs part, fourth for the second)
                hash += String.format("%1$02x", digest[i]); //hex string of byte with leading zeros (java formatter (look it up))
                /*%1 means these flags are for the first argument. In this case, there is only one argument.
                $ separates the argument index from the flags
                0 is a flag that means pad the result with leading zeros up to the specified bit width.
                2 is the bit width
                x means convert the number to hex, and use lowercase letters. X would convert to hex and use uppercase letters.*/
            }
            
            if (hash.substring(0, 5).equals("00000")) { //if first five are zeros
                if (psswd.length() < 8) { //if not yet complete
                    psswd += hash.charAt(5); //save the sixth as part of complete password
                }

                //second part
                int possition = Character.getNumericValue(hash.charAt(5)); //converts char to int (alternative: hash.charAt(5)-'0')
                if (possition<8 && possition>=0) { //check if fifth (hex)number is between 0 and 7 (alternative: Character.toString(hash.charAt(5)).matches("[0-7]")) (we presume we get the right input [0-9] not [0-f])
                    if (psswd2.charAt(possition) == '_') { //if this possition is not already set
                        psswd2 = psswd2.substring(0, possition) + hash.charAt(6) + psswd2.substring(possition+1); //makes a new psswd2 from few substrings (kindoff inserting the new char between two substrins)
                        psswd2counter++;
                    }
                }

            }
        }

        System.out.println("1. the password for the door: " + psswd);

        System.out.println("2. the password for the second door: " + psswd2);

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}