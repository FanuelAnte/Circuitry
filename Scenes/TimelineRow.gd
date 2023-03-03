extends HBoxContainer

var switch_scene = load("res://Scenes/TimelineCheck.tscn")
var switches = 1

func _ready():
	pass
#	create_switches(3)
#	yield(get_tree().create_timer(1), "timeout")
#	create_switches(2)

func name_row(name):
	$Name.set_text(name) 

func create_switches(amount):
	for child in self.get_children():
		if child.is_in_group("timeline_switch"):
			child.queue_free()
			
	for x in range(amount):
		self.add_child(switch_scene.instance())
