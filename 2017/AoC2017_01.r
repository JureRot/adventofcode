input_file = file("input2017_01.txt", "r")
input <- ""
while ( TRUE ) {
  line = readLines(input_file, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  #print(line)
  if (input == "") {
    input <- line
  } else {
    input <- c(input, line)  
  }
  
}
close(input_file)
#input <- "91212129" #test input
input <- strsplit(input, "") #splits input file into list
input <- unlist(input[1]) #unlists the first line (makes a character vector)
input <- as.integer(input) #changes vector of chars to vector of ints

n <- length(input)
summara <- 0
half <- n/2
summara2 <- 0

for (i in 1:n) { #go over all elements (all letters)
  if (input[i] == input[(((i-1)+1)%%n)+1]) {
    #i-1 and +1 at the end is because we count from 1 forward (not from 0)
    #then it is the +1 (next element)
    #and after that the %%n (the modulo of number of elements (length))
    summara <- summara + input[i]
  }
  
  #second part
  if (input[i] == input[(((i-1)+half)%%n)+1]) { #increase by half of len (instead of 1)
    summara2 <- summara2 + input[i]
  }
}

summara
summara2