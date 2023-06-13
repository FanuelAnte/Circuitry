extends GraphNode

var is_component = true

var generic_graph = preload("res://Scenes/GenericGraph.tscn")
var node_type = "-" 
var scene_path = "res://Scenes/Nodes/Generic.tscn"

var graph_edit = get_parent()
var is_being_dragged = true

var gen_graph
var graph_parent_index = 0

var io_values = [0]
var input_values = [0, 0]

func _ready():
	pass
	
func create_graph(text):
	gen_graph = generic_graph.instance()
	graph_edit.get_parent().get_child(graph_parent_index).add_child(gen_graph)
	gen_graph.rect_position = Vector2(2048, 0)
	gen_graph.name = gen_graph.name.replacen("@", "")
	gen_graph.component_name = text
	gen_graph.load_saved_component(text)

func _process(delta):
	self.title = node_type
	$Name.text = node_type
	
	execute()
	if is_being_dragged:
		self.offset = get_mouse_on_graph_position()
		
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
	for conn in get_parent().connections_list:
		if conn["to"] == self.name:
			input_values[conn["to_port"]] = conn["data"]
			
func execute():
	get_input_values()
	if gen_graph != null and is_instance_valid(gen_graph):
		io_values = gen_graph.evaluate(input_values)
	
func get_mouse_on_graph_position():
	var canvas_transform = graph_edit.get_canvas_transform()
	var graph_pos = canvas_transform.affine_inverse().xform(get_global_mouse_position())
	
	return graph_pos

func _on_Generic_close_request():
	self.queue_free()
