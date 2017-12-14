extends "res://Actor.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func init_stats():
	max_life = 5
	att = 1
	vision = 5
	name = "Player"
func draw_vision():
	board.draw_vision(pos, vision)
func die():
	.die()
	emit_signal("send_to_log","Press R to reset the game.")
	board.get_parent().player = null