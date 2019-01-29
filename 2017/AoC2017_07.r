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
#   nodes are named (not numbered sequentially)
#   nodes are lists with name, weight, name of parent, name of child