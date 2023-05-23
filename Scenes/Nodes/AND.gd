extends GraphNode

var io_values = [0]
var input_values = [0, 0]

func _ready():
	pass
	
func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_right(1, Color(Globals.line_colors["active"]))
		
		elif io_values[i] == 0:
			set_slot_color_right(1, Color(Globals.line_colors["inactive"]))

	if input_values[0] == 1:
		set_slot_color_left(0, Color(Globals.line_colors["active"]))
	elif input_values[0] == 0:
		set_slot_color_left(0, Color(Globals.line_colors["inactive"]))
	
	if input_values[1] == 1:
		set_slot_color_left(2, Color(Globals.line_colors["active"]))
	elif input_values[1] == 0:
		set_slot_color_left(2, Color(Globals.line_colors["inactive"]))

func get_input_values():
	input_values = [0, 0]
	for conn in Globals.connections:
		if conn["to"] == self.name:
			input_values[conn["to_port"]] = conn["data"]
			
func execute():
	get_input_values()
	if input_values[0] and input_values[1]:
		io_values[0] = 1
	else:
		io_values[0] = 0
			
func _on_AND_close_request():
	self.queue_free()
