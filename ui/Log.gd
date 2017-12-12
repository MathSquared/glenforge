extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_scroll_follow(true)
	for i in range(14):
		newline()
	pass
func update_draw():
	update()
func connect_actors(actors):
	for actor in actors:
		if !actor.is_connected("send_to_log", self, "retrieve_text"):
			actor.connect("send_to_log", self, "retrieve_text")
func retrieve_text(text):
	newline()
	add_text(text)