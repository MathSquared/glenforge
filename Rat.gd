extends "res://Actor.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var target

func init_stats():
	maxLife = 2
	att = 1
	vision = 5
	name = "rat"
func run_step():
	var visionCalc = board.get_node("Vision")
	var points = visionCalc.getCircle(pos,vision)
	var pointDict = {}
	for y in range(-vision, vision+1):
		pointDict[y] = []
	for point in points :
		pointDict[int(point.y - pos.y)].append(point)
	for key in pointDict.keys() :
		pointDict[key].sort()
		for x in range(pointDict[key][0].x, pointDict[key].back().x+1) :
			points += visionCalc.getLine(pos, Vector2(x,pointDict[key][0].y))
	for p in points:
		if board.is_in_bounds(p):
			if board.has_actor(p):
				if board.board[p.x][p.y].actor.name == "Player":
					var path = visionCalc.a_star_path(pos, p)
					target = p
					if(!board.has_actor(path[1]) || board.board[path[1].x][path[1].y].actor.name == "Player"):
						board.move_actor(pos, path[1] - pos)
					return
	if target != null:
		var path = visionCalc.a_star_path(pos, target)
		if path[0] == target:
			target = null
			return
		if(!board.has_actor(path[1]) || board.board[path[1].x][path[1].y].actor.name == "Player"):
			board.move_actor(pos, path[1] - pos)