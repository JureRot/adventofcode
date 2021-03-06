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
#   list of layers
#   every layer has name/depth, range, scanner position(starts at 0 (or 1 dont know yet))

severity <- 0

max_depth <- 0

layers <- list()

for (line in input) { #for every line in input, create layer
  line <- as.integer(unlist(strsplit(line, ": ")))
  layers[[as.character(line[1])]] <- list(depth=line[1], range=line[2], scanner=0, direction=1) #default scanner position is 0 and default diretion is positive
  
  if (line[1] > max_depth) { #remember the last layer (for later)
    max_depth <- line[1]
  }
}

for (i in as.character(0:max_depth)) { #walk over layers
  if (!(is.null(layers[[i]]))) { #if the layer exists
    if (layers[[i]]$scanner == 0) { #if the scanner is in 0 position
      severity <- severity + (layers[[i]]$depth * layers[[i]]$range) #add depth * range to severity
    }
  }
  for (l in names(layers)) {
    layers[[l]]$scanner <- layers[[l]]$scanner + layers[[l]]$direction #change scanner of all layers in its direction
    
    if ((layers[[l]]$direction == 1) & (layers[[l]]$scanner == (layers[[l]]$range -1))) { #if positive direction and reached the end, change direction
      layers[[l]]$direction <- layers[[l]]$direction * -1
    }
    
    if ((layers[[l]]$direction == -1) & (layers[[l]]$scanner == 0)) { #if negative direction and reached the beginning, change direction (could be done in one if, but long condition)
      layers[[l]]$direction <- layers[[l]]$direction * -1
    }
  }
}


#part two
delay <- 1500

while (TRUE) {
  collision <- FALSE
  
  for (l in names(layers)) { #reset all layers (scanners and directions)
    layers[[l]]$scanner <- 0
    layers[[l]]$direction <- 1
  }
  
  for (d in 0:delay) { #wait for delay
    for (l in names(layers)) {
      layers[[l]]$scanner <- layers[[l]]$scanner + layers[[l]]$direction
      
      if ((layers[[l]]$direction == 1) & (layers[[l]]$scanner == (layers[[l]]$range -1))) {
        layers[[l]]$direction <- layers[[l]]$direction * -1
      }
      
      if ((layers[[l]]$direction == -1) & (layers[[l]]$scanner == 0)) {
        layers[[l]]$direction <- layers[[l]]$direction * -1
      }
    }
  }
  
  for (i in as.character(0:max_depth)) {
    if (!(is.null(layers[[i]]))) {
      if (layers[[i]]$scanner == 0) { #if the scanner is in 0 position
        collision <- TRUE
        break #we break, check next delay
      }
    }
    for (l in names(layers)) {
      layers[[l]]$scanner <- layers[[l]]$scanner + layers[[l]]$direction
      
      if ((layers[[l]]$direction == 1) & (layers[[l]]$scanner == (layers[[l]]$range -1))) {
        layers[[l]]$direction <- layers[[l]]$direction * -1
      }
      
      if ((layers[[l]]$direction == -1) & (layers[[l]]$scanner == 0)) {
        layers[[l]]$direction <- layers[[l]]$direction * -1
      }
    }
  }
  
  delay <- delay + 1
  print(delay)
  
  if (!collision) { #after the increment because we start with 0
    break
  }
  #THIS SHOULD WORK, BUT IT WOULD TAKE LIKE YEARS
}

severity

delay