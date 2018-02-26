import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Exercise2016_03 {
    public static boolean isTriangle(int[] v) {
        boolean out = (v[0]+v[1]>v[2] && v[0]+v[2]>v[1] && v[1]+v[2]>v[0]) ? true : false; //if each par is longer than the remainng side
        return out;
    }

    public static void main(String[] args) throws FileNotFoundException {
        //starting vars
        int numPossible = 0;
        int numPossibleColumns = 0;

        //second part
        String col1 = "";
        String col2 = "";
        String col3 = "";

        Scanner sc = new Scanner(new File("src/input2016_03.txt"));
        while (sc.hasNextLine()) { //for each line
            String[] line_array = sc.nextLine().split("\\s+"); //we split the line at one or more \s (spaces)
            int[] vertices = new int[3];

            for (int i=1; i<line_array.length; i++) { //we remove first (empty) elemetn and change them to int
                vertices[i-1] = Integer.parseInt(line_array[i]);
            }

            if (isTriangle(vertices)) { //if it is a triangle, we increase the counter
                numPossible++;
            }

            //second part
            col1 += line_array[1] + ","; //we add the values to coresponding column and we add divisors for later
            col2 += line_array[2] + ",";
            col3 += line_array[3] + ",";
        }
        sc.close();

        System.out.println("1. the amount of possible triangles: " + numPossible);

        //second part
        String[] columns = (col1 + col2 + col3).split(","); //we combine the columns and split them at divisors (,)

        for (int i=0; i<columns.length-1; i+=3) { //for every set of 3 we check if triangle and if true, increase counter
            if (isTriangle(new int[]{Integer.parseInt(columns[i]), Integer.parseInt(columns[i+1]), Integer.parseInt(columns[i+2])})) {
                numPossibleColumns++;
            }
        }

        System.out.println("2. the amount of possible triangles written as columns: " + numPossibleColumns);
    }
}
