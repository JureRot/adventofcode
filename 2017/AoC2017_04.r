input_file = file("input2017_04.txt", "r")
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

input <- strsplit(input, " ")

num_valid <- 0

num_valid2 <- 0

for (line in input) { #for every line in input
  line_len <- length(line)
  
  found <- FALSE
  
  for (i in 1:(line_len-1)) {
    for (j in (i+1):line_len) { #for every combo of two words
      if (line[i] == line[j]) { #if they are the same, we mark as found
        found <- TRUE
        break
      }
    }
    if (found) break
  }
  
  if (!found) { #none maching weere found, we add as valid
    num_valid <- num_valid + 1
  }
  
  
  #second part
  found2 <- FALSE
  
  for (i in 1:(line_len-1)) {
    for (j in (i+1):line_len) {
      a <- sort(unlist(strsplit(line[i], ""))) #for each word we make sorted vector of chars
      b <- sort(unlist(strsplit(line[j], "")))
      
      if (length(a) == length(b)) { #if lenghts match (cant compare different lengths)
        if (all(a==b)) { #if all charctres match (is an anagram)
          found2 <- TRUE #we mark it
          break
        }
      }
    }
    if (found2) break
  }
  
  if (!found2) { #none maching weere found, we add as valid
    num_valid2 <- num_valid2 + 1
  }
  
}

num_valid
num_valid2