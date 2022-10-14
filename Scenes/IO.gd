extends GraphNode

onready var toggle = $toggle
onready var freq_timer = $Timer
onready var freq_lbl = $FreqLbl
onready var freq_slider = $Freq

#var self.title
var io_value = 0
var type = "io"

func _ready():
	if self.title == "INPUT":
		set_slot(1, false, 0, Color("6a7285"), true, 0, Color("f74464"))
		
	elif self.title == "PULSE":
		toggle.disabled = true
		set_slot(1, false, 0, Color("6a7285"), true, 0, Color("f74464"))
		freq_slider.editable = true
		freq_lbl.set_text(str(freq_timer.wait_time))
	
	elif self.title == "OUTPUT":
		toggle.disabled = true
		set_slot(1, true, 0, Color("6a7285"), false, 0, Color("f74464"))
	
func _process(delta):
	toggle.set_text(str(io_value))
	if io_value == 1:
		if self.title == "INPUT" or self.title == "PULSE":
			set_slot_color_right(1, Color("f74464"))
			
		elif self.title == "OUTPUT":
			set_slot_color_left(1, Color("f74464"))
			
	elif io_value == 0:
		if self.title == "INPUT" or self.title == "PULSE":
			set_slot_color_right(1, Color("6a7285"))
			
		elif self.title == "OUTPUT":
			set_slot_color_left(1, Color("6a7285"))
	
func _on_IO_close_request():
	self.queue_free()

func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
			
func _on_toggle_toggled(button_pressed):
	if button_pressed == true:
		io_value = 1
	else:
		io_value = 0

func _on_Freq_value_changed(value):
	freq_lbl.set_text(str(value))
	freq_timer.wait_time = value

func _on_Timer_timeout():
	if self.title == "PULSE":
		if io_value == 1:
			io_value = 0
		elif io_value == 0:
			io_value = 1
		
