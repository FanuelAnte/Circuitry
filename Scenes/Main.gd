extends GraphEdit

var connections_list = []

func _ready():
	pass # Replace with function body.
	
func _process(delta):
	update_connections()

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
