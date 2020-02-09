input_file = file("input2017_24.txt", "r")
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

#input <- c("0/2", "2/2", "2/3", "3/4", "3/5", "0/1", "10/1", "9/10") #testing input

input <- strsplit(input , "/")


can_connect <- function(comp, plug) { #can component connect  to plug
	if (plug %in% comp) {
		return(TRUE)
	}
	return(FALSE)
}

get_strength <- function(comp) { #returnns strength of a link
	return(sum(comp))
}

strongest_bridge <- function(comps, end) {
	strongest <- 0

	next_links <- c()

	for (c in names(comps)) {
		if (can_connect(comps[[c]], end)) {
			next_links <- c(next_links, c)
		} 
	}

	for(l in next_links) {
		new_comps <- comps #create copy of comps
		new_comps[[l]] <- NULL #remove current component from it

		new_end_index <- 3 - (match(end, comps[[l]])) #3 - index_of_match will be the other index
		new_end <- comps[[l]][new_end_index] #value of ther connector in compoent becomes new end

		strongest <- max(strongest, (get_strength(comps[[l]]) + strongest_bridge(new_comps, new_end)))
		#the greater of current largest and strenght of that branch
	}

	return(strongest)
}


#part two
longest_bridge <- function(comps, end, path) {
	longest <- 0
	strongest <- 0

	next_links <- c()

	for (c in names(comps)) {
		if (can_connect(comps[[c]], end)) {
			next_links <- c(next_links, c)
		} 
	}

	for(l in next_links) {
		new_comps <- comps #create copy of comps
		new_comps[[l]] <- NULL #remove current component from it

		new_end_index <- 3 - (match(end, comps[[l]])) #3 - index_of_match will be the other index
		new_end <- comps[[l]][new_end_index] #value of ther connector in compoent becomes new end

		branch <- longest_bridge(new_comps, new_end, (path+1)) #format: [len of branch, strength of branch]
		new_longest <- path + branch[1]
		new_strongest <- get_strength(comps[[l]]) + branch[2]

		if (new_longest > longest) { #if new longest the longest yet, we set it
			longest <- new_longest
			strongest <- new_strongest
		} else if (new_longest == longest) { #if the same len as prev longest, we chekc which is strongest
			if (new_strongest > strongest) {
				longest <- new_longest
				strongest <- new_strongest
			}
		}
	}

	return(c(longest, strongest))
}

comps <- list()

for (l in 1:length(input)) { #create a list of all components
	line <- as.numeric(input[[l]])
	comps[[as.character(l)]] <- c(line[1], line[2])
}

#DONT WORRY, TAKES A WHILE (like half a minute)
strongest <- strongest_bridge(comps, 0)

#part two
#TAKES ANOTHER WHILE (half a minute)
longest <- longest_bridge(comps, 0, 0) #[length, strength]

strongest

longest[2]
