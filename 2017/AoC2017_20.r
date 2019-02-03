input_file = file("input2017_20.txt", "r")
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

#input <- c("p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>", "p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>") #test input

input <- gsub("[a-z]=<", "", input) #removes letter=<
input <- gsub(">| ", "", input) #removes > and spaces

particles <- list()

for (l in 1:length(input)) { #init all particles
  line <- input[l]
  line <- as.numeric(unlist(strsplit(line, ",")))
  particles[[l]] <- list(p=c(line[1], line[2], line[3]), v=c(line[4], line[5], line[6]), a=c(line[7], line[8], line[9])) #create particle
}

closest_dist <- 2 ^ .Machine$double.digits #set as double.max (sort of)
closest_name <- NULL

counter <- 0
last_change <- 0

while ((counter - last_change) <= 1000) { #while not 1000 iterations withou change of closest
  for (part in 1:length(particles)) {
    particles[[part]]$v <- particles[[part]]$v + particles[[part]]$a #update velocity using acceleration
    particles[[part]]$p <- particles[[part]]$p + particles[[part]]$v #update position using velocity
    
    if (sum(abs(particles[[part]]$p)) < closest_dist) { #if manhattan dist smaller than current closest
      closest_dist <- sum(abs(particles[[part]]$p))
      closest_name <- part - 1 #-1 because we start counting from 1 (not from 0)
      
      last_change <- counter
    }
  }
  
  counter <- counter + 1
  
  #this is flawed, waiting for x iterations withou change is dumb
  #how about biggest manhattan dist of acc
}

closest_name