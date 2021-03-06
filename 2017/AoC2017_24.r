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

build_bridge <- function(comp, bridges, current, end) {
  #gets list of components, list of bridges, vector of curent bridge, value of last connector to match
  #recursively adds all possible bridges to the list of bridges and returns it
  next_links <- c()
  
  for (c in names(comp)) { #get all possible componetns that match (have conector of same value as end)
    if (end %in% comp[[c]]) {
      next_links <- c(next_links, c) #add them to the list of next links
    }
  }
  
  for(l in next_links) { #for every possible next link
    new_comp <- comp #for save-keeping
    new_end_index <- 3 - (match(end, new_comp[[l]])) #match (index of match) 1 the result 2, if match 2 the result 1
    new_end <- new_comp[[l]][new_end_index] #value of ther connector in compoent becomes new end
    new_comp[[l]] <- NULL #remove the component used
    new_current <- c(current, l) #add this component to the list of current
    bridges[[as.character(length(bridges)+1)]] <- new_current #add current to the list of all possible bridges
    bridges <- build_bridge(new_comp, bridges, new_current, new_end) #recrusively do the same for subbridges
  }
  
  return(bridges) #return all possible bridges
  #one call of this fuction will return all possible bridges
  #end condition is build in, func does nothingin if no next links
}


components <- list()

for (l in 1:length(input)) { #create a list of all components
  line <- as.numeric(input[[l]])
  components[[l]] <- c(line[1], line[2])
}
names(components) <- 1:length(components) #and add them names

#TAKES QUITE A WHILE
all_bridges <- build_bridge(components, list(),  c(), 0) #buid all possible bridges
#deep recursion, maybe the wrong choice, too much overhead
#bad bridges shoule be trimmed ahead of time, A*???

strongest <- 0
strongest_name <- NULL

for (b in all_bridges) { #go over all bridges
  strength <- 0
  for (c in b) { #and sum all compoonents streghts
    strength <- strength + sum(components[[c]])
  }
  
  if (strength > strongest) { #and if strongest than prev best, we change
    strongest <- strength
    strongest_name <- b
  }
}

strongest
