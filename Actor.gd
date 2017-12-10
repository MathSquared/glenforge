extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pos
var max_life
var cur_life
var att
var vision
var name
onready var board = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	init_stats()
	cur_life = max_life
	pass
func init_stats():
	max_life = 1
	att = 1
	vision = 1
	name = "Unnamed"
# getter and setter for var pos
func get_board_pos():
	return pos
func set_board_pos(new_pos=Vector2()):
	pos = new_pos
func attack(actor):
	actor.get_damaged(att)
func get_damaged(dmg):
	cur_life -= dmg
	if(cur_life <= 0):
		die()
func die():
	board.remove_actor(self, pos)
	self.queue_free()
func gain_life(life):
	cur_life += life
	if cur_life > max_life:
		cur_life = max_life
# runs the ai for a single turn
func run_step():
	pass