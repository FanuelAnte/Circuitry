extends Control

onready var graph_edit = $GraphEdit
onready var node_menu = $NodeMenu

var selected_nodes = []


func _ready():
	graph_edit.get_zoom_hbox().visible = false
	graph_edit.get_child(1).offset = Vector2(1640, 456)
	graph_edit.get_child(2).offset = Vector2(128, 456)
	node_menu.parse_validation_table()
	
func _process(delta):
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
	update_connections()
	get_tree().call_group("node", "execute")
	
func _on_GraphEdit_node_selected(node):
	selected_nodes.append(node)

func _on_GraphEdit_node_unselected(node):
	selected_nodes.erase(node)

func _on_GraphEdit_paste_nodes_request():
	for node in selected_nodes:
		if not node.is_in_group("input") and not node.is_in_group("output"):
			var new_node = node.duplicate()
			graph_edit.add_child(new_node)
			new_node.offset += Vector2(32, 32)
