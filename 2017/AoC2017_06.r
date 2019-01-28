input_file = file("input2017_06.txt", "r")
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

input <- as.integer(unlist(strsplit(input, "\t")))
#input <- as.integer(c(0, 2, 7, 0)) #testing input

seen <- paste(input, collapse = ",") #joins the states of banks into string (state of all postitions)

cycles <- 0
found <- FALSE
input_len <- length(input)

while (!found) {
  cycles <- cycles + 1
  
  node <- which.max(input)
  amount <- input[node]
  
  input[node] <- 0
  
  for (i in 1:amount) {
    node <- (((node-1) + 1) %% input_len)+1
    
    input[node] <- input[node] + 1
  }
  
  hash <-  paste(input, collapse = ",")
  if (hash %in% seen) {
    found <- TRUE
    break
  } else {
    seen <- c(seen, hash)
  }
}

loop_len <- (length(seen)+1) - match(hash, seen) #last element in seen should be the repeated state (thats why we add +1) and subtract the postiton of the first appearance (the match)

cycles #we could just use length(seen) because is the same value
loop_len
