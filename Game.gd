extends Node2D


onready var board = get_node("Board")
onready var player = board.get_node("Player")
var levels = []
var level = 0

func _ready():
	set_process_input(true)
	var x = 0
	var y = 0
	while(!board.add_actor(player, Vector2(x,y)) and x<40):
		x+=1
		y+=1
	player.drawVision()
	levels.append(board)
func _input(event):
	if event.is_action_pressed("move_up"):
		board.move_actor(player.get_board_pos(), Vector2(0,-1))
		player.drawVision()
	if event.is_action_pressed("move_down"):
		board.move_actor(player.get_board_pos(), Vector2(0,1))
		player.drawVision()
	if event.is_action_pressed("move_left"):
		board.move_actor(player.get_board_pos(), Vector2(-1,0))
		player.drawVision()
	if event.is_action_pressed("move_right"):
		board.move_actor(player.get_board_pos(), Vector2(1,0))
		player.drawVision()
	if event.is_action_pressed("move_upleft"):
		board.move_actor(player.get_board_pos(), Vector2(-1,-1))
		player.drawVision()
	if event.is_action_pressed("move_downleft"):
		board.move_actor(player.get_board_pos(), Vector2(-1,1))
		player.drawVision()
	if event.is_action_pressed("move_upright"):
		board.move_actor(player.get_board_pos(), Vector2(1,-1))
		player.drawVision()
	if event.is_action_pressed("move_downright"):
		board.move_actor(player.get_board_pos(), Vector2(1,1))
		player.drawVision()
	if event.is_action_pressed("level_descend"):
		board.remove_child(player)
		self.remove_child(board)
		level += 1
		if level == levels.size():
			var packedBoard = preload("res://Board.tscn")
			board = packedBoard.instance()
			levels.append(board)
			self.add_child(board)
			var x = 0
			var y = 0
			while(!board.add_actor(player, Vector2(x,y)) and x<40):
				x+=1
				y+=1
			player.drawVision()
			var packedRat = preload("res://Rat.tscn")
			var rat = packedRat.instance()
			board.add_actor(rat, Vector2(10,14))
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