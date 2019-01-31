input_file = file("input2017_15.txt", "r")
input <- ""
while ( TRUE ) {
  line = readLines(input_file, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  
  if (input[1] == "") {
    input <- line
  } else {
    input <- c(input, line)  
  }
  
}
close(input_file)

#install.packages("R.utils") #if needed install
library(R.utils)

input <- c("Generator A starts with 65", "Generator B starts with 8921") #test input

a <- as.integer(unlist(strsplit(input[1], " "))[5])
b <- as.integer(unlist(strsplit(input[2], " "))[5])

match <- 0

for (i in 1:40000000) {
  a <- (a * 16807) %% 2147483647
  b <- (b * 48271) %% 2147483647
  
  a_str <- intToBin(a) #convert int to bin string
  a_str <- substr(a_str,(nchar(a_str)+1)-16, nchar(a_str)) #take only the last 16 chars
  b_str <- intToBin(b)
  b_str <- substr(b_str,(nchar(b_str)+1)-16, nchar(b_str))
  
  if (a_str == b_str) {
    match <- match + 1
  }
  
  #DONT STRESS, TAKE A BREATH, TAKES A WHILE (hmmmm, a little too long)
  
  #instead of comparing actual bin strings, compare %% 65536 of the numbers (this is the lowest 16 bits (0Xffff))
}

match