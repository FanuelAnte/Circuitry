extends Control

var and_scene = preload("res://Scenes/Nodes/AND.tscn")
var not_scene = preload("res://Scenes/Nodes/NOT.tscn")
var input_scene = preload("res://Scenes/Nodes/Input.tscn")
var output_scene = preload("res://Scenes/Nodes/Output.tscn")

onready var extra_graphs = $ExtraGraphs

onready var graph_edit = $GraphEdit
onready var node_menu = $NodeMenu

var nodes_in_graph = []

func _ready():
	graph_edit.get_zoom_hbox().visible = false
	node_menu.parse_validation_table()
#	graph_edit.get_child(1).offset = Vector2(1640, 456)
#	graph_edit.get_child(2).offset = Vector2(128, 456)
	load_saved_file(Globals.current_problem["id"])

func save(problem_id, nodes, connections):
	var file = File.new()
	file.open("user://" + str(problem_id) + ".save", File.WRITE)
	var save_data = {"nodes" : nodes, "connections" : connections}
	file.store_line(to_json(save_data))
	file.close()

func load_saved_file(problem_id):
	var file = File.new()
	if not file.file_exists("user://" + str(problem_id) + ".save"):
		var input_node = input_scene.instance()
		graph_edit.add_child(input_node)
		input_node.offset = Vector2(128, 456)
		
		var output_node = output_scene.instance()
		graph_edit.add_child(output_node)
		output_node.offset = Vector2(1640, 456)
	
	if file.file_exists("user://" + str(problem_id) + ".save"):
		for node in graph_edit.get_children():
			if node.is_in_group("node"):
				node.queue_free()
			
		file.open("user://" + str(problem_id) + ".save", File.READ)
		var save_data = parse_json(file.get_line())
		
		for node in save_data["nodes"]:
			var path = load(node["scene_path"])
			var added_node = path.instance()
			graph_edit.add_child(added_node)
			added_node.name = node["node_name"]
			added_node.graph_edit = graph_edit
			added_node.is_being_dragged = false
			added_node.offset = Vector2(node["node_position_x"], node["node_position_y"])
			
			if added_node.node_type == "INPUT":
				added_node.io_values = node["io_values"]
				
			if added_node.is_component:
				added_node.node_type = node["node_type"]
				added_node.gen_graph = node["generic_graph"]
				added_node.graph_parent_index = 2
				added_node.create_graph(added_node.node_type)
				
		for connection in save_data["connections"]:
			graph_edit.connect_node(connection["from"].replacen("@", ""), connection["from_port"], connection["to"].replacen("@", ""), connection["to_port"])
		
		file.close()

func _process(delta):
	update_connections()
	if Input.is_mouse_button_pressed(2): 
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(node_menu, "rect_position", get_global_mouse_position(), 0.3)

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	for con in graph_edit.get_connection_list():
		if con.to == to and con.to_port == to_slot:
			return
	graph_edit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graph_edit.disconnect_node(from, from_slot, to, to_slot)

func update_connections():
	var connections = graph_edit.get_connection_list()

	for i in range(connections.size()):
		var node = graph_edit.get_node(connections[i].from)
		if is_instance_valid(node):
			if node.io_values[connections[i].from_port] != null:
				connections[i]["data"] = node.io_values[connections[i].from_port]
		else:
			connections[i]["data"] = 0
		
	Globals.connections = connections
	
func _on_Timer_timeout():
	
	var current_nodes = []
	var connections = graph_edit.get_connection_list()
	for node in graph_edit.get_children():
		if node.is_in_group("node"):
			current_nodes.append({
				"node_type": node.node_type,
				"is_comp": node.is_component,
				"generic_graph" : node.gen_graph,
				"node_name" : node.name.replacen("@", ""),
				"node_position_x" : node.offset.x,
				"node_position_y" : node.offset.y,
				"io_values" : node.io_values,
				"scene_path" : node.scene_path,
			})
	nodes_in_graph = current_nodes
	save(Globals.current_problem["id"], current_nodes, connections)
