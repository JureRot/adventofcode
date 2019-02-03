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
get_value <- function(registers, x) { #gets value of x, number or register
  value <- 0
  
  if (suppressWarnings(!is.na(as.numeric(x)))) { #input is number
    value <- as.numeric(x) #we just use the number
    
  } else { #is register name
    if (!is.null(registers[[x]])) { #if already exists
      value <- registers[[x]] #we get the reg value
      
    } else { #if it doesnt exist
      value <- 0 #zero is default value
    }
  }
  
  return(value)
}

snd <- function(state, x) { #plays sound
  value <- get_value(state$registers, x)
  
  state$played <- value
  state$i <- state$i + 1
  
  return(state)
}

snd2 <- function(state, x) { #adds another value in sent
  value <- get_value(state$registers, x)
  
  state$sent <- c(state$sent, value) #add another sound to send
  state$num_sent <- state$num_sent + 1 #counter for num sent
  state$i <- state$i + 1
  
  return(state)
}

set <- function(state, x, y) { #sets reg x with value y
  value <- get_value(state$registers, y)
  
  state$registers[[x]] <- value #creates or overwrites
  state$i <- state$i + 1
  
  return(state)
}

add <- function(state, x, y) { #increases the value of reg x by value of y
  value <- get_value(state$registers, y)
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] + value
  state$i <- state$i + 1
  
  return(state)
}

mul <- function(state, x, y) { #multiplies the value of reg x by value of y
  value <- get_value(state$registers, y)
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] * value
  state$i <- state$i + 1
  
  return(state)
}

mod <- function(state, x, y) { #sets reg x to value of x modulo value of y
  value <- get_value(state$registers, y)
  
  if (is.null(state$registers[[x]])) { #if reg to increase doesn't exist
    state$registers[[x]] <- 0 
    
  }
  
  state$registers[[x]] <- state$registers[[x]] %% value
  state$i <- state$i + 1
  
  return(state)
}

rcv <- function(state, x) { #if value of x not zero, receives the last played sound
  value <- get_value(state$registers, x)
  
  if (value != 0) {
    state$received <- state$played
  }
  
  state$i <- state$i + 1
  
  return(state)
}

rcv2 <- function(state, other, x) { #stores sent value of other in reg x
  value <- other$sent[1] #store the first sent
  other$sent <- other$sent[-1] #remove that element from vector
  state$registers[[x]] <- value #set the reg x in current program to sent value

  state$i <- state$i + 1
  
  return(list(state, other))
}

jgz <- function(state, x, y) { #if value of x greater than zero, we jump with offset y (plus or minus)
  value <- get_value(state$registers, x)
  offset <- 1 #default offset is one (just go to next command)
  
  if (value > 0) { #if value of x greater than zero we change value of offset
    offset<- get_value(state$registers, y)
  }
  
  state$i <- state$i + offset
  
  return(state)
}

#list of state: registers (list), i (int), played (null|freq), received (null|freq)

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


#take two

programs <- list(list(registers=list(), i=1, sent=numeric(), num_sent=0, state=0), list(registers=list(), i=1, sent=c(), num_sent=0, state=0)) #state: 0=running, 1=waiting(receiving), -1=terminated)

programs[[1]]$registers[["p"]] <- 0 #custom p registers
programs[[2]]$registers[["p"]] <- 1

prog <- 1 #current program (change index (1, 2) using 3-prog)

#input <- c("snd 1", "snd 2", "snd p", "rcv a", "rcv b", "rcv c", "rcv d") #test input
#input <- strsplit(input, " ")


while (programs[[1]]$state>=0 & programs[[2]]$state>=0) {
#for (bla in 1:16) {
  if (input[[programs[[prog]]$i]][1] == "snd") {
    programs[[prog]] <- snd2(programs[[prog]], input[[programs[[prog]]$i]][2])
  } else if (input[[programs[[prog]]$i]][1] == "set") {
    programs[[prog]] <- set(programs[[prog]], input[[programs[[prog]]$i]][2], input[[programs[[prog]]$i]][3])
  } else if (input[[programs[[prog]]$i]][1] == "add") {
    programs[[prog]] <- add(programs[[prog]], input[[programs[[prog]]$i]][2], input[[programs[[prog]]$i]][3])
  } else if (input[[programs[[prog]]$i]][1] == "mul") {
    programs[[prog]] <- mul(programs[[prog]], input[[programs[[prog]]$i]][2], input[[programs[[prog]]$i]][3])
  } else if (input[[programs[[prog]]$i]][1] == "mod") {
    programs[[prog]] <- mod(programs[[prog]], input[[programs[[prog]]$i]][2], input[[programs[[prog]]$i]][3])
  } else if (input[[programs[[prog]]$i]][1] == "rcv") {
    if (length(programs[[3-prog]]$sent) > 0) { #if other has send, get data
      new_states <- rcv2(programs[[prog]], programs[[3-prog]], input[[programs[[prog]]$i]][2])
      programs[[prog]] <- new_states[[1]]
      programs[[3-prog]] <- new_states[[2]]
      
    } else if (programs[[3-prog]]$state < 0) { #if other terminated, terminate this
      programs[[prog]]$state <- -1
      next
      
    } else if ((programs[[3-prog]]$state==1) & (length(programs[[prog]]$sent)==0)) { #if other receiving and this hasnt sent anything, terminate both (deathlock)
      programs[[prog]]$state <- -1
      programs[[3-prog]]$state <- -1
      next
      
    } else { #put this in receving/waiting and swap programs
      programs[[prog]]$state <- 1
      prog <- 3 - prog
      
    }
  } else if (input[[programs[[prog]]$i]][1] == "jgz") {
    programs[[prog]] <- jgz(programs[[prog]], input[[programs[[prog]]$i]][2], input[[programs[[prog]]$i]][3])
  }
  
  #dont stress, takes a few secons
}

sent1 <- programs[[2]]$num_sent


received_sound

sent1