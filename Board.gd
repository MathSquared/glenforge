extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var exist = false
var board_size = Vector2(40,40)

onready var ground = get_node("Ground")
onready var features = get_node("Features")
onready var dark = get_node("Dark")
onready var unseen = get_node("Unseen")

onready var visionCalc = get_node("Vision")

onready var half_tile_offset = ground.get_cell_size() / 2
var board = []
var accessible_list = []
var actors = []

var upstair
var downstair

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if !exist:
		print("making board")
		for x in range(board_size.x):
			board.append([])
			for y in range(board_size.y):
				board[x].append(Tile.new())
		generate_map()
		exist = true
		create_enemies()
	else:
		for each_tile in accessible_list:
			if board[each_tile.x][each_tile.y].actor != null:
				board[each_tile.x][each_tile.y].actor.set_board_pos(Vector2(each_tile.x,each_tile.y))
				board[each_tile.x][each_tile.y].actor.set_pos(ground.map_to_world(Vector2(each_tile.x,each_tile.y)) + half_tile_offset)
# adds actor to board and actor list
func create_enemies():
	var enemies = randi()%10+5
	var created = 0
	var packedRat2 = preload("res://Rat.tscn")
	while(created < min(enemies, accessible_list.size())):
		var pos = accessible_list[randi()%accessible_list.size()]
		var rat2 = packedRat2.instance()
		if(add_actor(rat2, pos)):
			created+=1
func generate_map():
	randomize()
	for x in range(board_size.x):
		for y in range(board_size.y):
			unseen.set_cellv(Vector2(x,y), 0)
			if(int(rand_range(0, 2)) != 0):
				board[x][y].wall = true;
	cell_auto(15)
	place_stairs()
	wall_update()

func cell_auto(loops):
	for _ in range(loops):
		for x in range(board_size.x):
			for y in range(board_size.y):
				var occupied_neighbors = 0
				for i in range(max(0, x - 1), min(x + 1, board_size.x - 1) + 1):
					for j in range(max(0, y - 1), min(y + 1, board_size.y - 1) + 1):
						occupied_neighbors += 1 if board[i][j].wall else 0
				if occupied_neighbors > 5:
					board[x][y].wall = true
				if occupied_neighbors < 4:
					board[x][y].wall = false
					
func place_stairs():
	upstair = get_parent().prev_downstair
	var q = [Vector2(upstair.x, upstair.y)]
	var index = 0;
	while(board[upstair.x][upstair.y].wall):
		var u = q[index]
		for xx in range(u.x - 1, u.x + 2):
			for yy in range(u.y - 1, u.y + 2):
				if xx >= 0 and xx < board_size.x and yy >= 0 and yy < board_size.y:
					if !board[xx][yy].wall:
						upstair.x = xx
						upstair.y = yy
						break
					else:
						q.append(Vector2(xx, yy))
			if !board[upstair.x][upstair.y].wall:
						break
		index += 1
	features.set_cellv(upstair, 0)
	
	accessible_list = [upstair]
	board[upstair.x][upstair.y].accessible = true
	var num_accessible = 0
	while num_accessible < accessible_list.size():
		var u = accessible_list[num_accessible]
		for xx in range(u.x - 1, u.x + 2):
			for yy in range(u.y - 1, u.y + 2):
				if xx >= 0 and xx < board_size.x and yy >= 0 and yy < board_size.y:
					if !board[xx][yy].accessible and !board[xx][yy].wall:
						board[xx][yy].accessible = true
						accessible_list.append(Vector2(xx, yy))
		num_accessible += 1
	
	downstair = accessible_list[accessible_list.size() - 1 - randi() % accessible_list.size() / 4]
	features.set_cellv(Vector2(downstair.x, downstair.y), 1)

func wall_update():
	for x in range(board_size.x):
		for y in range(board_size.y):
			if board[x][y].wall or !board[x][y].accessible:
				ground.set_cellv(Vector2(x, y), 1)
			else:
				ground.set_cellv(Vector2(x, y), 0)

func add_actor(actor, pos=Vector2()):
	if is_in_bounds(pos):
		if !has_wall(pos) && !has_actor(pos):
			actors.append(actor)
			board[pos.x][pos.y].actor = actor
			actor.pos = pos
			actor.set_pos(ground.map_to_world(pos) + half_tile_offset)
			self.add_child(actor)
			return true
	return false
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
	return board[pos.x][pos.y].wall
# returns true if the position contains an actor
func has_actor(pos=Vector2()):
	return board[pos.x][pos.y].actor != null
# draws line from p0 to p1
func draw_line(p0, p1):
	var line = visionCalc.getLine(p0,p1)
	for p in line :
		unseen.set_cellv(p,-1)
		dark.set_cellv(p,-1)
		board[p.x][p.y].seen = true
# draws field of vision for a circle of radius rad around point p on the board
func draw_vision(p, rad):
	for x in range(board_size.x):
		for y in range(board_size.y):
			dark.set_cellv(Vector2(x,y), 0)
			board[x][y].seen = false
	var points = visionCalc.getCircle(p, rad)
	var pointDict = {}
	for y in range(-rad, rad+1):
		pointDict[y] = []
	for point in points :
		pointDict[int(point.y - p.y)].append(point)
	for key in pointDict.keys() :
		pointDict[key].sort()
		for x in range(pointDict[key][0].x, pointDict[key].back().x+1) :
			draw_line(p, Vector2(x,pointDict[key][0].y))
	for actor in actors:
		if board[actor.pos.x][actor.pos.y].seen :
			actor.show()
		else :
			actor.hide()
func run_actor_steps():
	for actor in actors:
		actor.run_step()
class Tile:
	var wall
	var flr
	var feature
	var items = []
	var actor
	var accessible = false
	var seen = false