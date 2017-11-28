extends Node2D


onready var board = get_node("Board")
onready var player = board.get_node("Player")

func _ready():
	set_process_input(true)
	var x = 0
	var y = 0
	while(!board.add_actor(player, Vector2(x,y)) and x<40):
		x+=1
		y+=1
	var packedRat = preload("res://Rat.tscn")
	var rat = packedRat.instance()
	board.add_actor(rat, Vector2(10,14))
func _input(event):
	if event.is_action_pressed("move_up"):
		board.move_actor(player.get_board_pos(), Vector2(0,-1))
	if event.is_action_pressed("move_down"):
		board.move_actor(player.get_board_pos(), Vector2(0,1))
	if event.is_action_pressed("move_left"):
		board.move_actor(player.get_board_pos(), Vector2(-1,0))
	if event.is_action_pressed("move_right"):
		board.move_actor(player.get_board_pos(), Vector2(1,0))
	if event.is_action_pressed("move_upleft"):
		board.move_actor(player.get_board_pos(), Vector2(-1,-1))
	if event.is_action_pressed("move_downleft"):
		board.move_actor(player.get_board_pos(), Vector2(-1,1))
	if event.is_action_pressed("move_upright"):
		board.move_actor(player.get_board_pos(), Vector2(1,-1))
	if event.is_action_pressed("move_downright"):
		board.move_actor(player.get_board_pos(), Vector2(1,1))
	if event.is_action_pressed("level_descend"):
		board.remove_child(player)
		self.remove_child(board)
		var packedBoard = preload("res://Board.tscn")
		board = packedBoard.instance()
		self.add_child(board)
		var x = 0
		var y = 0
		while(!board.add_actor(player, Vector2(x,y)) and x<40):
			x+=1
			y+=1
		var packedRat = preload("res://Rat.tscn")
		var rat = packedRat.instance()
		board.add_actor(rat, Vector2(10,14))