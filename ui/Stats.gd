extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var ui = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func update_draw():
	var game = ui.get_parent()
	var player = game.player
	if player != null :
		set_text("Atk: " + String(player.att))
	update()