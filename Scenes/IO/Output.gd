extends GraphNode

onready var value = $ValueLbl

var io_value = 0

func _ready():
	pass

func _process(delta):
	value.set_text(str(io_value))
	if io_value == 1:
		set_slot_color_left(1, Color("f74464"))
		
	elif io_value == 0:
		set_slot_color_left(1, Color("6a7285"))
		
func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
		
func _on_Output_close_request():
	self.queue_free()
