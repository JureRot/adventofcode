input_file = file("input2017_11.txt", "r")
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

#input <- "se,sw,se,sw,sw" #testing input

input <- unlist(strsplit(input, ","))

#ce se ne motm ne rabm formirat grida, samo stejem smeri in se pol odstevajo al neki
#3 vektorji, x:levogor(+nw, -se), y:gor(+n, -s), z:desno gor(+ne, -sw)
#na konc se te vektroje zdruz x + z = y,  x - z = 0, x - y = -z, z - y = -x pa take

get_hex_dist <- function(x, y, z) {
  while (x>0 & z>0) { #upleft and upright is equal to just up
    x <- x - 1
    z <- z - 1
    y <- y + 1
  }
  
  while (x<0 & z<0) { #downleft and downright is equal to just down
    x <- x + 1
    z <- z + 1
    y <- y - 1
  }
  
  while((x * y) < 0) { #if upleft and up different sign, we can combine them into one upright
    if (x < 0) { #up and downright (negative upleft) -> upright
      x <- x + 1 #remove negative upleft (thats why the plus)
      y <- y - 1 #remove up
      
      z <- z + 1 #add upright
      
    } else { #down (negative up) and upleft -> downleft (negative upright)
      x <- x - 1 #remove upleft
      y <- y + 1 #remove negative up
      
      z <- z - 1 #add negative upright
    }
  }
  
  while((z * y) < 0) { #if uprigth and up different sign, we can combine them into one upleft
    if (z < 0) {
      z <- z + 1
      y <- y - 1
      
      x <- x + 1
      
    } else {
      z <- z - 1
      y <- y + 1
      
      x <- x - 1
    }
  }
  
  return(sum(abs(x), abs(y), abs(z)))
}

x <- 0
y <- 0
z <- 0

distance <- 0

#part two
furthest <- 0

for (i in input) {
  if (i == "nw") {
    x <- x + 1
  } else if (i == "n") {
    y <- y + 1
  } else if (i == "ne") {
    z <- z + 1
  } else if (i == "sw") {
    z <- z - 1
  } else if (i == "s") {
    y <- y - 1
  } else if (i == "se") {
    x <- x - 1
  }
  
  distance <- get_hex_dist(x, y, z) # calculate distance for second part, otherwise we could just do it once at the end
  
  if (distance > furthest) {
    furthest <- distance
  }
}


distance

furthest