import java.util.ArrayList;
import java.util.HashMap;

class CircularElement  {
    public int value;
    public CircularElement prev;
    public CircularElement next;

    public CircularElement(int v) {
        this.value = v;
    }
}

class CircularLinkedList {
    public HashMap<Integer, CircularElement> list = new HashMap<>();
    public int size;
    public int smallestValue; //first element

    public CircularLinkedList() {
        this.size = 0; //could maybe be done with just list.size()???
    }

    public void append(CircularElement e) {
        if (list.containsKey(e.value)) { //if element already in
            System.out.println("canny do that");
            return;
        }

        if (size == 0) { //if this the first element
            this.list.put(e.value, e); //we add it
            e.next = e; //we point next and prev to itself 
            e.prev = e;
            this.smallestValue = e.value; //we set the smallest value
        } else {
            if (e.value < smallestValue) { //if this smalles than the current smallest, this is the new first element
                this.list.put(e.value, e); //we add it
                e.next = this.list.get(smallestValue); //next is the previous first
                e.prev = this.list.get(smallestValue).prev; //previous is the largest (last)
                this.list.get(smallestValue).prev.next = e; //lasts next is the new element
                this.list.get(smallestValue).prev = e; //now second smallests (previously smallests) previsou is the new element
                
                this.smallestValue = e.value;

            } else if (e.value > list.get(smallestValue).prev.value) { //if this biggest than the last element (prev of first), this is the new biggest element
                this.list.put(e.value, e); //we add it
                e.next = this.list.get(smallestValue); //next is the smallest element
                e.prev = this.list.get(smallestValue).prev; //previous is the current biggest element (for now prev of the smallest)
                this.list.get(smallestValue).prev.next = e; //next of the biggest (smallest.prev.next) is the new element
                this.list.get(smallestValue).prev = e; //previous of the smallest is the new element

            } else { //somewhere in between (need a for loop)
                int spot = smallestValue;
                while (spot < e.value) {
                    spot = this.list.get(spot).next.value;
                }

                //now we have to put before spot
                this.list.put(e.value, e); //we add it
                e.next = this.list.get(spot); //next is spot
                e.prev = this.list.get(spot).prev; //prev is what spot has for prev (atm)
                this.list.get(spot).prev.next = e; //spots previouses next (next of the element before the new one (was before spot), is now the new one)
                this.list.get(spot).prev = e; //spots prev is now the new element
            }
        }

        this.size++;
    }

    public int remove(int value) { //returns the next after the element that has been removed
        CircularElement killed = this.list.get(value);
        int output = killed.next.value;
        killed.prev.next = killed.next; //we take out the killed one (previous goes to next, next goes back to previous, no killed in betweeen)
        killed.next.prev = killed.prev;

        this.list.remove(value);//we remove it from the list and decrease the side
        this.size--;

        return output;
    }
}

class AoC2016_19 {
    public static int recursiveJosephus(int n, int k) { //if we take the gifts from the one directly left of him, the k is 2 (the second in a row loses the pressents)
        if (n == 1) { //break statement (if only one elf, he keeps all the pressents)
            return 1;
        }
        return (recursiveJosephus(n-1, k) + k-1) %n + 1;
        //we return the same thing, but with first (k-th) element removed
        //we have to add k + 1 (because the new call will consider the k+1th element as the first one)
        //we have to mod by n (%n), so we normalize if we went more than once around the circle
        //we need to add +1 at the end, because we start counting with 1, not with 0 (maybe)
    }

    public static int binaryJosephus(int n) {
        String binStr = Integer.toBinaryString(n);
        String binJos = binStr.substring(1) + binStr.charAt(0); //we move the first element to the end
        //josephus result W(n) = 2*l+1 where n = 2^a + l if l<2^a
        //with bitwise operatins:
        //the first bit is the 2^a (the bigest power of 2 (that is how binary works)), so we remove it (its always 1, the thing that changes is the possition, but we dont care about it here)
        //if we move it to the back we do two things:
        //a) we shift left once (which in binary is equal to multiplying by 2)
        //b) we add 1 to the and (becaue the first bit (that is set) is always one (logically has to be))
        //thus we from n remove 2^a (we are left with l), than we multiply it by 2 and add 1 === 2*l+1 === W(n)
        return Integer.parseInt(binJos, 2); //we have to specify the radix, so it know from what base to pare from
    }

