extends Node

var connections = []

var line_colors = {"active" : "7dd4cc", "inactive" : "3c5a5e"}

var problem_list = [
#	{"id": "0",
#	"name": "AND",
#	"description": "Basic.",
#	"validation_table": [["11","10","01","00"],["1","0","0","0"]],
#	},
	{"id": "1",
	"name": "NAND",
	"description": "Combine.",
	"validation_table": [["11","10","01","00"],["0","1","1","1"]],
	},
	{"id": "2",
	"name": "OR",
	"description": "Combine some more.",
	"validation_table": [["11","10","01","00"],["1","1","1","0"]],
	},
	{"id": "3",
	"name": "NOR",
	"description": "Not!!!",
	"validation_table": [["11","10","01","00"],["0","0","0","1"]],
	},
	{"id": "4",
	"name": "XOR",
	"description": "Exclusive.",
	"validation_table": [["11","10","01","00"],["0","1","1","0"]],
	},
	{"id": "5",
	"name": "XNOR",
	"description": "Not Exclusive.",
	"validation_table": [["11","10","01","00"],["1","0","0","1"]],
	},
]

var problem_progress = {
#	"0" : "incomplete",
	"1" : "incomplete",
	"2" : "incomplete",
	"3" : "incomplete",
	"4" : "incomplete",
	"5" : "incomplete",
	"6" : "incomplete",
	}

var current_problem = {}

func _ready():
	load_progress()
	
func save():
	var file = File.new()
	file.open("user://problems.save", File.WRITE)
	file.store_line(to_json(problem_progress))
	file.close()

func load_progress():
	var file = File.new()
	if file.file_exists("user://problems.save"):
		file.open("user://problems.save", File.READ)
		problem_progress = parse_json(file.get_line())
		file.close()
