extends Control

onready var name_label = $MarginContainer/VBoxContainer/Label
onready var description_label = $MarginContainer/VBoxContainer/Label2
onready var panel = $Panel
onready var progress_label = $MarginContainer/VBoxContainer/progress

var prob_id

func _ready():
	pass

func init_problem(problem_id, problem_name, problem_description, progress):
	prob_id = problem_id
	name_label.text = problem_name
	description_label.text = problem_description
	progress_label.text = progress

func _on_EditBtn_pressed():
	for prob in Globals.problem_list:
		if prob["id"] == prob_id:
			Globals.current_problem = prob
	
	get_tree().change_scene("res://Scenes/MainGame.tscn")
