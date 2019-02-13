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
      cursor <- cursor - 1
      state <- 2
    }
  } else if (state == 2) { #state B
    if (tape[[cellname]] == 0) { #value of cell is 0
      tape[[cellname]] <- 1
      cursor <- cursor - 1
      state <- 1
    } else { #value of cell is 1
      #tape[[cellname]] <- 1 #already is
      cursor <- cursor + 1
      state <- 1
    }
  }
  return(list(tape, cursor, state))
}

#tape <- list()
tape <- new.env() #weird with sum
cursor <- 0
state <- 1 #state 1: A, state 2: B

for (step in 1:6) {
  cellname <- as.character(cursor)
  if (is.null(tape[[cellname]])) { #if cell on tape doesnt exists, we init it with zero
    tape[[cellname]] <- 0
  }
  
  machine <- execute_command(tape, cursor, state)
  tape <- machine[[1]]
  cursor <- machine[[2]]
  state <- machine[[3]]
}

#checksum <- sum(as.numeric(tape))
checksum <- 0
for (c in ls(tape)) {
  checksum <- checksum + sum(tape[[c]])
}

checksum