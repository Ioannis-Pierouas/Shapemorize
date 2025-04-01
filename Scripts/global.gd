extends Node

#Sound
var muted : bool = false
#Levels
var current_level : int = 1
var highscore : int = 0  # Keeps track of the highest level ever reached
#Sequences
var sequence_names : Array = []
var player_sequence : Array = []  # The player's sequence input
#Game checks
signal player_turn_active
signal player_turn_inactive
signal game_lost
var player_turn : bool = false
var defeat : bool = false  # Defeat state
#Level data
var level_data = generate_level_data()
#{
#	1: { "category": 0, "display_time": 2.0, "sequence_length": 3, "sequence_time": 15 },
#	2: { "category": 1, "display_time": 2.0, "sequence_length": 4, "sequence_time": 15 },
#	3: { "category": 2, "display_time": 1.9, "sequence_length": 5, "sequence_time": 14 },
#	4: { "category": 3, "display_time": 1.9, "sequence_length": 6, "sequence_time": 14 },
#	5: { "category": 4, "display_time": 1.7, "sequence_length": 7, "sequence_time": 12 },
#}

func get_level_data(level: int) -> Dictionary:
	return level_data.get(level, { "category": 4, "display_time": 1.0, "sequence_length": 10, "sequence_time": 30 })

func compare_sequence():	#compare sequences, increase level, update highscore, reset checks
	if player_sequence.size() == sequence_names.size():
		print("Your Sequence: ", player_sequence)
		player_turn = false  # End player's turn
		if player_sequence == sequence_names:
			player_sequence.clear()  # Clear player's sequence input for next round
			next_level()
			player_turn_inactive.emit()
		else:
			lost_game()

func new_game():
	current_level = 1
	sequence_names.clear()
	player_sequence.clear()
	player_turn = false
	defeat = false

func next_level():
	print("next Level")
	if current_level > highscore:	# Update Highscore
		highscore = current_level
	current_level += 1  # Level up

func lost_game():
	player_sequence.clear()
	defeat = true  # Activate defeat
	player_turn = false  # End player's turn
	game_lost.emit()

func generate_level_data():
	var data = {}
	var display_time = 2.0
	var sequence_time = 15
	var sequence_length = 3
	var max_sequence_length = 12
	var min_display_time = 0.8
	var min_sequence_time = 7

	for level in range(1, 101):
		var category = (level - 1) / 20  # Changes category every 20 levels
		
		# Gradually decrease display_time within limits
		if display_time > min_display_time:
			display_time -= 0.05  # Decrease display time slightly
		
		# Gradually decrease sequence_time as an integer
		if sequence_time > min_sequence_time and level % 2 == 0:
			sequence_time -= 1  # Decrease sequence time every 2 levels

		# Increase sequence length if possible
		if sequence_length < max_sequence_length and level % 3 == 0:
			sequence_length += 1  # Increase sequence length every 3 levels

		# Special rule for level 100
		if level == 100:
			display_time = 0.6
			sequence_time = 6
			sequence_length = 15

		data[level] = {
			"category": category,
			"display_time": max(display_time, min_display_time),
			"sequence_length": min(sequence_length, max_sequence_length),
			"sequence_time": max(sequence_time, min_sequence_time),  # Ensure it's an integer
		}
	
	return data

var shapes = [
	preload("res://Assets/SequenceShapes/BlueSquare.png"),
	preload("res://Assets/SequenceShapes/BlueTxt.png"),
	preload("res://Assets/SequenceShapes/Circle.png"),
	preload("res://Assets/SequenceShapes/CircleTxt.png"),
	preload("res://Assets/SequenceShapes/GreenRhombus.png"),
	preload("res://Assets/SequenceShapes/GreenTxt.png"),
	preload("res://Assets/SequenceShapes/Hexagon.png"),
	preload("res://Assets/SequenceShapes/HexagonTxt.png"),
	preload("res://Assets/SequenceShapes/OrangePentagon.png"),
	preload("res://Assets/SequenceShapes/OrangeTxt.png"),
	preload("res://Assets/SequenceShapes/Pentagon.png"),
	preload("res://Assets/SequenceShapes/PentagonTxt.png"),
	preload("res://Assets/SequenceShapes/PurpleHexagon.png"),
	preload("res://Assets/SequenceShapes/PurpleTxt.png"),
	preload("res://Assets/SequenceShapes/RedCircle.png"),
	preload("res://Assets/SequenceShapes/RedTxt.png"),
	preload("res://Assets/SequenceShapes/Rhombus.png"),
	preload("res://Assets/SequenceShapes/RhombusTxt.png"),
	preload("res://Assets/SequenceShapes/Square.png"),
	preload("res://Assets/SequenceShapes/SquareTxt.png"),
	preload("res://Assets/SequenceShapes/Triangle.png"),
	preload("res://Assets/SequenceShapes/TriangleTxt.png"),
	preload("res://Assets/SequenceShapes/YellowTriangle.png"),
	preload("res://Assets/SequenceShapes/YellowTxt.png")
]
