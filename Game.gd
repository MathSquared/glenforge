extends Node2D


onready var board = get_node("Board")
var player
onready var ui = get_node("UI")
var levels = []
var level = 0
var prev_downstair = Vector2(17, 17)

func _ready():
	set_process_input(true)
	player = preload("res://Player.tscn").instance()
	board.add_actor(player, board.upstair)
	player.draw_vision()
	levels.append(board)
	var board_width = board.half_tile_offset.x*board.board_size.x*2
	var board_length = board.half_tile_offset.y*board.board_size.y*2
	ui.set_pos(Vector2(board_width,0))
	ui.set_size(Vector2(board_width/2, board_length))
	ui.prep_ui()
	ui.update_ui()
	OS.set_window_size(Vector2(board_width*3/2, board_length))
func _input(event):
	if event.is_action_pressed("move_up"):
		step(Vector2(0,-1))
	if event.is_action_pressed("move_down"):
		step(Vector2(0,1))
	if event.is_action_pressed("move_left"):
		step(Vector2(-1,0))
	if event.is_action_pressed("move_right"):
		step(Vector2(1,0))
	if event.is_action_pressed("move_upleft"):
		step(Vector2(-1,-1))
	if event.is_action_pressed("move_downleft"):
		step(Vector2(-1,1))
	if event.is_action_pressed("move_upright"):
		step(Vector2(1,-1))
	if event.is_action_pressed("move_downright"):
		step(Vector2(1,1))
	if event.is_action_pressed("level_descend"):
		prev_downstair = board.downstair
		board.remove_child(player)
		self.remove_child(board)
		level += 1
		if level == levels.size():
			var packedBoard = preload("res://Board.tscn")
			board = packedBoard.instance()
			levels.append(board)
			self.add_child(board)
			board.add_actor(player, board.upstair)
			player.draw_vision()
#			var packedRat = preload("res://Rat.tscn")
#			var rat = packedRat.instance()
#			board.add_actor(rat, Vector2(10,14))
		else:
			board = levels[level]
			self.add_child(board)
			board.add_child(player)
		#print(level, levels.size())
	if event.is_action_pressed("level_ascend"):
		if level > 0:
			board.remove_child(player)
			self.remove_child(board)
			level -= 1
			board = levels[level]
			self.add_child(board)
			board.add_child(player)
		#print(level, levels.size())
func step(move):
	if player != null:
		board.move_actor(player.get_board_pos(), move)
		player.draw_vision()
		board.run_actor_steps()
		ui.update_ui()


