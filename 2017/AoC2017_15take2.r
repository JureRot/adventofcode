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

#input <- c("Generator A starts with 65", "Generator B starts with 8921") #test input

a <- as.integer(unlist(strsplit(input[1], " "))[5])
b <- as.integer(unlist(strsplit(input[2], " "))[5])

match <- 0

for (i in 1:40000000) {
  a <- (a * 16807) %% 2147483647
  b <- (b * 48271) %% 2147483647
  
  if ((a %% 65536) == (b %% 65536)) {
    match <- match + 1
  }
  
  #DONT STRESS, TAKE A BREATH, TAKES A WHILE (like a minute)
}

#part two
a <- as.integer(unlist(strsplit(input[1], " "))[5])
b <- as.integer(unlist(strsplit(input[2], " "))[5])

match2 <- 0


for (i in 1:5000000) {
  
  a <- (a * 16807) %% 2147483647 #change it
  while ((a %% 4) != 0) { #and keep changeing it until is multiple of 4
    a <- (a * 16807) %% 2147483647
  }
  
  b <- (b * 48271) %% 2147483647
  while ((b %% 8) != 0) {
    b <- (b * 48271) %% 2147483647
  }
  
  if ((a %% 65536) == (b %% 65536)) {
    match2 <- match2 + 1
  }
  
  #DONT STRESS, TAKE A BREATH, TAKES A WHILE (like a minute)
}


match

match2