import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Exercise2016_07 {
    public static boolean hasABBA(ArrayList<String> array) { //does any of strings inf arraylist have format of ABBA
        for (int i=0; i<array.size(); i++) { //for every string in arraylist
            String str = array.get(i);
            for (int j=0; j<str.length()-3; j++) { //for every substring of 4 (moved by 1, because we need to check all (if moved by 4 we would not catch xxABBAxx))
                if (str.charAt(j)==str.charAt(j+3) && str.charAt(j+1)==str.charAt(j+2) && str.charAt(j)!=str.charAt(j+1)) { //if first and fourth mathc, if second and third maatch and if first and second do not match
                    return true; //we have a match (no interaction because we check single arraylist at a time)
                }
            }
        }

        return false;
    }

    public static boolean hasABA_BAB(ArrayList<String> out, ArrayList<String> in) { //does any of the string in out have format of ABA and any of the strings in in have format of BAB
        for (int i1=0; i1<out.size(); i1++) { //for every string in in
            String str1 = out.get(i1);
            for (int j1=0; j1<str1.length()-2; j1++) { //for every substring of 3 moved by 1
                if (str1.charAt(j1)==str1.charAt(j1+2) &&  str1.charAt(j1)!=str1.charAt(j1+1)) { //if it has form of ABA

                    for (int i2=0; i2<in.size(); i2++) { //for every string in out
                        String str2 = in.get(i2);
                        for (int j2=0; j2<str2.length()-2; j2++) { //for every substring of 3 moved by 1
                            if (str2.charAt(j2)==str2.charAt(j2+2) &&  str2.charAt(j2)!=str2.charAt(j2+1)) { //if it has form of CDC
                                if (str2.charAt(j2)==str1.charAt(j1+1) && str2.charAt(j2+1)==str1.charAt(j1)) { //if A=D and B=C
                                    return true; //we have a match (because one mathc is enough, we can return here (if more mathces would result in false we would need to return at the end))
                                }
                            }
                        }
                    }
                }
            }
        }

        return false;
    }

    public static void main(String[] args) throws FileNotFoundException {

        //starting vars
        int supportsTLS = 0;

        //second part
        int supportsSSL = 0;

        Scanner sc = new Scanner(new File("src/input2016_07.txt"));
        while (sc.hasNextLine()) { //for every line in iput
            String line = sc.nextLine();

            ArrayList<String> out = new ArrayList<>(); //we reserve two arraylist (for substrings outside and inside [,]
            ArrayList<String> in = new ArrayList<>();

            Pattern pattInside = Pattern.compile("\\[[^\\[\\]]+\\]"); //matches all [...] (and the ... cant be [ or ]) (regex)
            Matcher matchInside = pattInside.matcher(line);

            int s = 0;//start and stop possition for substrings
            int e = 0;

            while (matchInside.find()) { //for each find of inside we will add the outside before the match and the match itself to the arraylists
                e = matchInside.start(); //stop for the outside substring before the match

                out.add(line.substring(s, e)); //the outside substring before the match

                s = matchInside.start() +1; //change the positions for the match itself (+1 eliminates the [)
                e = matchInside.end() -1; //(-1 eliminates the ])

                in.add(line.substring(s, e)); //the inside substring (the actual match)

                s = matchInside.end(); //change of the start possition for the next out before the match
            }
            out.add(line.substring(s)); //the last outside after the last match (from the end of the last match till the end)


            if (hasABBA(out) && !hasABBA(in)) { //if outside has ABBA and the inside doesn't
                supportsTLS++;
            }

            //second part
            if (hasABA_BAB(out,  in)) { //if outside has ABA and inside has coresponding BAB
                supportsSSL++;
            }

        }
        sc.close();

        System.out.println("1. numbe of IP's that support TLS: " + supportsTLS);

        System.out.println("2. numbe of IP's that support SSL: " + supportsSSL);
    }
}
