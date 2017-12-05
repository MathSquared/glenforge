extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var boardScene = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
# Line algorithm is Bresenham's algorithm
# returns a list of points that form a line from point p0 to point p1
# will stop on walls, so if the list does not contain p1, the line is blocked
func getLine(p0=Vector2(), p1=Vector2()):
	var board = boardScene.board
	
	var dx = abs(p1.x - p0.x)
	var dy = abs(p1.y - p0.y)
	
	var curX = p0.x
	var curY = p0.y
	
	var points = []
	
	var err = dx - dy
	
	var incX
	var incY
	
	if p0.x < p1.x :
		incX = 1
	else:
		incX = -1
	if p0.y < p1.y :
		incY = 1
	else:
		incY = -1
	points.append(Vector2(curX, curY))
	while (curX != p1.x || curY != p1.y) && boardScene.is_in_bounds(Vector2(curX,curY)):
		if board[curX][curY].wall :
			break 
		var err2 = err*2
		if err2 > -dx :
			err -= dy
			curX += incX
		if err2 < dx :
			err += dx
			curY += incY
		if boardScene.is_in_bounds(Vector2(curX,curY)):
			points.append(Vector2(curX, curY))
		
	return points
# returns list of points that are in a circle of radius r around the given point p
func getCircle(p, rad):
	var points = []
	var x = 0
	var y = rad
	var ddf_x = 1
	var ddf_y = -2 * rad
	var f = 1 - rad
	
	points.append(Vector2(p.x + rad, p.y))
	points.append(Vector2(p.x - rad, p.y))
	points.append(Vector2(p.x, p.y + rad))
	points.append(Vector2(p.x, p.y - rad))
	
	while x < y:
		if f >= 0 : 
			y -= 1
			ddf_y += 2
			f += ddf_y
		x += 1
		ddf_x += 2
		f += ddf_x
		points.append(Vector2(p.x + x, p.y + y))
		points.append(Vector2(p.x - x, p.y + y))
		points.append(Vector2(p.x + x, p.y - y))
		points.append(Vector2(p.x - x, p.y - y))
		points.append(Vector2(p.x + y, p.y + x))
		points.append(Vector2(p.x - y, p.y + x))
		points.append(Vector2(p.x + y, p.y - x))
		points.append(Vector2(p.x - y, p.y - x))
		
	return points
# gets path between two points using A*
func a_star_path(p0=Vector2(),p1=Vector2()):
	var board = boardScene.board
	# dictionary that contains the best node that each node can be reached from
	var cameFrom = {}

	# grid that contains cost of path from start node to the node for every node
	var gScore = []
	
	for x in range(boardScene.board_size.x):
		gScore.append([])
		for y in range(boardScene.board_size.y):
			gScore[x].append(999999)
	# grid that contains the cost to get from start to finish node going through the node for every node, is partly heuristic
	var fScore = gScore
	
	gScore[p0.x][p0.y] = 0
	fScore[p0.x][p0.y] = cost_heuristic(p0,p1)
	var closedSet = []
	var openSet = [p0]
	
	while(openSet.size() > 0):
		var current = lowest_fscore(openSet, fScore)
		if current == p1:
			return construct_path(cameFrom,current)
		openSet.erase(current)
		closedSet.append(current)
		for neighbor in neighbors(current):
			if closedSet.has(neighbor):
				continue
			if boardScene.has_wall(neighbor):
				closedSet.append(neighbor)
				continue
			if !openSet.has(neighbor):
				openSet.append(neighbor)
			var tentative_gScore = gScore[current.x][current.y] + 1
			if tentative_gScore >= gScore[neighbor.x][neighbor.y]:
				continue
			cameFrom[neighbor] = current
			gScore[neighbor.x][neighbor.y] = tentative_gScore
			fScore[neighbor.x][neighbor.y] = gScore[neighbor.x][neighbor.y] + cost_heuristic(neighbor, p1)
	# if failed to find path
	return [p0]
	
# cost heuristic for a*
func cost_heuristic(p0,p1):
	var dx = abs(p1.x - p0.x)
	var dy = abs(p1.y - p0.y)
	return max(dx,dy)
# returns the node with the lowest fscore from the open set
func lowest_fscore(openSet, fScore):
	var lowestNode = openSet[0]
	var lowestFscore = 999999
	for node in openSet:
		if fScore[node.x][node.y] < lowestFscore:
			lowestNode = node
			lowestFscore = fScore[node.x][node.y]
	return lowestNode
# returns neighboring nodes accounting for bounds
func neighbors(p0):
	var neighbors = []
	for x in range(p0.x-1, p0.x+2):
		for y in range(p0.y-1, p0.y+2):
			if boardScene.is_in_bounds(Vector2(x,y)) && Vector2(x,y) != p0:
				neighbors.append(Vector2(x,y))
	return neighbors
func construct_path(cameFrom, current):
	var path = []
	path.push_front(current)
	while cameFrom.keys().has(current):
		current = cameFrom[current]
		path.push_front(current)
	return path