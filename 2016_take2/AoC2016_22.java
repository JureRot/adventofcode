import java.io.File;
import java.io.IOException;
import java.util.Scanner;

class Cell { //(are actually nodes, but Node already used in this project)
    public int size;
    public int used;
    public int avail;

    public Cell(int s, int u, int a) {
        this.size = s;
        this.used = u;
        this.avail = a;
    }
}

class AoC2016_22 {
    public static int[] isWallEdge(Cell[][] grid, int i, int j) {
        int[] output = new int[]{-1, -1};

        if (grid[i][j].size > 500) { //if a big node (wall)
            if (i!=0 && i!=30 && j!=0 && j!=30) { //if not on the edge of map
                boolean[] neighbors = new boolean[4]; //up, down, left, right
                int numNeigh = 0;

                if (grid[i-1][j].size > 500) { //count how many neighbors are big nodes (walls)
                    neighbors[0] = true;
                    numNeigh++;
                }
                if (grid[i+1][j].size > 500) {
                    neighbors[1] = true;
                    numNeigh++;
                }
                if (grid[i][j-1].size > 500) {
                    neighbors[2] = true;
                    numNeigh++;
                }
                if (grid[i][j+1].size > 500) {
                    neighbors[3] = true;
                    numNeigh++;
                }

                if (numNeigh == 1) { //if only one neighbor 
                    if (neighbors[0]) { //if above is wall, the wall edge is below
                        output[0] = i+1;
                        output[1] = j;
                    }
                    if (neighbors[1]) { //if below is wall, the wall edge is above
                        output[0] = i-1;
                        output[1] = j;
                    }
                    if (neighbors[2]) { //if left is wall, the wall edge is right
                        output[0] = i;
                        output[1] = j+1;
                    }
                    if (neighbors[3]) { //if right is wall, the wall edge is left
                        output[0] = i;
                        output[1] = j-1;
                    }
                }
            }
        }

        return output;
    }

