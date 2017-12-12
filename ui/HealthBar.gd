extends ProgressBar

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var ui = get_parent()
onready var health_label = get_node("HealthLabel")

func _ready():
	# Called every time the node is added to the scene.
	set_min(0)
	set_percent_visible(false)
	# Initialization here
	pass
func update_draw():
	var game = ui.get_parent()
	var player = game.player
	var cur_life
	if player == null :
		cur_life = 0
	else :
		cur_life = player.cur_life
		set_max(player.max_life)
	set_value(cur_life)
	health_label.set_text(String(cur_life) + "/" + String(get_max()))
	update()
