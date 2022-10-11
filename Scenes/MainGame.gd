extends Control

onready var graph = $GraphEdit

var gate_scene = load("res://Scenes/Gate.tscn")
var io_scene = load("res://Scenes/IO.tscn")
var offset_vector = Vector2(32, 32)
var init_pos = Vector2(64, 64)
var node_index = 0

func _ready():
	pass
	
func add_io(name):
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = io_scene.instance()
	node.offset += init_pos + (node_index * offset_vector)
	node.title = name
	node.io_type = name
	graph.add_child(node)
	node_index += 1
	
func add_gate(name):
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = gate_scene.instance()
	node.offset += init_pos + (node_index * offset_vector)
	node.title = name
	graph.add_child(node)
	node.set_icon(name)
	node_index += 1

func _on_AND_pressed():
	add_gate("AND")

func _on_OR_pressed():
	add_gate("OR")

func _on_NAND_pressed():
	add_gate("NAND")

func _on_NOR_pressed():
	add_gate("NOR")

func _on_XOR_pressed():
	add_gate("XOR")

func _on_XNOR_pressed():
	add_gate("XNOR")

func _on_NOT_pressed():
	add_gate("NOT")

func _on_IN_pressed():
	add_io("INPUT")

func _on_OUT_pressed():
	add_io("OUTPUT")

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	for con in graph.get_connection_list():
		if con.to == to and con.to_port == to_slot:
			return
	graph.connect_node(from, from_slot, to, to_slot)
	run()
	
func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graph.disconnect_node(from, from_slot, to, to_slot)
	run()

func update_connections():
	var connections = graph.get_connection_list()
	for i in connections:
		var node = graph.get_node(i.from)
		if is_instance_valid(node):
			i["data"] = node.io_value
		else:
			i["data"] = 0
		
	Globals.connections = connections
#	print(connections)

func run():
	update_connections()
	get_tree().call_group("nodes", "execute")

func _on_RUN_pressed():
	run()

func _on_Timer_timeout():
	run()

func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
