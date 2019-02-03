input_file = file("input2017_19.txt", "r")
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

input <- strsplit(input, "")

end <- FALSE
letters <- c()

x <- 1 #horizontal
y <- 1 #vertcal
dir <- 3 #0:right, 1:up, 2:left, 3:down (for the first it will be down)

#part two
len <- 0

for (s in 1:length(input[[1]])) { #get the first value (where we step in at the top (top row))
  if (input[[1]][s] == "|") {
    x <- s
    break
  }
}

while (!end) {
  if (grepl("[a-zA-Z]", input[[y]][x])) { #if current location is  letter, we add it to path
    letters <- c(letters, input[[y]][x])
  }
  
  len <- len + 1 #momatter what we increse the len
  
  if (dir == 0) { #heading rigth
    if (input[[y]][x+1] == "+") { #if corner
      x <- x + 1 #we move forward, and need to check which direction we are going next
      if (input[[y-1]][x] != " ") { #if up anything (path or letter) 
        dir <- 1
      } else if (input[[y+1]][x] != " ") { #if down anything (path or letter)
        dir <- 3
      }
    } else if (input[[y]][x+1] == " ") { #if nothing after
      end <- TRUE
    } else { #if anything else (path, letter, crossing)
      x <- x + 1
    }
  } else if (dir == 1) { #heading up
    if (input[[y-1]][x] == "+") { #if corner
      y <- y - 1 #we move forward, and need to check which direction we are going next
      if (input[[y]][x-1] != " ") { #if left anything (path or letter) 
        dir <- 2
      } else if (input[[y]][x+1] != " ") { #if right anything (path or letter)
        dir <- 0
      }
    } else if (input[[y-1]][x] == " ") { #if nothing after
      end <- TRUE
    } else { #if anything else (path, letter, crossing)
      y <- y - 1
    }
  } else if (dir == 2) { #heading left
    if (input[[y]][x-1] == "+") { #if corner
      x <- x - 1 #we move forward, and need to check which direction we are going next
      if (input[[y-1]][x] != " ") { #if up anything (path or letter) 
        dir <- 1
      } else if (input[[y+1]][x] != " ") { #if down anything (path or letter)
        dir <- 3
      }
    } else if (input[[y]][x-1] == " ") { #if nothing after
      end <- TRUE
    } else { #if anything else (path, letter, crossing)
      x <- x - 1
    }
  } else if (dir == 3) { #heading down
    if (input[[y+1]][x] == "+") { #if corner
      y <- y + 1 #we move forward, and need to check which direction we are going next
      if (input[[y]][x-1] != " ") { #if left anything (path or letter) 
        dir <- 2
      } else if (input[[y]][x+1] != " ") { #if right anything (path or letter)
        dir <- 0
      }
    } else if (input[[y+1]][x] == " ") { #if nothing after
      end <- TRUE
    } else { #if anything else (path, letter, crossing)
      y <- y + 1
    }
  }
}

path <- paste(letters, collapse = "")


path

len