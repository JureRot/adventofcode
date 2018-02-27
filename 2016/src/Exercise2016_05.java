import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.*;

public class Exercise2016_05 {
    public static void main(String[] args) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        String input = "ffykfhsq";

        //starting vars
        String code = ""; // we init the result

        //second part
        String code2 = "________"; //we init and at the same time provide a way to check if position already set
        int code2Set = 0;

        int salt = 0; //the var that we will increment

        while (code.length()<8 || code2Set<8) { //until both codes aren't set

            String current = input + Integer.toString(salt); //we create the full string

            byte[] bytesOfMessage = current.getBytes("UTF-8"); //we create byte array from our string
            MessageDigest md = MessageDigest.getInstance("MD5"); //we init the messagedigest method (form java.security) for MD5
            byte[] digest = md.digest(bytesOfMessage); //we make make a hash (in byte array form)

            String hash = ""; //our hash in hex format (won't be full)

            for (int i = 0; i < 4; i++) { //we are interested in only the first 3 bytes (first 6 characters in hex) (4 for second part) (we could go over all, but will take longer)
                String hexString = String.format("%1$02x", digest[i]); //hex string of byte with leading zeros (java formatter (look it up))
                /*%1 means these flags are for the first argument. In this case, there is only one argument.
                $ separates the argument index from the flags
                0 is a flag that means pad the result with leading zeros up to the specified bit width.
                2 is the bit width
                x means convert the number to hex, and use lowercase letters. X would convert to hex and use uppercase letters.*/

                hash += hexString;
            }

            if (hash.substring(0,5).equals("00000")) { //if first 5 chars (2.5 bytes) are zeros
                if (code.length() < 8) { //only because the second part goes longer (so this becomes too logn)
                    code += hash.charAt(5); //append the sixth to the code
                }

                //second part
                char fifth = hash.charAt(5);
                if (Character.toString(fifth).matches("[0-7]")) { //if the sixth char is between 0 and 7
                    int pos = Character.getNumericValue(fifth);
                    if (code2.charAt(pos) == '_') { //and that position in code2 is not already set
                        code2 = code2.substring(0, pos) + hash.charAt(6) + code2.substring(pos+1); //we set it (by creating new string)
                        code2Set++; //and increase the counter
                    }
                }
            }

            salt++; //we inrease the salt every iteration
        }

        System.out.println("1. the code given the Door ID of ffykfhsq: " + code);

        System.out.println("2. the code given the Door ID of ffykfhsq with positioning: " + code2);
    }
}
