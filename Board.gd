extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var board_size = Vector2(40,40)

var board = []

var actors = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for x in range(board_size.x):
		board.append([])
		for y in range(board_size.y):
			board[x].append(Tile.new())
# adds actor to board and actor list
func add_actor(actor, x, y):
	if x >= 0 && x <= board_size.x && y >= 0 && y <= board_size.y && board[x][y].actor == null:
		actors.append(actor)
		board[x][y].actor = actor
		
# moves actor from one position to another on the board
# move is the movement relative to the old position
func move_actor(oldpos=Vector2(), move=Vector2()):
	var board_pos = oldpos + move
	var x = board_pos.x
	var y = board_pos.y
	if x >= 0 && x <= board_size.x && y >= 0 && y <= board_size.y && board[x][y].actor == null:
		board[x][y].actor = board[oldpos.x][oldpos.y].actor
		board[oldpos.x][oldpos.y].actor = null

class Tile:
	var wall
	var flr
	var feature
	var items = []
	var actor