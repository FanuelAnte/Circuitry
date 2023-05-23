extends Control

var and_scene = preload("res://Scenes/Nodes/AND.tscn")
var not_scene = preload("res://Scenes/Nodes/NOT.tscn")

onready var input_table_panel = $InputTablePanel
onready var validation_table_panel = $ValidationTablePanel
onready var panel = $Panel
onready var input_text_edit = $InputTablePanel/InputTextEdit
onready var validation_text_edit = $ValidationTablePanel/ValidationTextEdit
onready var graph_edit = get_parent().get_child(0)
onready var state_lbl = $ValidationTablePanel/Panel/StateLbl

var offset_vector = Vector2(32, 32)
var init_pos = Vector2(990, 540)
var node_index = 0

func _ready():
	pass

func _process(delta):
	pass
	
func add_gate(scene_path):
	var graph = get_parent().get_child(0)
	if node_index > 5:
		node_index = 0
		init_pos = init_pos + Vector2(0, 64)
	var node = scene_path.instance()
	node.offset += init_pos + (node_index * offset_vector)
	graph.add_child(node)
	node_index += 1

func parse_validation_table():
	var table = Globals.current_problem["validation_table"]
	var inputs = table[0]
	var outputs = table[1]
	
	validation_text_edit.text = ""
	
	for i in range(inputs.size()):
		validation_text_edit.cursor_set_line(i)
		validation_text_edit.cursor_set_column(0)
		validation_text_edit.insert_text_at_cursor(inputs[i] + ":" + outputs[i] + ',\n')
	
func _on_ANDBtn_pressed():
	add_gate(and_scene)

func _on_NOTBtn_pressed():
	add_gate(not_scene)

func tween_transparency(val, time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1, 1, 1, val), time)
	
func tween_position(time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rect_position", Vector2(-576, 0), time)
	
func _on_Panel_mouse_entered():
#	tween_transparency(1, 0.2)
	pass

func _on_Panel_mouse_exited():
#	tween_transparency(0.2, 0.2)
	pass

func _on_ExitBtn_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	
func _on_InputBtn_pressed():
	input_table_panel.show()

func _on_ValidationBtn_pressed():
	validation_table_panel.show()

func _on_InCloseBtn_pressed():
	input_table_panel.hide()
	
func _on_VCloseBtn_pressed():
	validation_table_panel.hide()

func _on_CloseBtn_pressed():
	tween_position(0.5)
	
func parse_table(inputs, outputs):
	var input_array = []
	var output_array = []
	for i in inputs:
		input_array.append([int(i[0]), int(i[1])])
	
	for i in outputs:
		output_array.append([int(i[0])])
	
	return [input_array, output_array]

func _on_VCheckBtn_pressed():
	var table = Globals.current_problem["validation_table"]
	var inputs = table[0]
	var outputs = table[1]
	
	var parsed_table = parse_table(inputs, outputs)
	
	var input_node
	var output_node
	
	var valid = true
	
	for node in graph_edit.get_children():
		if node.is_in_group("input"):
			input_node = node
		elif node.is_in_group("output"):
			output_node = node
	
	state_lbl.add_color_override("font_color", Color(Globals.line_colors["inactive"]))
	state_lbl.text = "Checking..."
	
	for i in range(parsed_table[0].size()):
		input_node.io_values = parsed_table[0][i]
		yield(get_tree().create_timer(0.5), "timeout")
		if output_node.io_values[0] != parsed_table[1][i][0]:
			valid = false
			break
#		yield(get_tree().create_timer(0.5), "timeout")
	
	if valid:
		state_lbl.add_color_override("font_color", Color(Globals.line_colors["active"]))
		state_lbl.text = "Correct!"
	elif !valid:
		state_lbl.add_color_override("font_color", Color(Globals.line_colors["inactive"]))		
		state_lbl.text = "Incorrect."

