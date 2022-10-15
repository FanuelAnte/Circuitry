extends GraphNode

var trail_scene = load("res://Scenes/trail.tscn")

onready var point = $ScreenParent/Screen/point
onready var value = $ValueLbl

var io_value = 0
var direction = 1

var draw_trail = true

func _ready():
	pass
	
func _process(delta):
	value.set_text(str(io_value))
	if io_value == 1:
		set_slot_color_left(1, Color("f74464"))
		if point.position.y > 16:
			point.position.y -= 10
		
	elif io_value == 0:
		set_slot_color_left(1, Color("6a7285"))
		if point.position.y < 144:
			point.position.y += 10
			
	point.position.x += 2 * direction
	
	if point.position.x >= 384:
		point.get_children()[0].start_suicide = true
		var new_trail = trail_scene.instance()
		point.add_child(new_trail)
		point.position.x = 16
		
func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
			
func _on_OSC_close_request():
	self.queue_free()
