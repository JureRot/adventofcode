input_file = file("input2017_12.txt", "r")
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

#input <- c("0 <-> 2", "1 <-> 1", "2 <-> 0, 3, 4", "3 <-> 2, 4", "4 <-> 2, 3, 6", "5 <-> 6", "6 <-> 4, 5") #test input

nodes <- list()

for (line in input) {
  line <- gsub(" <-> ", ", ", line)
  line <- unlist(strsplit(line, ", "))
  
  nodes[[line[1]]] <- line[2:length(line)]
}

group <- "0"
queue <- "0"

while (length(queue) > 0) { #BFS over "0" group
  for (child in nodes[[queue[1]]]) {
    if (!(child %in% group)) { #if child not already visited (avoid cycles)
      group <- c(group, child)
      queue <- c(queue, child)
    }
  }
  
  queue <- queue[-1] #remove the first element of vector (better than <- queue[2:len()])
}

group_size <- length(group)

#part two (go from 0:1999 and when added to group make them null in nodes (than is.null(nodes[[]])))

num_groups <- 0

for (i in as.character(0:length(input))) { #programs named sequentually from 0 ->
  if (!(is.null(nodes[[i]]))) { #node set to null (already in another group)
    num_groups <- num_groups + 1 #this node part of new group (increase the group count)
    
    #this part is same as part one (we BFS over the group)
    group <- i
    queue <- i
    
    while (length(queue) > 0) {
      for (child in nodes[[queue[1]]]) {
        if (!(child %in% group)) {
          group <- c(group, child)
          queue <- c(queue, child)
        }
      }
      
      nodes[[queue[1]]] <- NULL #remove the element from nodes (because allready in this group)
      queue <- queue[-1]
      
    }
  }
}

group_size

num_groups