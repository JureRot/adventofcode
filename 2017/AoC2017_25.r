#we hardcode the input
execute_command <- function(tape, cursor, state) {
  if (state == 1) { #state A
    cellname <- as.character(cursor)
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 2
    } else { #value of cell is 1
      tape[[cellname]] <- 0
      cursor <- cursor + 1
      state <- 3
    }
  } else if (state == 2) { #state B
    if (tape[[cellname]] == 0) { #value of cell is 0
      #tape[[cellname]] <- 0
      cursor <- cursor - 1
      state <- 1
    } else { #value of cell is 1
      tape[[cellname]] <- 0
      cursor <- cursor + 1
      state <- 4
    }
  } else if (state == 3) { #state C
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 4
    } else { #value of cell is 1
      #tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 1
    }
  } else if (state == 4) { #state D
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor - 1
      state <- 5
    } else { #value of cell is 1
      tape[[cellname]] <- 0
      cursor <- cursor - 1
      #state <- 4
    }
  } else if (state == 5) { #state D
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 6
    } else { #value of cell is 1
      #tape[[cellname]] <- 1
      cursor <- cursor - 1
      state <- 2
    }
  } else if (state == 6) { #state F
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 1
    } else { #value of cell is 1
      #tape[[cellname]] <- 1
      cursor <- cursor + 1
      state <- 5
    }
  }
  return(list(tape, cursor, state))
}

#tape <- list()
tape <- new.env() #weird with sum
cursor <- 0
state <- 1 #state 1: A, state 2: B

for (step in 1:12368930) {
  cellname <- as.character(cursor)
  if (is.null(tape[[cellname]])) { #if cell on tape doesnt exists, we init it with zero
    tape[[cellname]] <- 0
  }
  
  machine <- execute_command(tape, cursor, state)
  tape <- machine[[1]]
  cursor <- machine[[2]]
  state <- machine[[3]]
  
  #DONT WORRY, TAKES A WHILE (like a minute)
}

#checksum <- sum(as.numeric(tape))
checksum <- 0
for (c in ls(tape)) {
  checksum <- checksum + sum(tape[[c]])
}

checksum


#birlliant, this was fun