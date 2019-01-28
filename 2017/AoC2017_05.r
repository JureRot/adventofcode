input_file = file("input2017_05.txt", "r")
input <- ""
while ( TRUE ) {
  line = as.integer(readLines(input_file, n = 1))
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

#input <- as.integer(c(0, 3, 0, 1, -3))

steps <- 0
i <- 1
last <- length(input)
commands <- input

while (TRUE) {
  steps <- steps + 1
  new_i <- i + commands[i]
  commands[i] <- commands[i] + 1
  if (new_i<1 | new_i>last) {
    break
  } else {
    i <- new_i
  }
}

#part two
steps2 <- 0
i <- 1
last <- length(input)
commands2 <- input

while (TRUE) {
  steps2 <- steps2 + 1
  new_i <- i + commands2[i]
  if (commands2[i] >= 3) {
    commands2[i] <- commands2[i] - 1
  } else {
    commands2[i] <- commands2[i] + 1
  }
  if (new_i<1 | new_i>last) {
    break
  } else {
    i <- new_i
  }
  #DONT WORRY, IT TAKES A FEW SECONDS
}

steps
steps2