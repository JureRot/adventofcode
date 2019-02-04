input_file = file("input2017_21.txt", "r")
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

input <- c("../.# => ##./#../...", ".#./..#/### => #..#/..../..../#..#") #test input

# this should be fun
# you can create with vector matrix(data, nrow, ncol, byrow)
# you can get submatrix with m[_,_]
# you can get as vector as.numeric(m[,])
# you can transpose t(m[,])
# you can expand matrix with cbind and rbind

# all rotations and flips:
#   as.numeric(t(neki))
#   as.numeric(neki[3:1,])
#   as.numeric(t(neki[3:1, 3:1]))
#   as.numeric(neki[,3:1])
#   as.numeric(t(neki[,3:1]))
#   as.numeric(neki[3:1, 3:1])
#   as.numeric(t(neki[3:1,]))
#   as.numeric(neki