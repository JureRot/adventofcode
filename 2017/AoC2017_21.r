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

#input <- c("../.# => ##./#../...", ".#./..#/### => #..#/..../..../#..#") #test input

input <- gsub("/", "", input)
input <- strsplit(input, " => ")

# this should be fun
# you can create with vector matrix(data, nrow, ncol, byrow)
# you can get submatrix with m[_,_]
# you can get as vector as.numeric(m[,])
# you can transpose t(m[,])
# you can expand matrix with cbind and rbind

# all rotations and flips:
#   as.character(t(neki))
#   as.character(neki[3:1,])
#   as.character(t(neki[3:1, 3:1]))
#   as.character(neki[,3:1])
#   as.character(t(neki[,3:1]))
#   as.character(neki[3:1, 3:1])
#   as.character(t(neki[3:1,]))
#   as.character(neki)


rules <- list()

for (line in input) { #write all rules
  rules[[line[1]]] <- line[2]
}

grid <- matrix(unlist(strsplit(".#...####", "")), nrow=3, ncol=3, byrow=TRUE) #starting grid

print(grid)

for (iter in 1:5) { #for 18 iterations (part two) (should be 18 for part 2)
  new_grid <- NULL
  if (ncol(grid) %% 2 == 0) { #if size divisible by 2 (ncol or nrow is the same because square matrices)
    for (i in 0:((ncol(grid)/2)-1)) {
      new_grid_row <- NULL
      for (j in 0:((nrow(grid)/2)-1)) {
        pattern <- grid[((i*2)+1):((i*2)+2), ((j*2)+1):((j*2)+2)]
        
        if (!is.null(rules[[paste(as.character(t(pattern)), collapse="")]])) { #check for all (rot and flip)
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern)), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[2:1,]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[2:1,]), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[2:1, 2:1])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[2:1, 2:1])), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[,2:1]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[,2:1]), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[,2:1])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[,2:1])), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[2:1, 2:1]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[2:1, 2:1]), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[2:1,])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[2:1,])), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern), collapse="")]], "")), nrow=3, ncol=3, byrow=TRUE)
          
        }
        
        if (is.null(new_grid_row)) { #if this the firs, we create
          new_grid_row <- pattern
          
        } else { #if allready exists, we bind to right (column bind)
          new_grid_row <- cbind(new_grid_row, pattern)
        }
      }
      
      if (is.null(new_grid)) { #if this the first row, we create
        new_grid <- new_grid_row
        
      } else { #if allready exists, we bind to bottom (row bind)
        new_grid <- rbind(new_grid, new_grid_row)
      }
    }
    
  } else if (nrow(grid) %% 3 == 0) { #if size divisible by 3
    for (i in 0:((ncol(grid)/3)-1)) {
      new_grid_row <- NULL
      for (j in 0:((nrow(grid)/3)-1)) {
        pattern <- grid[((i*3)+1):((i*3)+3), ((j*3)+1):((j*3)+3)]
        
        if (!is.null(rules[[paste(as.character(t(pattern)), collapse="")]])) { #check for all (rot and flip)
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern)), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[3:1,]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[3:1,]), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[3:1, 3:1])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[3:1, 3:1])), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[,3:1]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[,3:1]), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[,3:1])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[,3:1])), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern[3:1, 3:1]), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern[3:1, 3:1]), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(t(pattern[3:1,])), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(t(pattern[3:1,])), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        } else if (!is.null(rules[[paste(as.character(pattern), collapse="")]])) {
          pattern <- matrix(unlist(strsplit(rules[[paste(as.character(pattern), collapse="")]], "")), nrow=4, ncol=4, byrow=TRUE)
          
        }
        
        if (is.null(new_grid_row)) { #if this the firs, we create
          new_grid_row <- pattern
          
        } else { #if allready exists, we bind to right (column bind)
          new_grid_row <- cbind(new_grid_row, pattern)
        }
      }
      
      if (is.null(new_grid)) { #if this the first row, we create
        new_grid <- new_grid_row
        
      } else { #if allready exists, we bind to bottom (row bind)
        new_grid <- rbind(new_grid, new_grid_row)
      }
    }
  }
  
  grid <- new_grid

  if (iter == 5) { #if fifth iteration
    num_lit <- length(grid[grid == "#"]) #number of cels lit (where gird is #)
  }
  
  
  #THIS WORK BUT ITS SLOW (like a minute)
  #could rewrite this (after 3 iterations a 3x3 becomes 9 independent 3x3 blocks) (but maybe some other time)
}

num_lit2 <- length(grid[grid == "#"]) #number of cels lit for part two


num_lit

num_lit2