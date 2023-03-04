extends Control

var gate_scene = preload("res://Scenes/Nodes/Gate.tscn")
var input_scene = preload("res://Scenes/Nodes/Input.tscn")
var output_scene = preload("res://Scenes/Nodes/Output.tscn")

onready var panel = $Panel

var offset_vector = Vector2(32, 32)
var init_pos = Vector2(512, 128)
var node_index = 0

func _ready():
	pass

func _process(delta):
	pass
	
func add_io(io_type, scene_path):
	var graph = get_parent().get_child(0)
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = scene_path.instance()
	node.offset += init_pos + (node_index * offset_vector)
	graph.add_child(node)
	node_index += 1

func add_gate(gate_type):
	var graph = get_parent().get_child(0)
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = gate_scene.instance()
	node.gate_title = gate_type
	node.offset += init_pos + (node_index * offset_vector)
	graph.add_child(node)
	node_index += 1

func _on_ANDBtn_pressed():
	add_gate("AND")


func _on_ORBtn_pressed():
	add_gate("OR")


func _on_NANDBtn_pressed():
	add_gate("NAND")


func _on_NORBtn_pressed():
	add_gate("NOR")


func _on_XORBtn_pressed():
	add_gate("XOR")


func _on_XNORBtn_pressed():
	add_gate("XNOR")


func _on_NOTBtn_pressed():
	add_gate("NOT")


func _on_INBtn_pressed():
	add_io("INPUT", input_scene)


func _on_OUTBtn_pressed():
	add_io("OUTPUT", output_scene)


func tween_transparency(val, time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "self_modulate", Color(1, 1, 1, val), time)

	
func _on_Panel_mouse_entered():
	tween_transparency(1, 0.5)


func _on_Panel_mouse_exited():
	tween_transparency(0.1, 1)
