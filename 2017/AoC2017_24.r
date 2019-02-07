input_file = file("input2017_24.txt", "r")
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

input <- c("0/2", "2/2", "2/3", "3/4", "3/5", "0/1", "10/1", "9/10") #testing input

input <- strsplit(input , "/")

build_bridge <- function(comp, bridge, depth, end) {
  next_links <- c()
  
  for (c in names(comp)) {
    if (end %in% comp[[c]]) {
      next_links <- c(next_links, c)
    }
  }
  
  if (length(next_links) == 0) {
    bridge <- c(bridge, "|", bridge[(length(bridge)-depth):(length(bridge)-1)])
    print(bridge)
    print(depth)
    return(bridge)
  }
  
  for(l in next_links) {
    new_comp <- comp
    new_end_index <- 3 - (match(end, new_comp[[l]])) #match (index of match) 1 the result 2, if match 2 the result 1
    new_end <- new_comp[[l]][new_end_index]
    new_comp[[l]] <- NULL #remove the component used
    print(c(bridge[(length(bridge)-depth):length(bridge)]), l)
    new_bridge <- c(bridge[(length(bridge)-depth):length(bridge)], l)
    bridge <- c(bridge, "-", build_bridge(new_comp, new_bridge, depth+1, new_end))
    
    #kako belezmo vse poti
    #AAAAAA, NE RAZUMMM
  }
  
  return(bridge)
}


components <- list()

for (l in 1:length(input)) {
  line <- as.numeric(input[[l]])
  components[[l]] <- c(line[1], line[2])
}

names(components) <- 1:length(components)