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

closest_a <- 2 ^ .Machine$double.digits #set as double.max (sort of)
closest_name <- NULL

for (part in 1:length(particles)) {
  if (sum(abs(particles[[part]]$a)) < closest_a) { #if manhattan dist smaller than current closest
    closest_a <- sum(abs(particles[[part]]$a))
    closest_name <- part - 1 #-1 because we start counting from 1 (not from 0)
  }
}

# selects the wrong one (same sum(abs(a)))
# 119: p=<-3329,585,1447>, v=<98,-17,-8>, a=<0,0,-2>
# 170: p=<430,891,209>, v=<3,-10,-8>, a=<-1,-1,0>

closest_name
