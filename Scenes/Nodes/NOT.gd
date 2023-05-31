extends GraphNode

const node_type = "NOT" 
var is_component = false

var scene_path = "res://Scenes/Nodes/NOT.tscn"

var gen_graph

var graph_edit
var is_being_dragged = true

var io_values = [0]
var input_values = [0]

func _ready():
	pass

func _physics_process(delta):
	execute()
	if is_being_dragged:
		self.offset = get_mouse_on_graph_position()
		
func _process(delta):
	for i in range(io_values.size()):
		if io_values[i] == 1:
			set_slot_color_right(1, Color(Globals.line_colors["active"]))
		
		elif io_values[i] == 0:
			set_slot_color_right(1, Color(Globals.line_colors["inactive"]))
	
	if input_values[0] == 1:
		set_slot_color_left(1, Color(Globals.line_colors["active"]))
	elif input_values[0] == 0:
		set_slot_color_left(1, Color(Globals.line_colors["inactive"]))
	
func get_input_values():
	input_values = [0, 0]
	for conn in get_parent().connections_list:
		if conn["to"] == self.name:
			input_values[conn["to_port"]] = conn["data"]
			
func execute():
	get_input_values()
	if input_values[0]:
		io_values[0] = 0
	else:
		io_values[0] = 1
			
func _on_NOT_close_request():
	self.queue_free()
	
func get_mouse_on_graph_position():
	var canvas_transform = graph_edit.get_canvas_transform()
	var graph_pos = canvas_transform.affine_inverse().xform(get_global_mouse_position())
	
	return graph_pos
