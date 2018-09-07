import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class Range_old {
    public long a;
    public long b;

    public Range_old(long first, long second) {
        this.a = first;
        this.b = second;
    }

    public boolean between (long n) {
        if (this.a<=n && n<=this.b) { //if n between a and b
            return true;
        }
        return false;
    }
}

class AoC2016_20 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        ArrayList<Range_old> notAllowed = new ArrayList<>();
        int counter = 0;

        Scanner sc = new Scanner(new File("input2016_20.txt"));
        while (sc.hasNextLine()) {
            String[] lineSplit = sc.nextLine().split("-");

            notAllowed.add(new Range_old(Long.parseLong(lineSplit[0]), Long.parseLong(lineSplit[1])));
        }
        sc.close();


        for (long i=0L; i<4294967295L; i++) {
            boolean anyRange = false;
            for (int j=0; j<notAllowed.size(); j++) { //for all ranges
                if (notAllowed.get(j).between(i)) { //if between any range, we fail
                    anyRange = true;
                    break;
                }
            }

            if (!anyRange) {
                System.out.println("1. the first non-blocked IP: " + i);
                break;
                //counter++; //this would probably work, but would take hours
            }
        }

        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}