    public static int circularListJosephus(int n) { //this is a bit of an overhead, with two new classes and a new data structure and all, but hey
        CircularLinkedList list = new CircularLinkedList(); //we create and fill the circular linked list
        for (int i=1; i<n+1; i++) {
            list.append(new CircularElement(i));
        }

        int current = 1; //we start at 1st element

        while (list.size > 1) {
            int toRemove = list.list.get(current).next.value; //we remove the element after (left to) the current
            current = list.remove(toRemove);
        }

        return current; //we can address this (list.list) because its all public (bad habit tho)
    }

    //second part
    public static int circularListJosephus2(int n) { //similar as above, but we remove element opposite in circle, not the next one
        CircularLinkedList list = new CircularLinkedList();
        for (int i=1; i<n+1; i++) {
            list.append(new CircularElement(i));
        }

        int current = 1;

        while (list.size > 1) {
            System.out.println(list.size);
            int toRemove = current; //we need a seperate value from current, they arent connected in this version
            
            int numSteps = (list.size/2) - ((list.size/2) % 1); //the element opposti it (works similarly as Math.floor(), but without functions (result - result mod 1 (removing the decimal part)))
            
            for (int i=0; i<numSteps; i++) { //we move numSteps further to remove that element
                toRemove = list.list.get(toRemove).next.value;
            }
            
            list.remove(toRemove); //we remove it
            
            current = list.list.get(current).next.value; //next element to steal is next of the one that stole now (we need to do this after the removal, not to point to a deleted element)
        }

        return current;
    }
    //THIS WORKS, BUT ITS SLOW, VERY SLOW (for loop within a while loop)

    public static int circularListJosephus2andahalf(int n) { //similar as above, but we remove element opposite in circle, not the next one
        //oooo, look at that
        //toRemove goes: current + floor(list.size/2) -> +1 -> +2 -> +1 -> +2 -> ... for even (at begining)
        //or: current + floor(list.size/2) -> +2 -> +1 -> +2 -> +1 -> ... for odd (at begining)

        CircularLinkedList list = new CircularLinkedList();
        for (int i=1; i<n+1; i++) {
            list.append(new CircularElement(i));
        }

        int current = 1; //not actually needed here much

        int numSteps = (list.size / 2) - ((list.size / 2) % 1); //the element opposite the current (similar like Math.floor() but without functions (result minus result mod 1 (= decimal part)))
        //WAIT, IS THIS NEEDED. (5/2=2; 5/2.0=2.5) i think java has whole division (floor based) when using 2 ints

        int toRemove = current;

        for (int i=0; i<numSteps; i++) { //we move numSteps further to remove that element (we set toRemove to the first element to be removed)
            toRemove = list.list.get(toRemove).next.value;
        }

        while (list.size > 1) {
            if (list.size%2 == 0) { //if even, the next to remove will follow directly after
                int nextRemove = list.remove(toRemove);
                toRemove = nextRemove;
                current = nextRemove; //not really current, just some NOT to be deleted value (at the end, its the only other option)
            } else { //if odd, the next to remoe will jump over one element
                int nextRemove = list.remove(toRemove);
                toRemove = list.list.get(nextRemove).next.value; //here is the jump (.next)
                current = nextRemove;
            }
        }

        return current;
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();

        //vars
        int input = 3014603;

        //idea: look up "the josephus problem" and maybe do all 3 solutions (recursive, binary (W(n) = 2*l+1; n = 2^k + l), circular linked list)

        //System.out.println(recursiveJosephus(input, 2)); //k is 2 if we want to take the gifts from the elf left of us (we take is from the second elf from begining)
        //good idead and all, but stack overflow is a thing

        System.out.println("1a. too deep (using recursion)");

        System.out.println("1b. the elf with all the pressents at the end is at position (using binary): " + binaryJosephus(input));

        System.out.println("1c. the elf with all the pressents at the end is at possition (using CircularLinkedList): " + circularListJosephus(input)); //not as fast as binary, but works for second part

        System.out.println("2a. too deep (using recursion)");

        System.out.println("2b. not an elegant and fast operation (using binary)");

        System.out.println("2c. the elf with all the pressents at the end using weird Josephus problem is at possition (using CircularLinkedList): " + circularListJosephus2andahalf(input));
        
        //System.out.println("2a. the elf with all the pressents at the end using weird Josephus problem: " + circularListJosephus2(input));

        long endTime = System.nanoTime();
        System.out.println("Time " + Double.toString((endTime-startTime)/1000000000.0) + " s");
    }
}