extends GraphEdit

var component_name

var connections_list = []

func _ready():
	pass
	

func _process(delta):
	update_connections()

func load_saved_component(comp_id):
	var file = File.new()
	if file.file_exists("user://" + str(comp_id) + ".comp"):
		
		file.open("user://" + str(comp_id) + ".comp", File.READ)
		var save_data = parse_json(file.get_line())
		
		for node in save_data["nodes"]:
			var path = load(node["scene_path"])
			var added_node = path.instance()
			self.add_child(added_node)
			added_node.name = node["node_name"]
			added_node.graph_edit = self
			added_node.is_being_dragged = false
			added_node.offset = Vector2(node["node_position_x"], node["node_position_y"])
			
			if added_node.node_type == "INPUT":
				added_node.io_values = node["io_values"]
			
#			if added_node.is_component:
#				added_node.node_type = node["node_type"]
#				added_node.gen_graph = node["generic_graph"]
#				added_node.create_graph(added_node.node_type)
			
		for connection in save_data["connections"]:
			self.connect_node(connection["from"].replacen("@", ""), connection["from_port"], connection["to"].replacen("@", ""), connection["to_port"])
		
		file.close()

func update_connections():
	var connections = self.get_connection_list()

	for i in range(connections.size()):
		var node = self.get_node(connections[i].from)
		if is_instance_valid(node):
			if node.io_values[connections[i].from_port] != null:
				connections[i]["data"] = node.io_values[connections[i].from_port]
		else:
			connections[i]["data"] = 0
	
	connections_list = connections
	
func evaluate(io_values):
	for node in self.get_children():
		if node.is_in_group("input"):
			node.io_values = io_values
	
		if node.is_in_group("output"):
			return node.io_values
