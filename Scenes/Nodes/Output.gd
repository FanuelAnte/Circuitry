extends GraphNode

onready var value_lbl = $ValueLbl

var io_value = 0

func _ready():
	pass

func _process(delta):
	value_lbl.set_text(str(io_value))
	if io_value == 1:
		set_slot_color_left(0, Color(Globals.line_colors["active"]))
		
	elif io_value == 0:
		set_slot_color_left(0, Color(Globals.line_colors["inactive"]))
		
func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
		
func _on_Output_close_request():
	self.queue_free()
