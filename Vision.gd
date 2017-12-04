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
