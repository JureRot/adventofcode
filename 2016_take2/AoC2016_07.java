import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class AoC2016_07 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //the abba pattern must be outside the [] and must not be inside the [] (if both, its invalid)
        //REGEX WOULD BE PERFECT FOR THIS (regex for java and regex in general)

        //vars


        Scanner sc = new Scanner(new File("input2016_07.txt"));
        while (sc.hasNextLine()) {
            String line = sc.nextLine();

            //Pattern pat = Pattern.compile("\\[[^\\[\\]]+\\]"); //"[,[^[]]+,]"
            
            //Pattern pat = Pattern.compile("(.)((?!\\1).)\\2\\1"); //negative lookahead (loookbehind) //works for any
            Pattern pat = Pattern.compile("\\[[^\\[\\]]*(.)((?!\\1).)\\2\\1[^\\[\\]]*\\]"); //works for inside the []
            //(first must be, and second must not be pressent to be tls)
            
            Matcher mat = pat.matcher(line);

            while (mat.find()) {
                if (mat.group().length() != 0) {
                    System.out.println(mat.group());
                }
                System.out.println("start: " + mat.start());
                System.out.println("end: " + mat.end());
            }
        }
        sc.close();
        

        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0));
    }
}