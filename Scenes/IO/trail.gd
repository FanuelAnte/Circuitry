extends Line2D

var point
var start_suicide = false

func _ready():
	set_as_toplevel(true)

func _process(delta):
	point = get_parent().global_position
	if !start_suicide:
		add_point(point)
	
	if points.size() > Globals.trail_length or start_suicide:
		remove_point(0)
		
	if points.size() == 0:
		self.queue_free()