    public static void main(String[] args) throws IOException {
        long startTime = System.nanoTime();

        //vars
        Cell[][] grid = new Cell[31][31];
        int viablePairs = 0;

        //second part
        int moves = 0;
        int ay = 0; //direct acces
        int ax = 0;
        int gy = 0; //wanted (goal) node
        int gx = 30;
        int ey = 0; //empty node
        int ex = 0;
        int w1y = -1; //wall edges
        int w1x = -1;
        int w2y = -1;
        int w2x = -1;



        Scanner sc = new Scanner(new File("input2016_22.txt"));
        //we just remove the two header lines we dont need
        sc.nextLine(); //root@ebhq-gridcenter# df -h
        sc.nextLine(); //Filesystem Size Used Avail Use%
        while (sc.hasNextLine()) {
            String[] lineSplit = sc.nextLine().split("\\s+"); //split by one or more spaces (removes extra spaces)
            //lineSplit = [/dev/grid/node-x0-y0, 94T, 73T, 21T, 77%]
            //lineSplit[0] = /dev/grid/node-x0-y0 -> [, dev, grid, node-x0-y0] -> third = node-x0-y0 -> [node, x0, y0]
            String[] name = lineSplit[0].split("/")[3].split("-");
            int x = Integer.parseInt(name[1].substring(1)); //we remove the x or y from the begining
            int y = Integer.parseInt(name[2].substring(1));

            int s = Integer.parseInt(lineSplit[1].replace("T", "")); //and for cell (node) parameters
            int u = Integer.parseInt(lineSplit[2].replace("T", ""));
            int a = Integer.parseInt(lineSplit[3].replace("T", ""));

            Cell currentCell = new Cell(s, u, a);

            grid[y][x] = currentCell; //y is horizontal acces (rows) and x is vertical (columns)

            //second part
            if (currentCell.used == 0) {
                ey = y;
                ex = x;
            }
        }        
        sc.close();


        /*for (int i=0; i<grid.length; i++) { //over all cells, over all cells, if not same and conditions are met; add
            for (int j=0; j<grid[i].length; j++) {
                for (int k=0; k<grid.length; k++) {
                    for (int l=0; l<grid[k].length; l++) {
                        if (i!=k || j!=l) {
                            if (grid[i][j].used > 0) {
                                if (grid[i][j].used <= grid[k][l].avail) {
                                    viablePairs++;
                                }
                            }
                        }
                    }
                }
            }
        }
        //this could be optimized*/

        for (int i=0; i<grid.length; i++) {
            for (int j=0; j<grid[i].length; j++) {
                for (int k=i; k<grid.length; k++) { //not from begining, but from the same line (no looking back 22, 23; never 21)
                    if (k == i) { //if kl line is same as ij (k==i) we check l for j forward (imagine 2d array as list, lines glued together)
                        for (int l=j+1; l<grid[k].length; l++) {
                            if (grid[i][j].used > 0) { //we look AB and BA at the same time (because we never look back (21))
                                if (grid[i][j].used <= grid[k][l].avail) {
                                    viablePairs++;
                                }
                            }
                            if (grid[k][l].used > 0) { //here is the BA
                                if (grid[k][l].used <= grid[i][j].avail) {
                                    viablePairs++;
                                }
                            }

                            //second part
                            int[] candidate = isWallEdge(grid, i, j);
                            if (candidate[0] != -1) { //-1 if failed, >0 if actually edge
                                if (w1x == -1) { //if w1 not set
                                    w1y = candidate[0];
                                    w1x = candidate[1];
                                } else { //else, if w2 different than w1
                                    if (w1y!=candidate[0] || w1x!=candidate[1]) {
                                        w2y = candidate[0];
                                        w2x = candidate[1];
                                    }
                                }
                            }

                            candidate = isWallEdge(grid, k, l); //we do the same for the second node
                            if (candidate[0] != -1) {
                                if (w1x == -1) {
                                    w1y = candidate[0];
                                    w1x = candidate[1];
                                } else {
                                    if (w1y!=candidate[0] || w1x!=candidate[1]) {
                                        w2y = candidate[0];
                                        w2x = candidate[1];
                                    }
                                }
                            }

                        }
                    } else { //if kl line is greater than ij (k>i), we need to start (l) from begining (next line, l from begining)
                        for (int l=0; l<grid[k].length; l++) {
                            if (grid[i][j].used > 0) {
                                if (grid[i][j].used <= grid[k][l].avail) {
                                    viablePairs++;
                                }
                            }
                            if (grid[k][l].used > 0) {
                                if (grid[k][l].used <= grid[i][j].avail) {
                                    viablePairs++;
                                }
                            }

                            //second part (same as above)
                            int[] candidate = isWallEdge(grid, i, j);
                            if (candidate[0] != -1) {
                                if (w1x == -1) {
                                    w1y = candidate[0];
                                    w1x = candidate[1];
                                } else {
                                    if (w1y!=candidate[0] || w1x!=candidate[1]) {
                                        w2y = candidate[0];
                                        w2x = candidate[1];
                                    }
                                }
                            }

                            candidate = isWallEdge(grid, k, l);
                            if (candidate[0] != -1) {
                                if (w1x == -1) {
                                    w1y = candidate[0];
                                    w1x = candidate[1];
                                } else {
                                    if (w1y!=candidate[0] || w1x!=candidate[1]) {
                                        w2y = candidate[0];
                                        w2x = candidate[1];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        System.out.println("1. number of viable pairs: " + viablePairs);

        //second part
        //print
        /*for (int i=0; i<grid.length; i++) {
            for (int j=0; j<grid[i].length; j++) {
                if (i==0 && j==0) {
                    System.out.print("!");
                } else if (i==0 && j==30) {
                    System.out.print("G");
                } else if (grid[i][j].used == 0) {
                    System.out.print("E");
                } else if (grid[i][j].size > 500) {
                    System.out.print("#");
                } else {
                    System.out.print(".");
                }
            }
            System.out.println();
        }*/
        //the second part can be done by hand (sort of) (look 2016_22nalysis)

        //automatized procedure
        //we add the (manhattan) distance from empty to wall, wall to goal and the shufling of goal to accessed (shufling one cell takes 5 moves)

        int EtoW = Math.abs(ey-w1y) + Math.abs(ex-w1x); //empty to wall
        int WtoG = Math.abs(w1y-gy) + Math.abs(w1x-gx); //wall to goal
        int EtoG = EtoW + WtoG; //together

        if (w2y != -1) { //if we have both wall edges, we use the shortest of them
            int tempEtoW = Math.abs(ey-w2y) + Math.abs(ex-w2x);
            int tempWtoG = Math.abs(w2y-gy) + Math.abs(w2x-gx);
            int tempEtoG = tempEtoW + tempWtoG;

            if (tempEtoG < EtoG) {
                EtoW = tempEtoW;
                WtoG = tempWtoG;
                EtoG = tempEtoG;
            }
        }

        int GtoA = (Math.abs(gy-ay) + Math.abs(gx-ax)) - 1 ; //goal to accessed (-1 because arriving to G (from W) already makes 1 move)

        moves = EtoG + (5 * GtoA);

        System.out.println("2. lowest number of moves so we can acces the top right node data: " + moves);
        
        
        long endTime = System.nanoTime();
        System.out.println("Time: " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}