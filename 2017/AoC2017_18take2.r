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


#functions
snd <- function(state, x) { #plays sound
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[x]])) { #if already exists
      value <- state$registers[[x]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[x]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #and send this frequency
    }
  }
  
  state$played <- value
  state$i <- state$i + 1
  
  return(state)
}

set <- function(state, x, y) { #sets reg x with value y
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(y)))) { #input is number
    value <- as.numeric(y) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[y]])) { #if already exists
      value <- state$registers[[y]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[y]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  state$registers[[x]] <- value
  state$i <- state$i + 1
  
  return(state)
}

add <- function(state, x, y) { #increases the value of reg x by value of y
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(y)))) { #input is number
    value <- as.numeric(y) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[y]])) { #if already exists
      value <- state$registers[[y]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[y]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] + value
  state$i <- state$i + 1
  
  return(state)
}

mul <- function(state, x, y) { #multiplies the value of reg x by value of y
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(y)))) { #input is number
    value <- as.numeric(y) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[y]])) { #if already exists
      value <- state$registers[[y]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[y]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] * value
  state$i <- state$i + 1
  
  return(state)
}

mod <- function(state, x, y) { #sets reg x to value of x modulo value of y
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(y)))) { #input is number
    value <- as.numeric(y) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[y]])) { #if already exists
      value <- state$registers[[y]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[y]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] %% value
  state$i <- state$i + 1
  
  return(state)
}

rcv <- function(state, x) { #if value of x not zero, receives the last played sound
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[x]])) { #if already exists
      value <- state$registers[[x]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[x]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  if (value != 0) {
    state$received <- state$played
  }
  
  state$i <- state$i + 1
  
  return(state)
}

jgz <- function(state, x, y) { #if value of x greater than zero, we jump with offset y (plus or minus)
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[x]])) { #if already exists
      value <- state$registers[[x]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[x]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #default value
    }
  }
  
  if (value > 0) { #if value of x greater than zero we jump by offset (value of y)
    offset<- 0
    
    if (suppressWarnings(!is.na(as.numeric(y)))) { #input is number
      offset <- as.numeric(y) #we just use the number
      
    } else { #is register name
      if (!is.null(state$registers[[y]])) { #if already exists
        offset <- state$registers[[y]] #we get the reg value
        
      } else { #if it doesnt exist
        state$registers[[y]] <- 0 #we create the reg wiht zero (for the future)
        offset <- 0 #default value
      }
    }
    
    state$i <- state$i + offset
    
  } else { #if value of x not greater than zero, we just skip this command
    state$i <- state$i + 1
  }
  
  return(state)
}

#HAVE STATE LIST WITH: REGISTERS (list), I (int), PLAYED (null|freq), RECEIVED (null|freq)

state <- list(registers=list(), i=1, played=NULL, received=NULL)

while((state$i >= 1) & (state$i <= length(input)) & (is.null(state$received))) {
#for (bla in 1:16) {
  if (input[[state$i]][1] == "snd") {
    state <- snd(state, input[[state$i]][2])
  } else if (input[[state$i]][1] == "set") {
    state <- set(state, input[[state$i]][2], input[[state$i]][3])
  } else if (input[[state$i]][1] == "add") {
    state <- add(state, input[[state$i]][2], input[[state$i]][3])
  } else if (input[[state$i]][1] == "mul") {
    state <- mul(state, input[[state$i]][2], input[[state$i]][3])
  } else if (input[[state$i]][1] == "mod") {
    state <- mod(state, input[[state$i]][2], input[[state$i]][3])
  } else if (input[[state$i]][1] == "rcv") {
    state <- rcv(state, input[[state$i]][2])
  } else if (input[[state$i]][1] == "jgz") {
    state <- jgz(state, input[[state$i]][2], input[[state$i]][3])
  }
}

received_sound <- state$received

#part two

#changed functions
snd2 <- function(state, x) { #adds another value in sent
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    if (!is.null(state$registers[[x]])) { #if already exists
      value <- state$registers[[x]] #we get the reg value
      
    } else { #if it doesnt exist
      state$registers[[x]] <- 0 #we create the reg wiht zero (for the future)
      value <- 0 #and send this frequency
    }
  }
  
  state$sent <- c(state$sent, value) #add another sound to send
  state$num_sent <- state$num_sent + 1 #counter for num sent
  state$i <- state$i + 1
  
  return(state)
}

