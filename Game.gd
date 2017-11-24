extends Node2D

onready var player = get_node("Player")
onready var board = get_node("Board")

func _ready():
	set_process_input(true)
	board.add_actor(player, Vector2(14,14))
func _input(event):
	if event.is_action_pressed("ui_up"):
		board.move_actor(player.get_board_pos(), Vector2(0,-1))
	if event.is_action_pressed("ui_down"):
		board.move_actor(player.get_board_pos(), Vector2(0,1))
	if event.is_action_pressed("ui_left"):
		board.move_actor(player.get_board_pos(), Vector2(-1,0))
	if event.is_action_pressed("ui_right"):
		board.move_actor(player.get_board_pos(), Vector2(1,0))