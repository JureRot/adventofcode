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

        Pattern patternFirst = Pattern.compile("(.)((?!\\1).)\\1[^\\[\\]]*\\[[^\\[\\]]*\\2\\1\\2[^\\[\\]]*\\]"); //ABA[BAB] pattern
        Pattern patternSecond = Pattern.compile("\\[[^\\[\\]]*(.)((?!\\1).)\\1[^\\[\\]]*\\][^\\[\\]]*\\2\\1\\2"); //[ABA]BAB pattern

        //DOESNT WORK RIGHT ([^\\[\\]]* SEEMS TO BE THE PROBLEM, MAYBE SHOULD BE .*, BUT THAT IS NOT RIGHT ALSO...)
        // something with ^_$(from beginning till end), a|b (a or b), *? (lazy conditioner (shortest match, not lingest))
        // there are no [_[_]_] occurences, everything is [_]_[_] (can have -[]-, -[]-[]- or -[]-[]-[]- )
        // maybe seperate inside and outside and join them with didivder (|) and than just check if ABA.*|.*BAB ?

        Matcher matchFirst = patternFirst.matcher(input);
        Matcher matchSecond = patternSecond.matcher(input);

        if (matchFirst.find() || matchSecond.find()) { // if any of the patterns is fulfilled
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
            if (supportsSSL(line)) {
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