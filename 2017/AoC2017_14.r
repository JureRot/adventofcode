knot_hash_as_bin <- function(string) { #based on AoC2017_10part2.r
  #takes string input, makes knot hash, returns binary representation of hex hash
  
  #install.packages("R.utils") #if needed install
  library(R.utils)
  
  indices <- function(start, len, max) {
    if (len == 0) {
      return(integer())
    }
    end <- (((start-1) + (len-1)) %% max) +1
    index <- start:end
    if (end < start) {
      index <- c(start:max, 1:end)
    }
    return(index)
  }
  
  reverse <- function(numbers, index) {
    if (length(index) > 1) {
      for (i in 1:floor((length(index) / 2))) {
        temp <- numbers[index[i]]
        numbers[index[i]] <- numbers[index[(length(index)-i)+1]] 
        numbers[index[(length(index)-i)+1]] <- temp
      }
    }
    return(numbers)
  }
  
  string <- c(utf8ToInt(string), 17, 31, 73, 47, 23)
  position <- 1
  skip <- 0
  numbers <- 0:255 #list of numbers (change to 0:255)
  num_len <- length(numbers)
  blocks <- c()
  
  for (bla in 1:64) { #for 64 cycles
    for (i in string) { #for every lenght (includin suffix) we do the same as in part 1
      numbers <- reverse(numbers, indices(position, i, num_len))
      
      position <- (((position-1) + (i + skip)) %% num_len) +1
      skip <- skip + 1
      
    }
  }
  
  for (i in seq(1, 255, 16)) { #for every block of 16
    b <- numbers[i] #create xor value
    for (j in (i+1):((i-1)+16)) { #for every number within that block
      b <- bitwXor(b, numbers[j]) #bitwise xor it together (to the xor value)
    }
    
    blocks <- c(blocks, b) #add it to the blocks
  }
  
  hex <-unlist(strsplit(paste(as.hexmode(blocks), collapse = ''), ""))
  
  hex_bin_string <- ""
  
  for (h in hex) { #for each hex char in hash (not hex number (2 characters))
    fk_me <- paste(c("0x", h), collapse="") #add 0x too hex char (letters [a-f] can be seen as hex codes)
    fk_me <- strtoi(fk_me) #convert hex char [0-f] to integer [0-15]
    fk_me <- intToBin(fk_me) #convert int to binary string (using R.utils package)
    fk_me <- as.integer(fk_me) #converts bin string to int (as characters (101), not as bin (2^2+2^0 = 5)))
    fk_me <- sprintf("%04d", fk_me) #add leading zeros (%, char_to_add, till_len, number(fk_me))
    
    #neki <- sprintf("%04d", as.integer(intToBin(strtoi(paste(c("0x", h), collapse=""))))) #one line
    #print(neki)
    
    #THIS SHOULD BE SIMPLER
    
    hex_bin_string <- paste(c(hex_bin_string, fk_me), collapse="")
  }
  
  return(as.integer(unlist(strsplit(hex_bin_string, ""))))
}

input <- "ljoxqyyw"

#input <- "flqrgnkx" #testing input

num_used <- 0
grid_data <- c()

for (i in as.character(0:127)) {
  row <- paste(c(input, c("-", i)), collapse="") #add -i (row number) to the end of input string)
  grid_data <-c(grid_data, knot_hash_as_bin(row)) #add the line to grid_data
  
  #DONT STRESS, TAKES A WHILE
}

grid <- matrix(data=grid_data, nrow=128, ncol=128, byrow=TRUE) #construct matrix, by row of grid data
num_used <- sum(grid) #count the number used

#part two

region <- 2
regions <- matrix(data=rep(0, 128*128), nrow=128, ncol=128, byrow=TRUE) #make zeros(128,128) empty matrix


# region labeling algorithm
for (i in 1:nrow(grid)) { 
  for (j in 1:ncol(grid)) {
    if (grid[i,j] == 1) { #if current element is foreground (part of region)
      #if none neighbors are regions (add 1 to num region, mark as region, increase region)
      #if only one or both the same (mark as that)
      #if both and not same (mark as smallest, decerase num_regions)
      
      up <- 0
      left <- 0
      
      if (i > 1) { #if not on the top edge
        up <- regions[(i-1), j]
      }
      
      if (j > 1) { #if not on the left edge
        left <- regions[i, (j-1)]
      }
      
      if ((up==0) & (left==0)) { #no neightbors are foreground (this is a new region)
        regions[i, j] <- region #set the region 
        region <- region + 1 #increase the region (name for next region)
        
      } else if ((up!=0) & (left!=0)) { #both neighbors are foreground
        if (up == left) { #both neighbors are of same region
          regions[i, j] <- left #dont change region and num_region (because its not a new region)
          
        } else { #neighbors have different values (different regions) collision
          regions[i, j] <- min(up, left) #set as the smallest region
          regions[regions == max(up,left)] = min(up, left) #change all of one (bigger) region to the other (smalle) (make both regions one) (thus no more collision in the future)
          
        }
      } else if ((up!=0) | (left!=0)) { #if any neighbor is foreground
        regions[i, j] <- max(up, left) #use the bigger one (other will be 0)
      }
    }
  }
}

num_regions <- length(unique(as.vector(regions))) - 1 #-1 to remove the zeros, where there is no region


num_used

num_regions
