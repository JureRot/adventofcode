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
		self.mana = int(mana)
		self.spent = 0
		self.abilities = []
		self.mt = False
		self.dt = False
		self.st = 0
		self.pt = 0
		self.rt = 0

	def magicMissile(self):
		if (self.mana >= 53):
			self.mana -= 53
			self.spent += 53
			self.mt = True

	def drain(self):
		if (self.mana >= 73):
			self.mana -= 73
			self.spent += 73
			self.dt = True

	def shield(self):
		if (self.mana >= 113):
			self.mana -= 113
			self.spent += 113
			self.st = 6

	def poison(self):
		if (self.mana >= 173):
			self.mana -= 173
			self.spent += 173
			self.pt = 6

	def recharge(self):
		if (self.mana >= 229):
			self.mana -= 229
			self.spent += 229
			self.rt = 5


	def attack(self, opp):
		if (self.mt):
			opp.hp -= 4
			self.mt = False

		if (self.dt):
			opp.hp -= 2
			self.hp += 2
			self.dt = False

	def tick(self, opp):
		if (self.st):
			self.arm = 7
			self.st -= 1
			if (self.st == 0):
				self.arm = 0

		if (self.pt):
			opp.hp -= 3
			self.pt -=1

		if (self.rt):
			self.mana += 101
			self.rt -= 1


def game(player, boss):
	p = player
	b = boss

	
boss = Entity(boss_stats[0], boss_stats[1], 0)
player = Player(50, 0, 0, 500)

game(player, boss)


"""
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