extends Control

onready var graph = $GraphEdit
onready var tween = $Left/Tween
onready var left_drawer = $Left
onready var drawer_btn = $Left/Drawer

var gate_scene = load("res://Scenes/Gate.tscn")
var io_scene = load("res://Scenes/IO.tscn")
var offset_vector = Vector2(32, 32)
var init_pos = Vector2(512, 128)
var node_index = 0
var left_drawer_out = false

func _ready():
	pass
	
func add_node(name, type):
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node
	if type == "IO":
		node = io_scene.instance()
#		node.io_type = name
	elif type == "Gate":
		node = gate_scene.instance()
	node.offset += init_pos + (node_index * offset_vector)
	node.title = name
	graph.add_child(node)
	node_index += 1
	
func _on_AND_pressed():
	add_node("AND", "Gate")

func _on_OR_pressed():
	add_node("OR", "Gate")

func _on_NAND_pressed():
	add_node("NAND", "Gate")

func _on_NOR_pressed():
	add_node("NOR", "Gate")

func _on_XOR_pressed():
	add_node("XOR", "Gate")

func _on_XNOR_pressed():
	add_node("XNOR", "Gate")

func _on_NOT_pressed():
	add_node("NOT", "Gate")

func _on_IN_pressed():
	add_node("INPUT", "IO")

func _on_OUT_pressed():
	add_node("OUTPUT", "IO")

func _on_PULSE_pressed():
	add_node("PULSE", "IO")

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

func drawer_tween():
	if left_drawer_out:
		tween.interpolate_property(left_drawer, "rect_position", Vector2(48, 96), Vector2(-240, 96), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		left_drawer_out = false
		drawer_btn.flip_h = false
	else:
		tween.interpolate_property(left_drawer, "rect_position", Vector2(-240, 96), Vector2(48, 96), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		left_drawer_out = true
		drawer_btn.flip_h = true
	tween.start()

func _on_Drawer_pressed():
	drawer_tween()
