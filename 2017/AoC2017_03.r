input <- 347991

# one right, one up
# two left, two down
# thre right, thee up
# four left, four down
# ...

x <- 0 #horizontal
y <- 0 #vertical

i <- 1
n <- 1

smaller <- TRUE

distance <- 0

while (smaller) {
  if (i == input) { #if input 1
    smaller <- FALSE
    break
  }
  
  #right
  for (j in 1:n) {
    x <- x + 1
    i <- i + 1
    if (i == input) {
      smaller <- FALSE
      break #break for loop if come to the end
    }
  }
  if (!smaller) break #break while loop if coem to the end
  
  #up
  for (j in 1:n) {
    y <- y + 1
    i <- i + 1
    if (i == input) {
      smaller <- FALSE
      break
    }
  }
  if (!smaller) break
  
  n <- n + 1 #increase the step
  
  #left
  for (j in 1:n) {
    x <- x - 1
    i <- i + 1
    if (i == input) {
      smaller <- FALSE
      break
    }
  }
  if (!smaller) break
  
  #down
  for (j in 1:n) {
    y <- y - 1
    i <- i + 1
    if (i == input) {
      smaller <- FALSE
      break
    }
  }
  
  n <- n + 1 #increase the step (for new iteration)
}

dist <- abs(x) + abs(y)
dist
