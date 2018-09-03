import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

class Disc {
    public int positions;
    public int start;

    public Disc(int p, int s) {
        this.positions = p;
        this.start = s;
    }

    public boolean fallsThrough(int time) { //time already includes +1 and the position of the disc
        if ((time + this.start) % this.positions == 0) {
            return true;
        }
        return false;
    }
}

class AoC2016_15 {
    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        ArrayList<Disc> discs = new ArrayList<>();
        int counter = 0;
        boolean found = false;

        Scanner sc = new Scanner(new File("input2016_15.txt"));
        while (sc.hasNextLine()) {
            String[] splitLine = sc.nextLine().split(" ");
            //[Disc, #x, has, y, positions;, at, time=0,, it, is, at, position, z.]
            discs.add(new Disc(Integer.parseInt(splitLine[3]), Integer.parseInt(splitLine[11].substring(0, splitLine[11].length()-1)))); //the substring is to remove the . at the end
        }
        sc.close();

        while (!found) {
            boolean through = true;
            for (int i=0; i<discs.size(); i++) { //if any of the discs isnt at position 0
                if (!discs.get(i).fallsThrough(counter + 1 + i)) { //counter (the time at which we press the button), 1 (from press till first disc is 1 sec), i (which disc in line is current, from disc till next takes 1 s)
                    through = false;
                    break;
                }
            }

            if (through) { //if none discs failed, we have a winner
                System.out.println("1. the first clean fall: " + counter);
                found = true;
            }

            counter++;
        }

        //second part
        discs.add(new Disc(11, 0)); //additional disc (11, 0)
        counter = 0; //reset other values
        found = false;

        while (!found) { //and do the same thing
            boolean through = true;
            for (int i=0; i<discs.size(); i++) {
                if (!discs.get(i).fallsThrough(1 + counter + i)) {
                    through = false;
                    break;
                }
            }

            if (through) {
                System.out.println("2. the first clean fall with an extra disc: " + counter);
                found = true;
            }

            counter++;
        }


        long endTime = System.nanoTime();
        System.out.println("Time :" + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}