extends Node2D

onready var player = get_node("Player")

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_up"):
		player.set_pos(player.get_pos() + Vector2(0, -16))
	if event.is_action_pressed("ui_down"):
		player.set_pos(player.get_pos() + Vector2(0, 16))
	if event.is_action_pressed("ui_left"):
		player.set_pos(player.get_pos() + Vector2(-16, 0))
	if event.is_action_pressed("ui_right"):
		player.set_pos(player.get_pos() + Vector2(16, 0))