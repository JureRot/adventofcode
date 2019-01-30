input_file = file("input2017_08.txt", "r")
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

reg <- list()

for (line in input) {
  line <- gsub(" if ", " ", line) #remove the if
  line <- unlist(strsplit(line, " "))
  
  #line format: (1)reg to change, (2)inc/dec, (3)by how much, (4)reg to compare, (5)operation, (6)number
  
  #check if reg to change and reg to compare exist, if they dont, create them with 0
  #check what is the operation
  #compare reg to compare and number
  #if false, break
  #if inc +, if dec - by how much (how much can be neg, so -- = + or +- = -)
  
  if (is.null(reg[[line[1]]])) { #chekc if mentioned registers already exist, if not init them with 0
    reg[[line[1]]] <- 0
  }
  if (is.null(reg[[line[4]]])) {
    reg[[line[4]]] <- 0
  }
  
  condition <- FALSE
  
  if (line[5] == "<") {
    if (reg[[line[4]]] < as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  } else if (line[5] == ">") {
    if (reg[[line[4]]] > as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  } else if (line[5] == "<=") {
    if (reg[[line[4]]] <= as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  } else if (line[5] == ">=") {
    if (reg[[line[4]]] >= as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  } else if (line[5] == "==") {
    if (reg[[line[4]]] == as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  } else if (line[5] == "!=") {
    if (reg[[line[4]]] != as.integer(reg[[line[6]]])) {
      condition <- TRUE
    }
  }
}