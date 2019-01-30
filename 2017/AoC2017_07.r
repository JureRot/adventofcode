input_file = file("input2017_07.txt", "r")
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

# node <- list(name, weight, parent, child) (maybe need a sequential number instead of name)
# tree <- matrix(list, nrow=1, byrow=TRUE)
# tree <- rbind(matrix, new_node)

#other option is OOP (s3, s4, reference class) (s3 is the basic)

# idea:
#   make a list of nodes (lists)
#   nodes are named (not numbered sequentially
#   nodes are lists with name, weight, name of parent, name of child

tree <- list()

for (line in input) { #first we just add all the nodes (leaves or not)
  line <- gsub("[/(|/)]", "", line)
  line <- gsub(" -> ", " ", line)
  line <- gsub(",", "", line)
  line <- unlist(strsplit(line, " "))
  
  tree[[line[1]]] <- list(name=line[1], weight=as.integer(line[2]), parent="", child=list()) #parent for now empty
  
}

for (line in input) { #than we set the children and parents
  line <- gsub("[/(|/)]", "", line)
  line <- gsub(" -> ", " ", line)
  line <- gsub(",", "", line)
  line <- unlist(strsplit(line, " "))
  
  if (length(line) > 2) { #if we have info of children
    tree[[line[1]]]["child"] <- list(line[3:length(line)]) #we add the child vector for this node
    for (c in line[3:length(line)]) { #and set the paren of all the children
      tree[[c]]["parent"] <- line[1]
    }
  }
}

node <- line[1] #any node will point to root (we take the last used, the last in input)


while (tree[[node]]$parent != "") { #while parent not empty
  node <- tree[[node]]$parent #we traverse the tree
}

root <- node #solution for part one, also the root node

#part two

get_weight <- function(tree, node) { #recusevily gets weight of node (and its children)
  if (length(tree[[node]]$child) == 0) { #if no children, just return its weight
    return(tree[[node]]$weight)
  } else {
    child_weight <- 0
    for (c in tree[[node]]$child) { #else recursively add the weights of the children
      child_weight <- child_weight + get_weight(tree, c)
    }
    return(tree[[node]]$weight + child_weight)
  }
}

visited <- node #stack for DFS
#cant use BFS because we need to find the deepst one that is unballanced
#every node from root to the actual unbalanced one will be unbalanced (when we correct the last one, all will be ballanced)

unbalanced <- visited[1]
correct_value <- 0

while (TRUE) {
  child_weight <- NULL
  child_names <- NULL
  for (c in tree[[unbalanced]]$child) { #get weights and names of all children
    child_weight <- c(child_weight, get_weight(tree, c))
    child_names <- c(child_names, c)
  }
  
  if (length(unique(child_weight)) > 1) { #if all weights not the same (more than one unique)
    big <- which.max(child_weight) #we get the position of the big one
    unbalanced <- child_names[big] #change the name of unballanced (step deeper)
    correct_value <- tree[[child_names[big]]]$weight - (max(child_weight) - min(child_weight)) #correct the value it should be (its weight minus the diff between other noded (how much it should have been))
    
    #WE ASSUME THE UNBALANCED NODE WILL BE BIGGER THAN THE REST ON THE DISC (else more ifs)
  } else { #if the child is balanced, we break, because we found the last (deepest) unbalanced node
    break
  }
  
}

root

correct_value