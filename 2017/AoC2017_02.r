input_file = file("input2017_02.txt", "r")
input <- ""
while ( TRUE ) {
  line = readLines(input_file, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  #print(line)
  if (input[1] == "") {
    input <- line
  } else {
    input <- c(input, line)  
  }
  
}
close(input_file)
#input <- "91212129" #test input
input <- strsplit(input, "\t") #splits input file into list

checksum <- 0
checksum2 <- 0

for (l in 1:length(input)) { #for every line of input (thinking now, this could be done while reading the file)
  line <- as.integer(unlist(input[[l]])) #chane it from list to vector and change values from strings to integers
  
  checksum <- checksum + (line[which.max(line)] - line[which.min(line)]) #which.min/max returns the location of the element
  
  #second part
  line_len <- length(line)
  for (i in 1:(line_len-1)) { #for every combo of two numbers in a row
    for (j in (i+1):line_len) {
      if (line[i] > line[j]) { #check which bigger
        if (line[i]%%line[j] == 0) { #if remainder is 0 (is divisible)
          checksum2 <- checksum2 + (line[i] / line[j])
        }
      } else {
        if (line[j]%%line[i] == 0) {
          checksum2 <- checksum2 + (line[j] / line[i])
        }
      }
    }
  }
}

checksum
checksum2