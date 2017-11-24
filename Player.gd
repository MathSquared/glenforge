extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pos = Vector2(0,0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
# getter and setter for var pos
func get_board_pos():
	return pos
func set_board_pos(new_pos=Vector2()):
	pos = new_pos
	print(pos)
