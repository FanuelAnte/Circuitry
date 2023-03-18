extends GraphNode

var toggle_scene = preload("res://Scenes/Nodes/Extras/Toggle.tscn")
onready var margin = $Margin

var io_values = []

func _ready():
	pass

func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_right(i, Color(Globals.line_colors["active"]))

		elif io_values[i] == 0:
			set_slot_color_right(i, Color(Globals.line_colors["inactive"]))
			
	for child in get_children():
		if child.is_in_group("toggle"):
			child.text = str(io_values[child.get_index()])
	
func set_slot_value(value, slot_index):
	if value == true:
		io_values[slot_index] = 1
	else:
		io_values[slot_index] = 0

func value_toggled(button_pressed, index):
	set_slot_value(button_pressed, index)

func _on_AddBtn_pressed():
	var toggle = toggle_scene.instance()
	io_values.append(0)
	add_child(toggle)
	move_child(toggle, margin.get_index())
	
	toggle.connect("input_toggled", self, "set_slot_value")
	
	for i in range(io_values.size()):
		set_slot_enabled_right(i, true)

func _on_RemoveBtn_pressed():
	var index = 0
	for i in get_children():
		if i.is_in_group("toggle"):
			index = i.get_index()
	
	if get_child(index).is_in_group("toggle"):
		get_child(index).queue_free()
	
		io_values.remove(index)
		set_slot_enabled_right(index, false)
