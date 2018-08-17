import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class AoC2016_07 {
    public static boolean supportsTLS (String input) {
        //we look for if there is a match inside []
        //if yes, we return false
        //if no, we look if there is a match at all (thuslly it isnt isn's inside, but it is outside [])
        //if no, we return false
        // if yes, we return true

        Pattern patternInside = Pattern.compile("\\[[^\\[\\]]*(.)((?!\\1).)\\2\\1[^\\[\\]]*\\]");
        /*
        looks for:
        character [ ("\\["),
        followed by any number of characters that are anything but [ or ] ("[^\\[\\]]*"),
        followed by any (one) character (remembered in as a group with ()) ("(.)"),
        followed by one character that is anythin but the previous group (the line above) with negative lookahead and also saved as a group ("((?!\\1).)"),
        followed by the same character (same s the second / previous group) ("\\2"),
        followed by the same character as the two before (the first group) ("\\1");
        followed by any number of characters that are anything but [ or ] ("[^\\[\\]]*"),
        and followed by character ] ("\\]")
        */

        Matcher matchInside = patternInside.matcher(input);

        if (!matchInside.find()) { // if we don't have a match inside [, ]
            Pattern patternAny = Pattern.compile("(.)((?!\\1).)\\2\\1"); //same as the first patter, but it doesnt recquire to be encapsulated with [, ] (thus finding any match)
            Matcher matchAny = patternAny.matcher(input);

            if (matchAny.find()) { //if we do have a match outside [, ]
                return true;
            }
        }

        return false;
    }

    public static boolean supportsSSL (String input) {
        //we check if there is pattern ABA[BAB] or [ABA]BAB

        //we will separate the inside and outside parts and than put than search for ABA in the first part and BAB in the second
        //there probably are other ways of checking (^_$ (from start to finish), a|b (or), *? (lazy condition))

        String outside = ""; // we reserve all the necessary vars
        String inside = "";
        int begin = 0;
        int start = 0;
        int end = 0;

        Pattern patternInside = Pattern.compile("\\[[^\\]]*\\]"); //we find the inside [] matches
        Matcher matchInside = patternInside.matcher(input);

        while (matchInside.find()) {
            start = matchInside.start(); //for every match we set start and end of match (this inclides [ and ])
            end = matchInside.end();

            outside += input.substring(begin, start); //outside is always first (so from begining till start of match)
            inside += input.substring(start+1, end-1); //inside is between the start and end (excluding [ and ])

            begin = end; //and than we set the new begining for the next match withing the same line
        }
        outside += input.substring(begin); //at the end we add the remaining outusde match (it always ends with oustide part)

        String separate = outside + "|" + inside; //we join the two strings with separator

        Pattern pattern = Pattern.compile("(.)((?!\\1).)\\1.*\\|.*\\2\\1\\2"); //than we search for ABA|BAB match
        Matcher match = pattern.matcher(separate);

        if (match.find()) { //if we find it, we return true; else, false
            return true;
        }
        return false;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        int numTLS = 0;

        //second part
        int numSSl = 0;


        Scanner sc = new Scanner(new File("input2016_07.txt"));
        while (sc.hasNextLine()) {
            String line = sc.nextLine();

            if (supportsTLS(line)) {
                numTLS++;
            }

            //second part
            if (supportsSSL(line)) { //change here
                numSSl++;
            }

        }
        sc.close();

        System.out.println("1. number of IPs supporting TLS: " + Integer.toString(numTLS));
        
        System.out.println("2. number of IPs supporting SSl: " + Integer.toString(numSSl));
        
        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}