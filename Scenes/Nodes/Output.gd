extends GraphNode

var label_scene = preload("res://Scenes/Nodes/Extras/ValueLabel.tscn")
onready var margin = $Margin

var io_values = []

func _ready():
	pass

func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_left(i, Color(Globals.line_colors["active"]))

		elif io_values[i] == 0:
			set_slot_color_left(i, Color(Globals.line_colors["inactive"]))
	
func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_values[conn["to_port"]] = conn["data"]
			
	for child in get_children():
		if child.is_in_group("valueLbl"):
			child.text = str(io_values[child.get_index()])
			
func _on_AddBtn_pressed():
	var value_label = label_scene.instance()
	io_values.append(0)
	add_child(value_label)
	move_child(value_label, margin.get_index())
	
	for i in range(io_values.size()):
		set_slot_enabled_left(i, true)

