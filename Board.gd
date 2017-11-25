extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var board_size = Vector2(40,40)

onready var ground = get_node("Ground")

onready var half_tile_offset = ground.get_cell_size() / 2
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
func add_actor(actor, pos=Vector2()):
	if is_in_bounds(pos):
		if !has_wall(pos) && !has_actor(pos):
			actors.append(actor)
			board[pos.x][pos.y].actor = actor
			actor.pos = pos
			actor.set_pos(ground.map_to_world(pos) + half_tile_offset)
			self.add_child(actor)
		
# removes actor from the board and actor list
func remove_actor(actor, pos=Vector2()):
	board[pos.x][pos.y].actor = null
	actors.remove(actors.find(actor))
# moves actor from one position to another on the board
# move is the movement relative to the old position
# returns Vector2 of new position (if movement not possible, returns old position)
func move_actor(old_pos=Vector2(), move=Vector2()):
	var new_pos = old_pos + move
	if is_in_bounds(new_pos):
		if has_actor(new_pos):
			var actor1 = board[old_pos.x][old_pos.y].actor
			var actor2 = board[new_pos.x][new_pos.y].actor
			actor1.attack(actor2)
		elif !has_wall(new_pos) && !has_actor(new_pos):
			board[new_pos.x][new_pos.y].actor = board[old_pos.x][old_pos.y].actor
			board[old_pos.x][old_pos.y].actor = null
			board[new_pos.x][new_pos.y].actor.set_pos(ground.map_to_world(new_pos) + half_tile_offset)
			board[new_pos.x][new_pos.y].actor.set_board_pos(new_pos)
			return new_pos
	return old_pos
# returns true if the position is in the board
func is_in_bounds(pos=Vector2()):
	return pos.x >= 0 && pos.x < board_size.x && pos.y >= 0 && pos.y < board_size.y
# returns true if the position contains a wall
func has_wall(pos=Vector2()):
	return board[pos.x][pos.y].wall != null
# returns true if the position contains an actor
func has_actor(pos=Vector2()):
	return board[pos.x][pos.y].actor != null
class Tile:
	var wall
	var flr
	var feature
	var items = []
	var actor