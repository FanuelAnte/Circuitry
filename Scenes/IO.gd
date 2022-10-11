extends GraphNode

onready var toggle = $toggle

var io_type
var io_value = 0
var type = "io"

func _ready():
	if io_type == "INPUT":
		set_slot(1, false, 0, Color("6a7285"), true, 0, Color("f74464"))
	elif io_type == "OUTPUT":
		toggle.disabled = true
		set_slot(1, true, 0, Color("6a7285"), false, 0, Color("f74464"))
	
func _process(delta):
	toggle.set_text(str(io_value))
	if io_value == 1:
		if io_type == "INPUT":
			set_slot_color_right(1, Color("f74464"))
			
		elif io_type == "OUTPUT":
			set_slot_color_left(1, Color("f74464"))
	elif io_value == 0:
		if io_type == "INPUT":
			set_slot_color_right(1, Color("6a7285"))
			
		elif io_type == "OUTPUT":
			set_slot_color_left(1, Color("6a7285"))
	
func _on_IO_close_request():
	self.queue_free()

func execute():
	for conn in Globals.connections:
#		if self.name in conn.values():
		if conn["to"] == self.name:
			io_value = conn["data"]
			
func _on_toggle_toggled(button_pressed):
	if button_pressed == true:
		io_value = 1
	else:
		io_value = 0
