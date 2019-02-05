input_file = file("input2017_22.txt", "r")
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

#input <- c("..#", "#..", "...") #test input


grid <- new.env() #string(x),string(y) (comma separator) names

for (l in 1:length(input)) { #mark all infected in input
  line <- unlist(strsplit(input[l], ""))
  for (c in 1:length(line)) {
    if (line[c] == "#") {
      grid[[paste(c(c, l), collapse=",")]] <- "i"
    }
  }
}

x <- ceiling(length(input)/2) #middle of columns (half of num rows)
y <- ceiling(nchar(input[1])/2) #middle of rows (half of num columns)
dir <- 1 #0:right(+x), 1:up(-y), 2:left(-x), 3:down(-y) (default poiting up)

infestations <- as.numeric(0)

for (burst in 1:10000) {
  name <- paste(c(x,y), collapse=",")
  current <- grid[[name]]
  
  if (!is.null(current)) { #if current is infected
    dir <- (dir - 1) %% 4 #turn right
    
    grid[[name]] <- NULL #remove it (thus make it clean)
    
  } else { #if clean
    dir <- (dir + 1) %% 4 #turn left
    
    grid[[name]] <- "i" #add it as infected
    infestations <- infestations + 1 #keep track of number of infestations
  }
  
  #change position
  if (dir == 0) { #if facing right
    x <- x + 1
  } else if (dir == 1) { #if facing up
    y <- y - 1
  } else if (dir == 2) { #if facing left
    x <- x - 1
  } else if (dir == 3) { #if facing down
    y <- y + 1
  }
}


#take two
grid <- new.env() #string(x),string(y) (comma separator) names

for (l in 1:length(input)) { #mark all infected in input
  line <- unlist(strsplit(input[l], ""))
  for (c in 1:length(line)) {
    if (line[c] == "#") {
      grid[[paste(c(c, l), collapse=",")]] <- "i"
    }
  }
}

x <- ceiling(length(input)/2) #middle of columns (half of num rows)
y <- ceiling(nchar(input[1])/2) #middle of rows (half of num columns)
dir <- 1 #0:right(+x), 1:up(-y), 2:left(-x), 3:down(-y) (default poiting up)

infestations2 <- as.numeric(0)

for (burst2 in 1:10000000) {
  name <- paste(c(x,y), collapse=",")
  current <- grid[[name]]
  
  if (is.null(current)) { #current clear
    #turn left
    dir <- (dir + 1) %% 4
    
    #becomes weakened
    grid[[name]] <- "w"
    
  } else if (current == "w") { #current weakened
    #doesnt turn
    
    #weakened becomes infected
    grid[[name]] <- "i"
    
    #note number of infestations
    infestations2 <- infestations2 + 1
    
  } else if (current == "i") { #current infected
    #turn right
    dir <- (dir - 1) %% 4
    
    #infected becomes flagged
    grid[[name]] <- "f"
    
  } else if (current == "f") { #current flagged
    #reverse dir
    dir <- (dir + 2) %% 4
    
    #flagged becomes clean
    grid[[name]] <- NULL
  }
  
  #change position
  if (dir == 0) { #if facing right
    x <- x + 1
  } else if (dir == 1) { #if facing up
    y <- y - 1
  } else if (dir == 2) { #if facing left
    x <- x - 1
  } else if (dir == 3) { #if facing down
    y <- y + 1
  }
  
  #STILL SLOW BUT BEARALBE (about 90 sec)
}

infestations

infestations2
