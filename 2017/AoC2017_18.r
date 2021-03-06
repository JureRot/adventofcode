input_file = file("input2017_18.txt", "r")
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

#input <- c("set a 1", "add a 2", "mul a a", "mod a 5", "snd a", "set a 0", "rcv a", "jgz a -1", "set a 1", "jgz a -2")

input <- strsplit(input, " ")


registers <- list()
i <- 1
sound_played <- NULL
sound_received <- NULL #maybe a list (for part one we just need the first one)
received <- FALSE

exists <- FALSE


while ((i >= 1) & (i <= length(input)) & (!received)) {
  command <- input[[i]]
  
  print(command)
  
  #suppressWarnings(!is.na(as.numeric(x))) -> is number check
  #!is.null(x[[i]]) -> exists check
  
  if (command[1] == "snd") { #play sound
    if (suppressWarnings(!is.na(as.numeric(command[2])))) { #input is number
      sound_played <- as.numeric(command[2]) #we just use the number
      
    } else { #is register name
      if (!is.null(registers[[command[2]]])) { #if already exists
        sound_played <- registers[[command[2]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[2]]] <- 0 #we create the reg wiht zero (for the future)
        sound_played <- 0 #and send this frequency
      }
    }
    
    i <- i + 1
    
  } else if (command[1] == "set") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[3])))) { #second att is number (first is always letter)
      value <- as.numeric(command[3])
      
    } else { #is register name
      if (!is.null(registers[[command[3]]])) { #if already exists
        value <- registers[[command[3]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[3]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    registers[[command[2]]] <- value #set the reg, if exists or not (we either create or overwrite)
    
    i <- i + 1
    
  } else if (command[1] == "add") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[3])))) { #second att is number (first is always letter)
      value <- as.numeric(command[3])
      
    } else { #is register name
      if (!is.null(registers[[command[3]]])) { #if already exists
        value <- registers[[command[3]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[3]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    if (!is.null(registers[[command[2]]])) { #if first att already exists
      registers[[command[2]]] <- registers[[command[2]]] + value
      
    } else { #if it doesnt exist
      registers[[command[2]]] <- value #we create it with value
    }
    
    i <- i + 1
    
  } else if (command[1] == "mul") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[3])))) { #second att is number (first is always letter)
      value <- as.numeric(command[3])
      
    } else { #is register name
      if (!is.null(registers[[command[3]]])) { #if already exists
        value <- registers[[command[3]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[3]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    if (!is.null(registers[[command[2]]])) { #if first att already exists
      registers[[command[2]]] <- registers[[command[2]]] * value
      
    } else { #if it doesnt exist
      registers[[command[2]]] <- 0 #we create it (but its 0 because 0*n=0)
    }
    
    i <- i + 1
    
  } else if (command[1] == "mod") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[3])))) { #second att is number (first is always letter)
      value <- as.numeric(command[3])
      
    } else { #is register name
      if (!is.null(registers[[command[3]]])) { #if already exists
        value <- registers[[command[3]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[3]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    if (!is.null(registers[[command[2]]])) { #if first att already exists
      registers[[command[2]]] <- registers[[command[2]]] %% value
      
    } else { #if it doesnt exist
      registers[[command[2]]] <- 0 #we create it (but still 0, 0%%n=0)
    }
    
    i <- i + 1
    
  } else if (command[1] == "rcv") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[2])))) { #is input a number
      value <- as.numeric(command[2])
      
    } else { #is register name
      if (!is.null(registers[[command[2]]])) { #if already exists
        value <- registers[[command[2]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[2]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    if (value != 0) { #if not zero, we record the last played sound
      sound_received <- sound_played
      received <- TRUE
    }
    
    i <- i + 1
    
  } else if (command[1] == "jgz") {
    value <- 0
    
    if (suppressWarnings(!is.na(as.numeric(command[2])))) { #is first att a number
      value <- as.numeric(command[2])
      
    } else { #is register name
      if (!is.null(registers[[command[2]]])) { #if already exists
        value <- registers[[command[2]]] #we get the reg value
        
      } else { #if it doesnt exist
        registers[[command[2]]] <- 0 #we create the reg wiht zero (for the future)
        value <- 0 #value of default = 0
      }
    }
    
    if (value > 0) { #if first att bigger than zero
      offset <- 0
      
      if (suppressWarnings(!is.na(as.numeric(command[3])))) { #is second att a number
        offset <- as.numeric(command[3])
        
      } else { #is register name
        if (!is.null(registers[[command[3]]])) { #if already exists
          offset <- registers[[command[3]]] #we get the reg value
          
        } else { #if it doesnt exist
          registers[[command[3]]] <- 0 #we create the reg wiht zero (for the future)
          offset <- 0 #value of default = 0
        }
      }
      
      i <- i + offset
      
    } else {
      i <- i + 1
    }
    
  }
}

sound_received

#need to use numberic (double) not integer

#second part is weird
#rewrite this for it so it wold work better (waiting and all)