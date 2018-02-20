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
	boss_stats.append(i_list[-1])


class Entity:
	def __init__(self, hp, dmg, arm):
		self.hp = int(hp)
		self.dmg = int(dmg)
		self.arm = int(arm)

	def attack(self, opp):
		opp.hp -= max(1, self.dmg - opp.arm)


class Player(Entity):
	def __init__(self, hp, dmg, arm, mana):
		super().__init__(hp, dmg, arm)
		self.mana = mana
		self.spent = 0
		self.mt = False #attack at cast, once (4dmg)
		self.dt = False	#attack (2dmg, +2hp)
		self.st = 0 #tick at the beginning of the turn, for mutliple turns (7arm, 6turns)
		self.pt = 0 #tick (3dmg, 6turns)
		self.rt = 0 #tick (+101mana, 5turns)
		self.abilities = []

	def magicMissile(self):
		if (self.mana >= 53):
			self.mana -= 53
			self.spent += 53
			self.abilities.append('m')
			self.mt = True

	def drain(self):
		if (self.mana >= 73):
			self.mana -= 73
			self.spent += 73
			self.abilities.append('d')
			self.dt = True

	def shield(self):
		if (self.mana >= 113):
			self.mana -= 113
			self.spent += 113
			self.abilities.append('s')
			self.st = 6

	def poison(self):
		if (self.mana >= 173):
			self.mana -= 173
			self.spent += 173
			self.abilities.append('p')
			self.pt = 6

	def recharge(self):
		if (self.mana >= 229):
			self.mana -= 229
			self.spent += 229
			self.abilities.append('r')
			self.rt = 5

	def tick(self, opp):
		if (self.st): #we have Shield active
			self.arm = 7
			self.st -= 1
		else : #shield becomes inactive
			self.arm = 0
		if (self.pt): #we have Poison active
			opp.hp -= 3
			self.pt -= 1
		if (self.rt): #we have Recharge active
			self.mana += 101
			self.rt -= 1

	def attack(self, opp):
		if (self.mt): #we used Magic Missile
			opp.hp -= 4
			self.mt = False
		if (self.dt): #we used Drain
			opp.hp -= 2
			self.hp += 2
			self.dt = False



def is_dead(o): #True = dead, False = alive
	if (o.hp <= 0):
		return True
	return False


def is_smallest(o):
	global smallest_amount
	global sequence

	if (o.spent < smallest_amount):
		smallest_amount = o.spent
		sequence = o.abilities



def game(player, boss):
	p = player
	b = boss


	#TICK
	p.tick(b)

	#CHECK
	if (is_dead(b)):
		#print("win", p.abilities)
		is_smallest(p)
		return None

	#CAST  ABILITY
	if (p.mana >= 53): #magic missile
		pm = copy.deepcopy(p)
		bm = copy.deepcopy(b)

		#ABILITY
		pm.magicMissile()

		#ATTACK
		pm.attack(bm)

		#CHECK
		if (is_dead(bm)):
			#print("win", pm.abilities)
			is_smallest(pm)
			return None

		#TICK
		pm.tick(bm)

		#CHECK
		if (is_dead(bm)):
			#print("win", pm.abilities)
			is_smallest(pm)
			return None

		#ATTACK
		bm.attack(pm)

		#CHECK
		if (is_dead(pm)):
			#print("lose", pm.abilities)
			return None

		game(pm, bm)


	if (p.mana >= 73): #drain
		pd = copy.deepcopy(p)
		bd = copy.deepcopy(b)

		pd.drain()

		pd.attack(bd)

		if (is_dead(bd)):
			#print("win", pd.abilities)
			is_smallest(pd)
			return None

		pd.tick(bd)

		if (is_dead(bd)):
			#print("win", pd.abilities)
			is_smallest(pd)
			return None

		bd.attack(pd)

		if (is_dead(pd)):
			#print("lose", pd.abilities)
			return None

		game(pd, bd)


	if (p.mana >= 113 and not p.st): #shield
		ps = copy.deepcopy(p)
		bs = copy.deepcopy(b)

		ps.shield()

		"""ps.attack(bs) #not needed, we dont attack this round

		if (is_dead(bs)):
			#print("win", ps.abilities)
			is_smallest(ps)
			return None"""

		ps.tick(bs)

		if (is_dead(bs)):
			#print("win", ps.abilities)
			is_smallest(ps)
			return None

		bs.attack(ps)

		if (is_dead(ps)):
			#print("lose", ps.abilities)
			return None

		game(ps, bs)


	if (p.mana >= 173 and not p.pt): #poison
		pp = copy.deepcopy(p)
		bp = copy.deepcopy(b)

		pp.poison()

		"""pp.attack(bp) #not neede, we don attack this turn

		if (is_dead(bp)):
			#print("win", pp.abilities)
			is_smallest(pp)
			return None"""

		pp.tick(bp)

		if (is_dead(bp)):
			#print("win", pp.abilities)
			is_smallest(pp)
			return None

		bp.attack(pp)

		if (is_dead(pp)):
			#print("lose", pp.abilities)
			return None

		game(pp, bp)


	if (p.mana >= 229 and not p.rt): #recharge
		pr = copy.deepcopy(p)
		br = copy.deepcopy(b)

		pr.recharge()

		"""pr.attack(br) #not needed, we dont attack this turn

		if (is_dead(br)):
			#print("win", pr.abilities)
			is_smallest(pr)
			return None"""

		pr.tick(br)

		if (is_dead(br)):
			#print("win", pr.abilities)
			is_smallest(pr)
			return None

		br.attack(pr)

		if (is_dead(pr)):
			#print("lose", pr.abilities)
			return None

		game(pr, br)




boss = Entity(boss_stats[0], boss_stats[1], 0)
player = Player(50, 0, 0, 500)


game(player, boss)

print(smallest_amount, sequence)

"""
p:
tick
ability
attack
chekc

b:
tick
attack
check
"""