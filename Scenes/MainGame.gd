extends Control

onready var graph = $GraphEdit

onready var left_tween = $Left/TweenLeft
onready var left_drawer = $Left
onready var left_drawer_btn = $Left/LeftDrawer

onready var right_tween = $Right/TweenRight
onready var right_drawer = $Right
onready var right_drawer_btn = $Right/RightDrawer

var gate_scene = load("res://Scenes/Gate.tscn")
var io_scene = load("res://Scenes/IO.tscn")

var input_scene = load("res://Scenes/IO/Input.tscn")
var output_scene = load("res://Scenes/IO/Output.tscn")
var pulse_scene = load("res://Scenes/IO/Pulse.tscn")
var oscillator_scene = load("res://Scenes/IO/Oscillator.tscn")

var offset_vector = Vector2(32, 32)
var init_pos = Vector2(512, 128)
var node_index = 0

var input_index = 1

var left_drawer_out = false
var right_drawer_out = false


func _ready():
	pass
	
func add_gate(gate_type):
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = gate_scene.instance()
	node.offset += init_pos + (node_index * offset_vector)
	node.title = gate_type
	graph.add_child(node)
	node_index += 1
	
func add_io(io_type, scene_path):
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = scene_path.instance()
	node.offset += init_pos + (node_index * offset_vector)
	graph.add_child(node)
	if io_type == "INPUT":
		node.title = io_type + " " + str(input_index)
	input_index += 1
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
	add_io("INPUT", input_scene)

func _on_OUT_pressed():
	add_io("OUTPUT", output_scene)

func _on_PULSE_pressed():
	add_io("PULSE", pulse_scene)

func _on_OSC_pressed():
	add_io("OSCILLATOR", oscillator_scene)

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

func run():
	update_connections()
	get_tree().call_group("nodes", "execute")

func _on_Timer_timeout():
	run()

func _on_MenuBtn_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func left_drawer_tween():
	if left_drawer_out:
		left_tween.interpolate_property(left_drawer, "rect_position", Vector2(48, 96), Vector2(-240, 96), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		left_drawer_out = false
		left_drawer_btn.flip_h = false
	else:
		left_tween.interpolate_property(left_drawer, "rect_position", Vector2(-240, 96), Vector2(48, 96), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		left_drawer_out = true
		left_drawer_btn.flip_h = true
	left_tween.start()

func right_drawer_tween():
	if right_drawer_out:
		right_tween.interpolate_property(right_drawer, "rect_position", Vector2(1424, 48), Vector2(1920, 48), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		right_drawer_out = false
		right_drawer_btn.flip_h = true
	else:
		right_tween.interpolate_property(right_drawer, "rect_position", Vector2(1920, 48), Vector2(1424, 48), 0.1, Tween.TRANS_SINE, Tween.EASE_IN)
		right_drawer_out = true
		right_drawer_btn.flip_h = false
	right_tween.start()


func _on_LeftDrawer_pressed():
	left_drawer_tween()

func _on_RightDrawer_pressed():
	right_drawer_tween()


