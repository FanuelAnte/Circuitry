extends GraphNode

onready var toggle = $Toggle

var io_values = [0, 0, 0]

func _ready():
	pass

func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_right(i, Color(Globals.line_colors["active"]))

		elif io_values[i] == 0:
			set_slot_color_right(i, Color(Globals.line_colors["inactive"]))
		
#func execute():
#	pass
#	for conn in Globals.connections:
#		if conn["to"] == self.name:
#			io_value = conn["data"]

func set_slot_value(value, slot_index):
	if value == true:
		io_values[slot_index] = 1
	else:
		io_values[slot_index] = 0

func _on_Toggle_toggled(button_pressed):
	set_slot_value(button_pressed, 0)

func _on_Toggle2_toggled(button_pressed):
	set_slot_value(button_pressed, 1)

func _on_Toggle3_toggled(button_pressed):
	set_slot_value(button_pressed, 2)
	
func _on_Input_close_request():
	self.queue_free()
