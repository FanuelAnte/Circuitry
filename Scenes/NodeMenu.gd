extends Control

var gate_scene = preload("res://Scenes/Nodes/Gate.tscn")

var input_scene = preload("res://Scenes/Nodes/Input.tscn")
var output_scene = preload("res://Scenes/Nodes/Output.tscn")
var and_scene = preload("res://Scenes/Nodes/AND.tscn")
var not_scene = preload("res://Scenes/Nodes/NOT.tscn")

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

func add_gate(scene_path):
	var graph = get_parent().get_child(0)
	if node_index > 10:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
#	var node = gate_scene.instance()
	var node = scene_path.instance()
	node.offset += init_pos + (node_index * offset_vector)
	graph.add_child(node)
	node_index += 1

func _on_ANDBtn_pressed():
	add_gate(and_scene)

func _on_NOTBtn_pressed():
	add_gate(not_scene)

func _on_INBtn_pressed():
	add_io("INPUT", input_scene)


func _on_OUTBtn_pressed():
	add_io("OUTPUT", output_scene)


func tween_transparency(val, time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "self_modulate", Color(1, 1, 1, val), time)

	
func _on_Panel_mouse_entered():
	tween_transparency(1, 0.2)


func _on_Panel_mouse_exited():
	tween_transparency(0.2, 0.2)


func _on_ExitBtn_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	

