extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var game = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
func update_ui():
	var children = get_children()
	for child in children:
		child.update_draw()
#prepares UI positioning and signal connections
func prep_ui():
	var log_panel = get_node("LogPanel")
	log_panel.set_margin(MARGIN_TOP, get_size().y - 300)
	connect_log()
func connect_log():
	var game_log = get_node("LogPanel/Log")
	var actors = game.board.actors
	game_log.connect(actors)