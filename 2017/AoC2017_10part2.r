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

#input <- "1,2,4" #testing input

input <- c(utf8ToInt(input), 17, 31, 73, 47, 23) #change input to ascii code and add standard suffix


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

for (bla in 1:64) { #for 64 cycles
  for (i in input) { #for every lenght (includin suffix) we do the same as in part 1
    numbers <- reverse(numbers, indices(position, i, num_len))
    
    position <- (((position-1) + (i + skip)) %% num_len) +1
    skip <- skip + 1
    
  }
}

blocks <- c()

for (i in seq(1, 255, 16)) { #for every block of 16
  b <- numbers[i] #create xor value
  for (j in (i+1):((i-1)+16)) { #for every number within that block
    b <- bitwXor(b, numbers[j]) #bitwise xor it together (to the xor value)
  }
  
  blocks <- c(blocks, b) #add it to the blocks
}

hex <- paste(as.hexmode(blocks), collapse = '') #convert decimal to hex string and join it (already has leading zeros)

print(source("AoC2017_10.r")[1]) #print the part 1 (set working dir)

hex

