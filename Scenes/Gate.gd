extends GraphNode

onready var icon = $Texture

var path = "res://Assets/Images/GraphNode/Icons/"
var io_value = 0
var type = "gate"
var input_values = [] 
var gate_types = ["AND", "OR", "NAND", "NOR", "XOR", "XNOR"]

func _ready():
	if title == "NOT":
		set_slot(1, false, 0, Color("6a7285"), false, 0, Color("6a7285"))
		set_slot(2, true, 0, Color("6a7285"), true, 0, Color("f74464"))
		set_slot(3, false, 0, Color("6a7285"), false, 0, Color("6a7285"))

func _process(delta):
	if io_value == 1:
		set_slot_color_right(2, Color("f74464"))
	
	elif io_value == 0:
		set_slot_color_right(2, Color("6a7285"))

	if input_values != []:
		if title == "NOT":
			if input_values[0] == 1:
				set_slot_color_left(2, Color("f74464"))
			elif input_values[0] == 0:
				set_slot_color_left(2, Color("6a7285"))

		elif title in gate_types:
			if input_values[0] == 1:
				set_slot_color_left(1, Color("f74464"))
			elif input_values[0] == 0:
				set_slot_color_left(1, Color("6a7285"))
			
			if input_values.size() == 2:
				if input_values[1] == 1:
					set_slot_color_left(3, Color("f74464"))
				elif input_values[1] == 0:
					set_slot_color_left(3, Color("6a7285"))
				
	else:
		set_slot_color_left(2, Color("6a7285"))
		set_slot_color_left(1, Color("6a7285"))
		set_slot_color_left(3, Color("6a7285"))
				
func set_icon(name):
	icon.set_texture(load(path + name + ".png"))
	
func _on_Gate_close_request():
	self.queue_free()

func _on_Gate_resize_request(new_minsize):
	self.rect_size = new_minsize
	
func get_input_values():
	input_values = []
	for conn in Globals.connections:
		if conn["to"] == self.name:
			input_values.append(conn["data"])

func execute():
	get_input_values()
	if input_values.size() == 2 and title != "NOT":
		if title == "AND":
			if input_values[0] and input_values[1]:
				io_value = 1
			else:
				io_value = 0
				
		elif title == "OR":
			if input_values[0] or input_values[1]:
				io_value = 1
			else:
				io_value = 0
				
		elif title == "NAND":
			if input_values[0] and input_values[1]:
				io_value = 0
			else:
				io_value = 1

		elif title == "NOR":
			if input_values[0] or input_values[1]:
				io_value = 0
			else:
				io_value = 1
		
		elif title == "XOR":
			if input_values[0] == input_values[1]:
				io_value = 0
			else:
				io_value = 1
			
		elif title == "XNOR":
			if input_values[0] == input_values[1]:
				io_value = 1
			else:
				io_value = 0
		
	elif input_values.size() == 1 and title == "NOT":
		if input_values[0] == 1:
			io_value = 0
		else:
			io_value = 1
	else:
		io_value = 0
