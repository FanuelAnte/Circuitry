extends Control

var and_scene = preload("res://Scenes/Nodes/AND.tscn")
var not_scene = preload("res://Scenes/Nodes/NOT.tscn")
var generic_scene = preload("res://Scenes/Nodes/Generic.tscn")

onready var input_table_panel = $InputTablePanel
onready var validation_table_panel = $ValidationTablePanel
onready var panel = $Panel
onready var input_text_edit = $InputTablePanel/InputTextEdit
onready var validation_text_edit = $ValidationTablePanel/ValidationTextEdit
onready var graph_edit = get_parent().get_child(0)
onready var position_node = get_parent().get_child(3)
onready var state_lbl = $ValidationTablePanel/Panel/StateLbl
onready var comps_cont = $CompsPanel/CompsCont
onready var comps_panel = $CompsPanel

var added_node

func _ready():
	pass

func _process(delta):
	pass

func get_mouse_on_graph_position():
	var canvas_transform = graph_edit.get_canvas_transform()
	var graph_pos = canvas_transform.affine_inverse().xform(get_global_mouse_position())
	
	return graph_pos
	
func add_gate(scene_path):
	added_node = scene_path.instance()
	added_node.graph_edit = graph_edit
	graph_edit.add_child(added_node)
		
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
	pass

func _on_NOTBtn_pressed():
	pass

func tween_transparency(val, time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color(1, 1, 1, val), time)
	
func tween_position(time):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rect_position", Vector2(-576, 0), time)
	
func _on_Panel_mouse_entered():
	pass

func _on_Panel_mouse_exited():
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

func modulate_menu(alpha):
	var mod_tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	mod_tween.tween_property(self, "modulate", Color(1, 1, 1, alpha), 0.5)

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
	
	if valid:
		state_lbl.add_color_override("font_color", Color(Globals.line_colors["active"]))
		state_lbl.text = "Correct!"
		Globals.problem_progress[Globals.current_problem["id"]] = "complete"
		Globals.save()
	elif !valid:
		state_lbl.add_color_override("font_color", Color(Globals.line_colors["inactive"]))
		state_lbl.text = "Incorrect."

func _on_ANDBtn_button_down():
	modulate_menu(0.5)
	add_gate(and_scene)

func _on_ANDBtn_button_up():
	modulate_menu(1)
	added_node.is_being_dragged = false

func _on_NOTBtn_button_down():
	modulate_menu(0.5)
	add_gate(not_scene)

func _on_NOTBtn_button_up():
	modulate_menu(1)
	added_node.is_being_dragged = false

func _on_GenericBtn_button_down():
	for i in comps_cont.get_children():
		i.queue_free()
		
	modulate_menu(0.5)
	
	var files = get_component_files("user://", ".comp")
	comps_panel.show()
	
	for file in files:
		create_button(file)
	
	add_gate(generic_scene)

func get_component_files(path, ext):
	var dir = Directory.new()
	var files = []
	
	var final_file_names = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file == "":
				break
			if dir.current_is_dir():
				continue
			if file.ends_with(ext):
				files.append(file)
		dir.list_dir_end()
	for file in files:
		final_file_names.append(file.split(".")[0])
		
	return final_file_names
	
func create_button(text):
	var button = Button.new()
	button.text = text
	button.rect_min_size = Vector2(90, 25)
	comps_cont.add_child(button)

	button.connect("pressed", self, "on_button_pressed", [text])

func on_button_pressed(text):
	added_node.node_type = text
	comps_panel.hide()
	added_node.create_graph(text)

func _on_GenericBtn_button_up():
	modulate_menu(1)
	added_node.is_being_dragged = false
	
func save_component(comp_name, nodes, connections):
	var file = File.new()
	file.open("user://" + str(comp_name) + ".comp", File.WRITE)
	var save_data = {"nodes" : nodes, "connections" : connections}
	file.store_line(to_json(save_data))
	file.close()

func _on_SaveCompBtn_pressed():
	save_component(Globals.current_problem["name"], get_parent().nodes_in_graph, get_parent().get_child(0).get_connection_list())

