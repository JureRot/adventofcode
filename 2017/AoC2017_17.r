input <- 363

#input <- 3 #testing input

buffer <- 0
pos <- 1


for (i in 1:2017) { #change to 1:2017
  pos <- ((pos-1) + input) %% length(buffer)+1 #calculate new position (-1 and +1 cause we count from 1)
  
  if (pos < length(buffer)) {
    buffer <- c(buffer[1:pos], i, buffer[(pos+1):length(buffer)]) #add new element in correct position
  } else {
    buffer <- c(buffer[1:pos], i)
  }
  
  pos <- pos + 1 #set pos of the inserted element
}

after <- buffer[pos+1]

#part two (this wont work)

after_zero <- 0

buffer_len <- 1
pos <- 1

for (i in 1:50000000) {
  pos <- ((pos-1) + input) %% buffer_len+1
  
  #we dont fill the buffer, just remember elemnt after zero
  #zero is always position 1, so if pos==1, it will be insterted after 0

  if (pos == 1) {
    after_zero <- i
  }
  
  buffer_len <- buffer_len + 1
  pos <- pos + 1
  
  #TAKES A WHILE (like 15 seconds)
}



after

after_zero