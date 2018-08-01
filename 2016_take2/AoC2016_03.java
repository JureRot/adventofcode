import java.io.File;
import java.io.IOException;
import java.util.Scanner;

class AoC2016_03 {
    public static boolean isTriangle (int a, int b, int c) {
        if ((a+b)<=c || (a+c)<=b || (b+c)<=a) { //if two together less or equal than the other the tringle is impossible
            return false;
        }
        return true;
    }

    public static void main(String[] args) throws IOException {
        //vars
        int numberValid = 0;
        int numberValid2 = 0;

        Scanner sc = new Scanner(new File("input2016_03.txt"));
        while (sc.hasNextLine()) { //we read for one next line but we expect that it will have at least 3 lines
            //we will run all the code while reading the scanner (not save to a var and than for over it)
            int[] valueTriplet = new int[9]; //101 102 103 201 2012 203 301 302 303 (already rearanged from row into column order)

            for (int l=0; l<3; l++) { //three times for loop for the first part (where the lines matter)
                String line = sc.nextLine().trim(); //we use trim here because we have some leading spaces for in each line in the input

                String[] strValues = line.split("\\s+"); //splits on space or multiple consecutive spaces
                int [] values = new int[strValues.length]; //and change them to int
                for (int i=0; i<strValues.length; i++) {
                    values[i] = Integer.parseInt(strValues[i]);
                    valueTriplet[l+(3*i)] = Integer.parseInt(strValues[i]); // we fill he outer var for the second part (l+3*i instead of 3*l+i (which would be standard) is used to rearange the order (so the colums become rows))
                }

                if (isTriangle(values[0], values[1], values[2])) { //and for every line we check if it is a triangle
                    numberValid++;
                }
            }

            //lazy if block for the second part where we use the valueTriplets (where we have the columns rearanged as lines), but we have 3 rows/colums at the time
            if (isTriangle(valueTriplet[0], valueTriplet[1], valueTriplet[2])) {
                numberValid2++;
            }
            if (isTriangle(valueTriplet[3], valueTriplet[4], valueTriplet[5])) {
                numberValid2++;
            }
            if (isTriangle(valueTriplet[6], valueTriplet[7], valueTriplet[8])) {
                numberValid2++;
            }
            
        }
        sc.close();

        //System.out.println(input.size());

        System.out.println("1. number of valid triangles: " + Integer.toString(numberValid));

        System.out.println("2. number of valid triangles if arranged into columns: " + Integer.toString(numberValid2));
    }
}