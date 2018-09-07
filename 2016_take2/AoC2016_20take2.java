import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Scanner;

class Range {
    public long start;
    public long end;

    public Range(long first, long second) {
        this.start = first;
        this.end = second;
    }
}

class AoC2016_20take2 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();
        
        //idea:
        //sort the set / list / map (dont know how tho)
        //than start as 0
        //go over array and if a.end > b.start, we have overlap
        // if we dont; coung the ips from a.end till b.start
        //continue until 4294967295

        //vars
        ArrayList<Range> notAllowed = new ArrayList<Range>();
        long biggestPossible = 4294967295L;
        long counter = 0;
        int arrayCounter = 0;
        boolean firstFound = false;
        
        //second part
        long numNonBlocked = 0;
        
        Scanner sc = new Scanner(new File("input2016_20.txt"));
        while (sc.hasNextLine()) {
            String[] lineSplit = sc.nextLine().split("-");
            notAllowed.add(new Range(Long.parseLong(lineSplit[0]), Long.parseLong(lineSplit[1]))); //we fill the notAllowed with Range objects with float vars for start and stop of range
        }
        sc.close();
        
        //we sort the arraylist by starting values
        Collections.sort(notAllowed, new Comparator<Range>(){ // we create a custom comparator, that compares the starts of ranges
            public int compare(Range o1,Range o2){ //comparator must return int: 0 if equal, negative if first smaller and pozitive if second smaller
                if (o1.start == o2.start) {
                    return 0;
                } else if (o1.start < o2.start) {
                    return -1;
                } else {
                    return 1;
                }
            }
        });

        while (counter<biggestPossible+1 && arrayCounter<notAllowed.size()) { //until we run out of numbers or ranges
            if (counter+1 < notAllowed.get(arrayCounter).start) { //if current counter smaller than next notAllowed Range
                //we have non-blocked IPs from counter till start of next notAllowed range
                if (!firstFound) { // we check if this is the first found, and if yes, we output it
                    System.out.println("1. the lowest-value non-bocked IP: " + (counter+1));
                    firstFound = true;
                }

                /*for (long i=counter+1; i<notAllowed.get(arrayCounter).start; i++) {
                    System.out.println(i);
                    numNonBlocked++;
                    
                }*/
                //instead of for loop we just add the difference
                numNonBlocked += (notAllowed.get(arrayCounter).start - (counter+1)); //we add the difference (how many between are non-blocked) for the second part

            }
            //we set counter to notAllowed end, and arrayCounter to next range (in notAllowed);
            counter = Math.max(counter, notAllowed.get(arrayCounter).end); //we need to use max here in case of next situation
            /*//0-2, 3-9, 4-5, 8-10;
            in this situation the counter without max will go:
            0 -> 2, 3 -> 9, 9 -> 5, 5,6,7,8, 8 -> 10
            even tho it should have stayed on 
            */
            arrayCounter++;
        }

        /*for (long i=counter+1; i<biggestPossible+1; i++) {
            System.out.println(i);
            numNonBlocked++;
        }*/
        //again, speed improvement over for loop
        numNonBlocked += (biggestPossible - counter); //we add the difference between the end and where we ended (for the second part)
        
        System.out.println("2. the number of all non-blocked IPs: " + numNonBlocked);

        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}