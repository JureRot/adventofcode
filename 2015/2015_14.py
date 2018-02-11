import collections


#starting vars
deer = collections.defaultdict(dict)
best_deer = ""
longest = 0

total_time = 2503

#second part
best_deer2 = ""
most_points = 0


with open('input2015_14.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input: #constructs a dict -> name: {speed:, f_time:, r_time:, flying:, t_till_change:, distance:, pints:}
	i_list = i.split(' ')
	deer[i_list[0]]["speed"] = int(i_list[3])
	deer[i_list[0]]["f_time"] = int(i_list[6])
	deer[i_list[0]]["r_time"] = int(i_list[13])
	deer[i_list[0]]["flying"] = True
	deer[i_list[0]]["t_till_change"] = int(i_list[6])
	deer[i_list[0]]["distance"] = 0
	#second part
	deer[i_list[0]]["points"] = 0


def give_points(d):
	most_p = max({k: v["distance"] for k, v in deer.items()}.values()) #find max of values in dict name:distance

	for k, v in d.items(): #adds one point to everyone with the max_p equal to points (can be more than one)
		if (v["distance"] == most_p):
			d[k]["points"] += 1



for i in range(1, total_time+1): #for every second of the race (from 1, not 0)
	for k in deer.keys(): #for every deer
		if (deer[k]["flying"]): #if flying
			deer[k]["distance"] += deer[k]["speed"] #adds to distance

		deer[k]["t_till_change"] -= 1 #reduces one time

		if (deer[k]["t_till_change"] == 0): #if time at 0
			if (deer[k]["flying"]): #either make it fly
				deer[k]["flying"] = False
				deer[k]["t_till_change"] = deer[k]["r_time"]
			else: #or make it rest
				deer[k]["flying"] = True
				deer[k]["t_till_change"] = deer[k]["f_time"]

	give_points(deer) #gives points to the deers with the most points


for k in deer.keys(): #finds deer traveled the longes
	if (deer[k]["distance"] > longest):
		longest = deer[k]["distance"]
		best_deer = k

print("1. total distance of the best deer: ", longest)


for k in deer.keys(): #finds the deer with the most ponts
	if (deer[k]["points"] > most_points):
		most_points = deer[k]["points"]
		best_deer2 = k

print("2. total points of the best deer according to points: ", most_points)