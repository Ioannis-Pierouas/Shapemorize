extends Control

const MASTER_BUS = 0
const MUSIC_BUS = 1
const SFX_BUS = 2

@onready var pause_menu = $MarginContainer/PauseMenu
@onready var shape_display = $MarginContainer/VBoxContainer/Whiteboard/ShapeDisplay

@onready var music_player = $MusicPlayer
@onready var click_player = $ClickSoundPlayer
@onready var win_player = $WinSoundPlayer
@onready var lose_player = $LoseSoundPlayer
@onready var mute_button = $MarginContainer/PauseMenu/PauseMenu/MuteButton
# Timers
@onready var timer = $GameTimer
@onready var label_timer = $LabelTimer
@onready var countdown_timer = $CountdownTimer
# Labels
@onready var time_label = $MarginContainer/VBoxContainer/TopPanel/TimerLabel
@onready var level_label = $MarginContainer/VBoxContainer/TopPanel/LevelLabel
@onready var countdown_label = $MarginContainer/VBoxContainer/Whiteboard/CountdownLabel


signal countdown_finished  # for the 3 2 1 Go!
signal timer_finished # for the game timer
signal label_countdown_finished # for updating the timer label

func _ready():
	print("Transition to Game Screen")
	Global.player_turn_active.connect(time_label_func)
	Global.player_turn_inactive.connect(next_level)
	Global.game_lost.connect(handle_defeat)
	#load_shapes()
	retrieve_level()
	start_sequence()
	handle_pause_menu()
	_update_level_label()
	handle_loss_from_time()

func _update_level_label():
	level_label.text = "Level " + str(Global.current_level)

func next_level():
	retrieve_level()
	start_sequence()
	win_player.play()
	timer.stop()
	label_timer.stop()
	time_label.text = "-"
	await get_tree().create_timer(1).timeout
	await _update_level_label()

func handle_loss_from_time():
	await timer_finished
	Global.lost_game()

func handle_defeat():
	lose_player.play()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Pause Menu

func handle_pause_menu():
	pause_menu.hide()
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	click_player.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pause_button_pressed():
	get_tree().paused = true
	pause_menu.show()
	timer.paused = true

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.hide()

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS, value)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS, value)

func _on_mute_button_pressed():
	print("mute button pressed")
	click_player.play()
	Global.muted = !Global.muted
	if Global.muted:
		AudioServer.set_bus_mute(MASTER_BUS, true)
		AudioServer.set_bus_mute(MUSIC_BUS, true)
		AudioServer.set_bus_mute(SFX_BUS, true)
		mute_button.text = "Unmute"
	else:
		AudioServer.set_bus_mute(MASTER_BUS, false)
		AudioServer.set_bus_mute(MUSIC_BUS, false)
		AudioServer.set_bus_mute(SFX_BUS, false)
		mute_button.text = "Mute"