rcv2 <- function(state, other, x) { #stores sent value of other in reg x
  if (length(other$sent) == 0) { #if other has no sent, we terminate program
    state$terminated <- TRUE
    
  } else {
    value <- other$sent[1] #store the first sent
    other$sent <- other$sent[-1] #remove that element from vector
    state$registers[[x]] <- value #set the reg x in current program to sent value
  }
  
  state$i <- state$i + 1
  
  return(list(state, other))
}

registers <- list()
registers[["p"]] <- 0
state0 <- list(registers=registers, i=1, sent=c(), num_sent=0, terminated=FALSE)
registers[["p"]] <- 1
state1 <- list(registers=registers, i=1, sent=c(), num_sent=0, terminated=FALSE)

# input <- c("snd 1", "snd 2", "snd p", "rcv a", "rcv b", "rcv c", "rcv d") #test input
# input <- strsplit(input, " ")

#run first until rcv
#run second until rcv
#execute rcv
#repeat

while((!state0$terminated) | (!state1$terminated)) {
  #run firs program until it wants to receive or oob
  while((state0$i >= 1) & (state0$i <= length(input)) & (input[[state0$i]][1] != "rcv")) {
    if (input[[state0$i]][1] == "snd") {
      state0 <- snd2(state0, input[[state0$i]][2])
    } else if (input[[state0$i]][1] == "set") {
      state0 <- set(state0, input[[state0$i]][2], input[[state0$i]][3])
    } else if (input[[state0$i]][1] == "add") {
      state0 <- add(state0, input[[state0$i]][2], input[[state0$i]][3])
    } else if (input[[state0$i]][1] == "mul") {
      state0 <- mul(state0, input[[state0$i]][2], input[[state0$i]][3])
    } else if (input[[state0$i]][1] == "mod") {
      state0 <- mod(state0, input[[state0$i]][2], input[[state0$i]][3])
    } else if (input[[state0$i]][1] == "jgz") {
      state0 <- jgz(state0, input[[state0$i]][2], input[[state0$i]][3])
    }
  }
  
  if ((state0$i < 1) | (state0$i > length(input))) {
    state0$terminated <- TRUE
    #next #start outter while loop again (chekc if both states terminated)
  }
  
  #run second program until it want to receive or oob
  while((state1$i >= 1) & (state1$i <= length(input)) & (input[[state1$i]][1] != "rcv")) {
    if (input[[state1$i]][1] == "snd") {
      state1 <- snd2(state1, input[[state1$i]][2])
    } else if (input[[state1$i]][1] == "set") {
      state1 <- set(state1, input[[state1$i]][2], input[[state1$i]][3])
    } else if (input[[state1$i]][1] == "add") {
      state1 <- add(state1, input[[state1$i]][2], input[[state1$i]][3])
    } else if (input[[state1$i]][1] == "mul") {
      state1 <- mul(state1, input[[state1$i]][2], input[[state1$i]][3])
    } else if (input[[state1$i]][1] == "mod") {
      state1 <- mod(state1, input[[state1$i]][2], input[[state1$i]][3])
    } else if (input[[state1$i]][1] == "jgz") {
      state1 <- jgz(state1, input[[state1$i]][2], input[[state1$i]][3])
    }
  }
  
  if ((state1$i < 1) | (state1$i > length(input))) {
    state1$terminated <- TRUE
    #next #start outter while loop again (chekc if both states terminated)
  }
  
  if (!state0$terminated) { #if first program not terminated, we run the next (receive) command
    new_states <- rcv2(state0, state1, input[[state0$i]][2])
    state0 <- new_states[[1]]
    state1 <- new_states[[2]]
  }
  
  if (!state1$terminated) { #if second program not terminated, we run the next (receive) command
    new_states <- rcv2(state1, state0, input[[state1$i]][2])
    state1 <- new_states[[1]]
    state0 <- new_states[[2]]
  }
  
  #we run only one rcv command (if there are muliple, the nested whiles will not run, so still good)
  
}

received_sound

state1$num_sent

#doesnt work correctly. try to go just stepping from one program to another, not running both of them unil they cant run any more