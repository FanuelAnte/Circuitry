extends GraphNode

onready var gate_name = $"%GateName"

var io_value = 0
var type = "gate"
var input_values = [0, 0]
var gate_types = ["AND", "OR", "NAND", "NOR", "XOR", "XNOR"]
var gate_title = ""

func _ready():
	self.title = gate_title
	gate_name.text = gate_title
	
	if gate_title == "NOT":
		set_slot_enabled_left(0, false)
		set_slot_enabled_right(0, false)
		
		set_slot_enabled_left(1, true)
		set_slot_enabled_right(1, true)
		
		set_slot_enabled_left(2, false)
		set_slot_enabled_right(2, false)
		
func _process(delta):
	if io_value == 1:
		set_slot_color_right(1, Color("9cd6d9"))
	
	elif io_value == 0:
		set_slot_color_right(1, Color("4b626e"))
		
	if gate_title == "NOT":
		if input_values[0] == 1:
			set_slot_color_left(1, Color("9cd6d9"))
		elif input_values[0] == 0:
			set_slot_color_left(1, Color("4b626e"))
			
	elif gate_title in gate_types:
		if input_values[0] == 1:
			set_slot_color_left(0, Color("9cd6d9"))
		elif input_values[0] == 0:
			set_slot_color_left(0, Color("4b626e"))
		
		if input_values[1] == 1:
			set_slot_color_left(2, Color("9cd6d9"))
		elif input_values[1] == 0:
			set_slot_color_left(2, Color("4b626e"))

func _on_Gate_close_request():
	self.queue_free()
	
func get_input_values():
	input_values = [0, 0]
	for conn in Globals.connections:
		if conn["to"] == self.name:
			input_values[conn["to_port"]] = conn["data"]
			
func execute():
	get_input_values()
	if gate_title != "NOT":
		if gate_title == "AND":
			if input_values[0] and input_values[1]:
				io_value = 1
			else:
				io_value = 0
				
		elif gate_title == "OR":
			if input_values[0] or input_values[1]:
				io_value = 1
			else:
				io_value = 0
				
		elif gate_title == "NAND":
			if input_values[0] and input_values[1]:
				io_value = 0
			else:
				io_value = 1

		elif gate_title == "NOR":
			if input_values[0] or input_values[1]:
				io_value = 0
			else:
				io_value = 1
		
		elif gate_title == "XOR":
			if input_values[0] == input_values[1]:
				io_value = 0
			else:
				io_value = 1
			
		elif gate_title == "XNOR":
			if input_values[0] == input_values[1]:
				io_value = 1
			else:
				io_value = 0
		
	elif gate_title == "NOT":
		if input_values[0] == 1:
			io_value = 0
		else:
			io_value = 1
	else:
		io_value = 0
