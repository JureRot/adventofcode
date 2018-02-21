import sys
import copy


#starting vars
smallest_amount = sys.maxsize
sequence = []


boss_stats = []



with open('input2015_22.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.split()
	boss_stats.append(i_list[-1]) #se make helping var for creating the boss (a lot of hassle just for consistency)


class Entity: #basic class (used for boss)
	def __init__(self, hp, dmg, arm): #inputus of hp, attack and armour
		self.hp = int(hp)
		self.dmg = int(dmg)
		self.arm = int(arm)

	def attack(self, opp): #attack method (input of another object of entity)
		opp.hp -= max(1, self.dmg - opp.arm)


class Player(Entity): #child of Entity
	def __init__(self, hp, dmg, arm, mana):
		super().__init__(hp, dmg, arm) #interites all the Entity's methods and parameters
		self.mana = int(mana) #and adds some more
		self.spent = 0
		self.abilities = [] #this is just for record keeping (not needed in the exercise)
		self.st = 0
		self.pt = 0
		self.rt = 0

	def magicMissile(self, opp): #magic missile and drain operate on input of another Entity, others are turn based
		#if (self.mana >= 53): #not needed, because we check before
		self.mana -= 53
		self.spent += 53
		opp.hp -= 4
		self.abilities.append('m') #this is just for record keeping (not needed in the execrise)

	def drain(self, opp):
		self.mana -= 73
		self.spent += 73
		opp.hp -= 2
		self.hp += 2
		self.abilities.append('d')

	def shield(self): 
		self.mana -= 113
		self.spent += 113
		self.st = 6 #shield, poison and recharge, have timers, so se set those
		self.abilities.append('s')

	def poison(self):
		self.mana -= 173
		self.spent += 173
		self.pt = 6
		self.abilities.append('p')

	def recharge(self):
		self.mana -= 229
		self.spent += 229
		self.rt = 5
		self.abilities.append('r')


	def tick(self, opp): #tick is called at the start of every turn (player or boss), and needs opponent input for poison tick
		if (self.st):
			self.arm = 7
			self.st -= 1
		else:
			self.arm = 0

		if (self.pt):
			opp.hp -= 3
			self.pt -=1

		if (self.rt):
			self.mana += 101
			self.rt -= 1


def game(player, boss, hard): #recursive main function
	global smallest_amount # need to change the global var values deep in recursion
	global sequence

	p = player
	b = boss

	#print(p.abilities)

	if (hard): #hard is for second part (-1 hp at the start of players turn)
		p.hp -= 1

		if (p.hp <= 0):
			return (False)

	p.tick(b) #tick at the start of players turn

	if (b.hp <= 0): #check if boss still alive
		#print("win", p.abilities)
		if (p.spent < smallest_amount): #if not, we chack if amount of mana used less than previous least
			smallest_amount = p.spent #and change appropriately if so
			sequence = p.abilities
		return (True) #return just to stop the recursion


	#MAGIC MISSILE #than we branch the recursion for every possible ability
	if (p.mana >= 53):
		pm = copy.deepcopy(p) #we make copies for recursion branch
		bm = copy.deepcopy(b)

		pm.magicMissile(bm) #we cast the spell

		if (bm.hp <= 0): #magcin missile and drain do damage on cast so we check the health of boss
			#print("win", pm.abilities)
			if (pm.spent < smallest_amount):
				smallest_amount = pm.spent
				sequence = pm.abilities
			return (True)

		pm.tick(bm) #tick at the start of the boss' turn

		if (bm.hp <= 0): #check if tick killed the boss
			#print("win", pm.abilities)
			if (pm.spent < smallest_amount):
				smallest_amount = pm.spent
				sequence = pm.abilities
			return (True)

		bm.attack(pm) #boss attacks the player

		if (pm.hp <= 0): #check if player died
			#print("lose", pm.abilities)
			return (False)

		if (pm.spent < smallest_amount): #VERY IMPORTANT, THIS COSTED ME 2 DAYS
			game(pm, bm, hard) #if curent mana spent smaller than the curent least, we keep going, else we stop (cut unneccessary branches)


	#DRAIN
	if (p.mana >= 73): #similar for all spells
		pd = copy.deepcopy(p)
		bd = copy.deepcopy(b)

		pd.drain(bd)

		if (bd.hp <= 0):
			#print("win", pd.abilities)
			if (pd.spent < smallest_amount):
				smallest_amount = pd.spent
				sequence = pm.abilities
			return (True)

		pd.tick(bd)

		if (bd.hp <= 0):
			#print("win", pd.abilities)
			if (pd.spent < smallest_amount):
				smallest_amount = pd.spent
				sequence = pm.abilities
			return (True)

		bd.attack(pd)

		if (pd.hp <= 0):
			#print("lose", pd.abilities)
			return (False)

		if (pd.spent < smallest_amount):
			game(pd, bd, hard)


	#SHIELD
	if (p.mana >= 113 and not p.st):
		ps = copy.deepcopy(p)
		bs = copy.deepcopy(b)

		ps.shield() #shield, poison and recharge don't do damage on cast, so we don't need to chekc if boss deat after cast

		ps.tick(bs) #still need to check after tick (poison can be active from before)

		if (bs.hp <= 0):
			#print("win", ps.abilities)
			if (ps.spent < smallest_amount):
				smallest_amount = ps.spent
				sequence = pm.abilities
			return (True)

		bs.attack(ps)

		if (ps.hp <= 0):
			#print("lose", ps.abilities)
			if (ps.spent < smallest_amount):
				smallest_amount = ps.spent
				sequence = pm.abilities
			return (False)

		if (ps.spent < smallest_amount):
			game(ps, bs, hard)


	#POISON
	if (p.mana >= 173 and not p.pt):
		pp = copy.deepcopy(p)
		bp = copy.deepcopy(b)

		pp.poison()

		pp.tick(bp)

		if (bp.hp <= 0):
			#print("win", pp.abilities)
			if (pp.spent < smallest_amount):
				smallest_amount = pp.spent
				sequence = pm.abilities
			return (True)

		bp.attack(pp)

		if (pp.hp <= 0):
			#print("lose", pp.abilities)
			return (False)

		if (pp.spent < smallest_amount):
			game(pp, bp, hard)


	#RECHARGE
	if (p.mana >= 229 and not p.rt):
		pr = copy.deepcopy(p)
		br = copy.deepcopy(b)

		pr.recharge()

		pr.tick(br)

		if (br.hp <= 0):
			#print("win", pr.abilities)
			if (pr.spent < smallest_amount):
				smallest_amount = pr.spent
				sequence = pm.abilities
			return (True)

		br.attack(pr)

		if (pr.hp <= 0):
			#print("lose", pr.abilities)
			return (False)

		if (pr. spent < smallest_amount):
			game(pr, br, hard)




	
boss = Entity(boss_stats[0], boss_stats[1], 0) #we make the boss Entity from var created from input
player = Player(50, 0, 0, 500) #we make the player Player from exercise input

game(player, boss, False) #we play normal

print("1. smallest amount of mana used to defeat the boss:", smallest_amount)

#second part
smallest_amount = sys.maxsize #we reuse the var for coinvenience

boss = Entity(boss_stats[0], boss_stats[1], 0)
player = Player(50, 0, 0, 500)

game(player, boss, True) #true is for hard (we lose 1hp at the start of our turn)

print("2. smallest amount of mana used to defeat the boss on hard:", smallest_amount)


"""
turn order:
p:
tick
check
ability
attack
chekc

b:
tick
check
attack
check
"""

"""
This wasn't the easiest
The choice was to use Object Oriented Programing for this exercise (and I still stand behind this) which brough some complications with it.
The worst mistake that cost me the enire day was not limiting the futher branching by checking if the branch has any potential (if the amount spent is smaller than the smallest found)

Other than this the solution is pretty basic:
we have objecdts, which make the understanind of the proces easier
we start at the beginning and make a basic depth-first-search using the recursive method game
(at each point where we can chose to cast an ability, we branc out and make a new recursive branch for every choice we had
the search continues in depth, not in width (breath) so we go until we win or lose and than we backtrack to the previous branchings)
(recursion usage on this DFS problem seems perfect, because it provides the most transparent and understandable path that the algorithem takes)

other possible solutions is to implement dijkstra's algorithm which would need to implement some sort of binary heep as well (maybe for the future)
"""