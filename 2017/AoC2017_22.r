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

input <- c("..#", "#..", "...") #test input


infected <- c() #string(x),string(y) (comma separator)

for (l in 1:length(input)) { #mark all infected in input
  line <- unlist(strsplit(input[l], ""))
  for (c in 1:length(line)) {
    if (line[c] == "#") {
      infected <- c(infected, paste(c(c, l), collapse=","))
    }
  }
}

x <- ceiling(length(input)/2) #middle of columns (half of num rows)
y <- ceiling(nchar(input[1])/2) #middle of rows (half of num columns)
dir <- 1 #0:right(+x), 1:up(-y), 2:left(-x), 3:down(-y) (default poiting up)

infestations <- 0


for (burst in 1:10000) {
  current_infected <- paste(c(x,y), collapse=",") %in% infected
  
  if (current_infected) { #if current is infected
    dir <- (dir - 1) %% 4 #turn right
    
    to_rm <- match(paste(c(x, y), collapse=","), infected) #find the index of node in infected
    infected <- infected[-to_rm] #remove it
    
  } else { #if clean
    dir <- (dir + 1) %% 4 #turn left
    
    infected <- c(infected, paste(c(x, y), collapse=",")) #curent becomes infected
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
infected <- c() #redo the infected

for (l in 1:length(input)) { #mark all infected in input
  line <- unlist(strsplit(input[l], ""))
  for (c in 1:length(line)) {
    if (line[c] == "#") {
      infected <- c(infected, paste(c(c, l), collapse=","))
    }
  }
}

weakened <- c() #add weakened and flagged
flagged <- c()

infestations2 <- 0

for (burst2 in 1:10000000) {
  current_weakened <- paste(c(x,y), collapse=",") %in% weakened
  current_infected <- paste(c(x,y), collapse=",") %in% infected
  current_flagged <- paste(c(x,y), collapse=",") %in% flagged
  
  if (current_weakened) { #current weakened
    #doesnt turn
    
    #weakened becomes infected
    to_rm <- match(paste(c(x, y), collapse=","), weakened) #find the index of node
    weakened <- weakened[-to_rm] #remove it
    infected <- c(infected, paste(c(x, y), collapse=",")) #add to infected
    
    infestations2 <- infestations2 + 1 #keep track of number of infestations
    
  } else if (current_infected) { #current infected
    dir <- (dir - 1) %% 4 #turn right
    
    #infected becomes flagged
    to_rm <- match(paste(c(x, y), collapse=","), infected) #find the index of node
    infected <- infected[-to_rm] #remove it
    flagged <- c(flagged, paste(c(x, y), collapse=",")) #add to flagged
    
  } else if (current_flagged) { #current flagged
    dir <- (dir + 2) %% 4 #reverse dir
    
    #flagged becomes clean
    to_rm <- match(paste(c(x, y), collapse=","), flagged) #find the index of node
    flagged <- flagged[-to_rm] #remove it
    
  } else { #current clean
    dir <- (dir + 1) %% 4 #turn left
    
    #becomes weakened
    weakened <- c(weakened, paste(c(x, y), collapse=","))
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
  
  #THIS TAKES A WHILE (like a too much)
  #try to actually use grid (list) and if clean is.null, else has value, delete with <- NULL
}

infestations

infestations2