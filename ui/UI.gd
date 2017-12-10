extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var game = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func update_draw():
	var children = get_children()
	for child in children:
		child.update_draw()