func _on_main_menu_button_pressed():
	print("Back to main menu button pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Timer Functions

func time_label_func():
	start_game_timer(Global.get_level_data(Global.current_level).sequence_time)
	var sequence_time_display = Global.get_level_data(Global.current_level).sequence_time
	for i in range(sequence_time_display):
		time_label.text = str(sequence_time_display - i)
		start_countdown_label(1)
		await label_countdown_finished
	time_label.text = "0"

func start_game_timer(duration: float):
	timer.wait_time = duration
	timer.start()

func _on_game_timer_timeout():
	timer_finished.emit()

func start_countdown_label(duration: float):
	label_timer.wait_time = duration
	label_timer.start()

func _on_label_timer_timeout():
	label_countdown_finished.emit()

func start_countdown(duration: float):
	countdown_timer.wait_time = duration
	countdown_timer.start()

func _on_countdown_timer_timeout():
	countdown_finished.emit()

# Shape Press Handling

func _on_square_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Square")
		Global.compare_sequence()

func _on_circle_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Circle")
		Global.compare_sequence()

func _on_triangle_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Triangle")
		Global.compare_sequence()

func _on_rhombus_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Rhombus")
		Global.compare_sequence()

func _on_pentagon_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Pentagon")
		Global.compare_sequence()

func _on_hexagon_pressed():
	click_player.play()
	if Global.player_turn:
		Global.player_sequence.append("Hexagon")
		Global.compare_sequence()

var colored_shapes = []
var shapes = []
var shape_names = []
var color_names = []
var all_shapes = []  # 5th category (includes everything)
var shape_name_mapping = {}  # Mapping texture to its shape name

var color_list = ["Blue", "Red", "Green", "Yellow", "Purple", "Orange"]

var sequence = []  # Holds the generated sequence for the level
var display_time : float
var sequence_length : int
var selected_category : int
var sequence_time : float

# Whiteboard Functions: Initialization
func load_shapes():	# Loads shape images from the directory and stores them in the 5 arrays
	var dir = "res://Assets/SequenceShapes/"
	var files = DirAccess.get_files_at(dir)
	
	if !files.is_empty():
		for file in files:
			if file.ends_with(".png"):  # Only load image files
				var texture = ResourceLoader.load(dir + file)
				var file_name = file.replace(".png", "")
				
				# Create the mapping between texture and shape name
				shape_name_mapping[texture] = file_name

				if "Txt" in file_name:
					if color_list.any(func(color): return file_name.begins_with(color)):
						color_names.append(texture)
					else:
						shape_names.append(texture)
				elif color_list.any(func(color): return file_name.begins_with(color)):
					colored_shapes.append(texture)
				else:
					shapes.append(texture)

	all_shapes = colored_shapes + shapes + shape_names + color_names

	print("colored_shapes = ", colored_shapes)
	print("shapes = ", shapes)
	print("shape_names = ", shape_names)
	print("color_names = ", color_names)

func retrieve_level(): # From the Global script
	# Retrieve level data from the Global script
	var level_info = Global.get_level_data(Global.current_level)
	selected_category = level_info.category
	display_time = level_info.display_time
	sequence_length = level_info.sequence_length
	sequence_time = level_info.sequence_time
	
	print("Level ", Global.current_level, ": Category = ", selected_category, ", Display Time = ", display_time, "s, Sequence Length = ", sequence_length, ", Total Time = ", sequence_time)
	generate_sequence()

const SHAPES = ["Square", "Circle", "Triangle", "Rhombus", "Pentagon", "Hexagon"]

func generate_sequence(): # Generate and pass the sequence to Global script
	sequence.clear()
	var last_shape = ""
	
	for i in range(sequence_length):
		var new_shape : String
		while true:
			new_shape = SHAPES[randi() % 6]
			if new_shape != last_shape:
				break  # Ensure no consecutive duplicates
		sequence.append(new_shape)
		last_shape = new_shape
	
	Global.sequence_names = sequence  # Store it in the global script
	print("Generated Sequence Names: ", sequence)

func countdown(): # display the initial 3 2 1 Go!
	# Show 3...2...1...Go!
	for text in ["3", "2", "1", "Go!"]:
		countdown_label.text = text
		countdown_label.show()
		start_countdown(0.8)
		await countdown_finished
		countdown_label.hide()

func display_sequence():
	for shape in sequence:
		print(shape)
		shape_display.show_category(selected_category+1)
		shape_display.show_shape(selected_category+1, shape)
		start_countdown(display_time)
		await countdown_finished
	shape_display.show_category(0)

func start_sequence():
	# Run countdown, then run display sequence and then show "Your Turn!"
	await countdown()
	await display_sequence()
	# After sequence is over, show "Your Turn!"
	countdown_label.text = "Your Turn!"
	
	countdown_label.show()
	start_countdown(1)
	await countdown_finished
	countdown_label.hide()
	
	Global.player_turn = true
	Global.player_turn_active.emit()

# Functions who help to generate Sequence

func get_random_texture(category):
	match category:
		0: return colored_shapes[randi() % colored_shapes.size()] if colored_shapes else null
		1: return shapes[randi() % shapes.size()] if shapes else null
		2: return shape_names[randi() % shape_names.size()] if shape_names else null
		3: return color_names[randi() % color_names.size()] if color_names else null
		4: return all_shapes[randi() % all_shapes.size()] if all_shapes else null
	return null

# Function to convert full name into just the shape name
func convert_to_shape_name(full_name: String) -> String:
	var color_shape_map = {
		"Blue": "Square",
		"Red": "Circle",
		"Green": "Rhombus",
		"Yellow": "Triangle",
		"Purple": "Hexagon",
		"Orange": "Pentagon"
	}
	
	# Remove the "Txt" part if it exists and find the color prefix
	var name_without_txt = full_name.replace("Txt", "")
	
	# Now extract the color and shape name
	for color in color_shape_map.keys():
		if name_without_txt.begins_with(color):
			var shape_name = color_shape_map[color]  # Get the corresponding shape name
			return shape_name
	
	# If no color prefix found, assume the name is already a shape
	return name_without_txt
