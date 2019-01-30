input_file = file("input2017_09.txt", "r")
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

#input <- "<random characters>" #testing input

input <- unlist(strsplit(input, ""))

i <- 1

group <- 0
trash <- FALSE

score <- 0

#part two
trash_count <- 0

while (i <= length(input)) {
  if (input[i] == "!") { #skip next character
    i <- i + 1
  } else if (input[i] == "{") {
    if (!trash) { #if not in trash increase the group nest and add the value to score
      group <- group + 1
      score <- score + group
      
    } else { #part two
      trash_count <- trash_count + 1
    }
    
  } else if (input[i] == "}") {
    if (!trash) { #if fnot in trash decrease the gropu nest
      group <- group - 1
      
    } else { #part two
      trash_count <- trash_count + 1
    }
    
  } else if (input[i] == "<") {
    if (!trash) {
      trash <- TRUE #step into trash
      
    } else { #part two
      trash_count <- trash_count + 1
    }
    
  } else if (input[i] == ">") {
    trash <- FALSE #step out of trash
    
  } else { #part two
    if (trash) {
      trash_count <- trash_count + 1
    }
  }
  
  i <- i + 1
}

score

trash_count