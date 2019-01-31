input_file = file("input2017_13.txt", "r")
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

#input <- c("0: 3", "1: 2", "4: 4", "6: 4") #test input

# idea:
#   we dont need to actually simulate the scanner moving, we could just calculate if it is on 0

layers <- list() #format: list(depth, range) (scanner postition will be calculated)

severity <- 0

for (l in 1:length(input)) { #create layers list
  line <- input[l]
  line <- as.integer(unlist(strsplit(line, ": ")))
  layers[[l]] <- list(depth=line[1], range=line[2])
}

for (n in layers) {
  if ((n$depth %% (2*(n$range-1))) == 0) { #if mod is 0, means the scanner is in the first position (at the top) and would cause a collision
    severity <- severity + (n$depth * n$range)
  }
}

#part two

delay <- 0

while (TRUE) { #we dont need to simulate the movement, we just add the delay
  collision <- FALSE
  
  for (n in layers) {
    if (((n$depth+delay) %% (2*(n$range-1))) == 0) { #if collision occurs we break
      collision <- TRUE
      break
    }
  }
  
  if (!collision) { #if we went through all layers without collision
    break
  }
  
  delay <- delay + 1
  
  #DONT STRESS, IT TAKES A FEW SECONDS
}

severity

delay