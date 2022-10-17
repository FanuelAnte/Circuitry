extends GraphNode

var trail_scene = load("res://Scenes/trail.tscn")

onready var point = $ScreenParent/Screen/point
onready var value = $ValueLbl

onready var y_speed_slider = $YSpeedCont/YSpeedSlider

var y_speed = 1
var resolutions = [1, 2, 4, 8, 16, 32]

var io_value = 0
var direction = 1

var draw_trail = true

func _ready():
#	y_speed = y_speed_slider.value
	pass
	
func _process(delta):
	value.set_text(str(io_value))

	if io_value == 1:
		set_slot_color_left(1, Color("f74464"))
		if point.position.y > 16:
			point.position.y -= y_speed
		
		elif point.position.y < 16:
			point.position.y = 16
		
	elif io_value == 0:
		set_slot_color_left(1, Color("6a7285"))
		if point.position.y < 144:
			point.position.y += y_speed
		
		elif point.position.y > 144:
			point.position.y = 144
		
			
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
	
func _on_YSpeedSlider_value_changed(value):
	y_speed = int(value)


func _on_YSpeedSlider_item_selected(index):
#	y_speed = resolutions[index]
	y_speed = int(y_speed_slider.get_item_text(index))
