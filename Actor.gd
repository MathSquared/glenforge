extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pos
var maxLife
var curLife
var att
var vision
var name
onready var board = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	init_stats()
	curLife = maxLife
	pass
func init_stats():
	maxLife = 1
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
	curLife -= dmg
	if(curLife <= 0):
		die()
func die():
	board.remove_actor(self, pos)
	self.queue_free()
# runs the ai for a single turn
func run_step():
	pass