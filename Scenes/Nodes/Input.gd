extends GraphNode

onready var toggle = $Toggle

var io_value = 0

func _ready():
	pass

func _process(delta):
	toggle.set_text(str(io_value))
	if io_value == 1:
		set_slot_color_right(1, Color("9cd6d9"))
		
	elif io_value == 0:
		set_slot_color_right(1, Color("4b626e"))
		
func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
		
func _on_Toggle_toggled(button_pressed):
	if button_pressed == true:
		io_value = 1
	else:
		io_value = 0

func _on_Input_close_request():
	self.queue_free()
