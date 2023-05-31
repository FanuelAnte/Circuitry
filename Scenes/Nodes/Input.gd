extends GraphNode

const node_type = "INPUT"
var is_component = false

var scene_path = "res://Scenes/Nodes/Input.tscn"

var gen_graph

var is_being_dragged = true
var graph_edit
var toggle_scene = preload("res://Scenes/Nodes/Extras/Toggle.tscn")
onready var margin = $Margin

var io_values = []

func _ready():
	_on_AddBtn_pressed()
	_on_AddBtn_pressed()

func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_right(i, Color(Globals.line_colors["active"]))
		
		elif io_values[i] == 0:
			set_slot_color_right(i, Color(Globals.line_colors["inactive"]))
			
	for child in get_children():
		if child.is_in_group("toggle"):
			child.text = str(io_values[child.get_index()])
			
	for i in get_children():
		var index = 0
		if i.is_in_group("toggle"):
			index = i.get_index()
			i.pressed = io_values[index] 
	
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
	
	var graph = get_parent()
	var graph_connections = graph.get_connection_list()

	for connection in graph_connections:
		if connection["from"] == self.name:
			graph.disconnect_node(connection["from"], index, connection["to"], connection["to_port"])
	
	if get_child(index).is_in_group("toggle"):
		var slot_size = get_child(index).rect_size.y
		get_child(index).queue_free()
		self.rect_size.y -= slot_size
	
		io_values.remove(index)
		set_slot_enabled_right(index, false)
