input_file = file("input2017_23.txt", "r")
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

input <- strsplit(input, " ")

get_value <- function(registers, x) {#gets value of x, number or register
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    value <- registers[[x]]
  }
  
  return(value)
}

set <- function(registers, x, y) { #sets reg x with value y
  registers[[x]] <- get_value(registers, y)
  return(registers)
}

sub <- function(registers, x, y) { #decrease the value of reg x by value of y
  registers[[x]] <- registers[[x]] - get_value(registers, y)
  return(registers)
}

mul <- function(registers, x, y) { #multiplies the value of reg x by value of y
  registers[[x]] <- registers[[x]] * get_value(registers, y)
  return(registers)
}

jnz <- function(registers, x, y) { #if value of x not zero, we jump with offset y (plus or minus)
  offset <- 1 #default offset is one (just go to next command)
  if (get_value(registers, x) != 0) { #if value of x greater than zero we change value of offset
    offset <- get_value(registers, y)
  }
  return(offset)
}


registers <- new.env()

for (r in c("a", "b", "c", "d", "e", "f", "g", "h")) { #we init all registers with zeros
  registers[[r]] <- 0
}

num_mul <- 0

i <- 1

while((i >= 1) & (i <= length(input))) {
#for (bla in 1:1000) {
  if (input[[i]][1] == "set") {
    registers <- set(registers, input[[i]][2], input[[i]][3])
    i <- i + 1
  } else if (input[[i]][1] == "sub") {
    registers <- sub(registers, input[[i]][2], input[[i]][3])
    i <- i + 1
  } else if (input[[i]][1] == "mul") {
    registers <- mul(registers, input[[i]][2], input[[i]][3])
    i <- i + 1
    num_mul <- num_mul + 1
  } else if (input[[i]][1] == "jnz") {
    i <- i + jnz(registers, input[[i]][2], input[[i]][3])
  }
  
  #takes a few seconds
  
}


#part two

# would take way to long to actually run, so we need to understand what the program is actually doing and optimise
# this is explaned in analysis2017_23part2.txt

b <- 109300
c <- 126300
d <- 0
h <- 0

while (TRUE) {
  f <- TRUE
  
  for (d in 2:(b-1)) {
    if ((b%%d) == 0) {
      f <- FALSE
      break
    }
  }
  
  if (!f) {
    h <- h + 1
  }
  
  if (b == c) {
    break
  }
  
  b <- b + 17
}


num_mul

h