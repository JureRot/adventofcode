input_file = file("input2017_16.txt", "r")
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

#input <- c("s1,x3/4,pe/b") #testing input

input <- unlist(strsplit(input, ","))


spin <- function(programs, n) { #spin the programs for n
  temp <- c(programs[(length(programs)-(n-1)):length(programs)], programs[1:(length(programs)-n)])
  
  return(temp)
}

exchange <- function(programs, x, y) { #change the programs in locations x and y
  temp <- programs[x+1]
  programs[x+1] <- programs[y+1]
  programs[y+1] <- temp
  
  return(programs)
}

partner <- function(programs, a, b) { #change programs a and b
  x <- 0
  y <- 0
  
  for (i in 1:length(programs)) { #find the locations of the programs
    if ((x == 0) & (programs[i] == a)) {
      x <- (i - 1)
    }
    
    if ((y == 0) & (programs[i] == b)) {
      y <- (i - 1)
    }
  }
  
  return(exchange(programs, x, y))
}


programs <- c()

for (i in unlist(strsplit(intToUtf8(97:112), ""))) { #create and fill programs (a-p) using ascii codes
  programs <- c(programs, i)
  print(i)
}


for (i in input) {
  func<- substr(i, 1, 1) #first letter in string
  values <- unlist(strsplit(substr(i, 2, nchar(i)), "/"))
  
  if (func == "s") {
    programs <- spin(programs, as.integer(values[1]))
  } else if (func == "x") {
    programs <- exchange(programs, as.integer(values[1]), as.integer(values[2]))
  } else if (func == "p") {
    programs <- partner(programs, values[1], values[2])
  }
}

order <- paste(programs, collapse = "")


#part two

for (bla in 2:1000000000) {
  # for (i in input) {
  #   func<- substr(i, 1, 1) #first letter in string
  #   values <- unlist(strsplit(substr(i, 2, nchar(i)), "/"))
  #   
  #   if (func == "s") {
  #     programs <- spin(programs, as.integer(values[1]))
  #   } else if (func == "x") {
  #     programs <- exchange(programs, as.integer(values[1]), as.integer(values[2]))
  #   } else if (func == "p") {
  #     programs <- partner(programs, values[1], values[2])
  #   }
  # }
  # 
  # #TAKES A WHILE, MAYBE A LITTLE TOO MUCH
  
  #idea, find the cycles (when it comes back to "abcdefghijlkmnop") than go just throug %% cycle lenght
  
}

order2 <- paste(programs, collapse = "")


order

order2