input_file = file("input2017_10.txt", "r")
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

#input <- "3,4,1,5" #testing input

input <- as.integer(unlist(strsplit(input, ",")))

indices <- function(start, len, max) { #returns a vector of indides to reverse 
  if (len == 0) { #if 0 just break
    return(integer())
  }
  
  end <- (((start-1) + (len-1)) %% max) +1 #calculate what end woul is (accounting for wrapping and index starting with 1) (len-1 is because r includes the last value (1:n))
  
  index <- start:end #prematurely set it (could be incorrect)
  
  if (end < start) { #if end smaller than start (its incorrect), we correct it)
    index <- c(start:max, 1:end)
  }
  
  return(index)
}

reverse <- function(numbers, index) { #reverses the values of numbers within index
  if (length(index) > 1) { #if more than 1 index (if one the reversing chnages nothing)
    for (i in 1:floor((length(index) / 2))) { #indexes of just the first half (for other half will look from behind)
      temp <- numbers[index[i]]
      numbers[index[i]] <- numbers[index[(length(index)-i)+1]] #switch first for last
      numbers[index[(length(index)-i)+1]] <- temp #switch last for first
    }
  }
  
  
  return(numbers)
}


position <- 1
skip <- 0

numbers <- 0:255 #list of numbers (change to 0:255)
num_len <- length(numbers)

for (i in input) { #for every lenght
  numbers <- reverse(numbers, indices(position, i, num_len)) #we reverse the numbers between the position and lenght
  
  position <- (((position-1) + (i + skip)) %% num_len) +1 #we change the position
  skip <- skip + 1 #we increase the skip
  
}

#the part two is insane (other file)

numbers[1] * numbers[2]