extends GraphNode

onready var toggle = $Toggle
onready var freq_timer = $Timer
onready var freq_lbl = $FreqLbl
onready var freq_slider = $Freq

var io_value = 0

func _ready():
	pass
	
func _process(delta):
	if io_value == 1:
		set_slot_color_right(1, Color("f74464"))
		
	elif io_value == 0:
		set_slot_color_right(1, Color("6a7285"))

func execute():
	for conn in Globals.connections:
		if conn["to"] == self.name:
			io_value = conn["data"]
			
func _on_Timer_timeout():
	if toggle.pressed:
		if io_value == 1:
			io_value = 0
		elif io_value == 0:
			io_value = 1

func _on_Toggle_toggled(button_pressed):
	if button_pressed == true:
		toggle.set_text(str(1))
	else:
		toggle.set_text(str(0))
		
func _on_Freq_value_changed(value):
	freq_lbl.set_text(str(value))
	freq_timer.wait_time = value
	
func _on_Pulse_close_request():
	self.queue_free()
