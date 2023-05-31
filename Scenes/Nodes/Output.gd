extends GraphNode

const node_type = "OUTPUT"
var is_component = false

var scene_path = "res://Scenes/Nodes/Output.tscn"

var gen_graph

var is_being_dragged = true
var graph_edit
var label_scene = preload("res://Scenes/Nodes/Extras/ValueLabel.tscn")
onready var margin = $Margin

var io_values = []

func _ready():
	_on_AddBtn_pressed()
	
func _physics_process(delta):
	get_tree().call_group("MainGame", "update_connections")
	execute()
	
func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_left(i, Color(Globals.line_colors["active"]))
		
		elif io_values[i] == 0:
			set_slot_color_left(i, Color(Globals.line_colors["inactive"]))
		
func execute():
	for conn in get_parent().connections_list:
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

func _on_RemoveBtn_pressed():
	var index = 0
	for i in get_children():
		if i.is_in_group("valueLbl"):
			index = i.get_index()
	
	var graph = get_parent()
	var graph_connections = graph.get_connection_list()
	
	for connection in graph_connections:
		if connection["to"] == self.name:
			graph.disconnect_node(connection["from"], connection["from_port"], connection["to"], index)
			
	if get_child(index).is_in_group("valueLbl"):
		var slot_size = get_child(index).rect_size.y
		get_child(index).queue_free()
		self.rect_size.y -= slot_size
		
		io_values.remove(index)
		set_slot_enabled_left(index, false)
		
