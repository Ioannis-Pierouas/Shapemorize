extends Control

const MASTER_BUS = 0
const MUSIC_BUS = 1
const SFX_BUS = 2
# Panels
@onready var leaderboard_panel = $LeaderboardPanel
@onready var settings_panel = $SettingsPanel
@onready var main_menu_panel = $MainMenuPanel
@onready var guide_panel = $GuidePanel
# Sounds
@onready var music_slider = $SettingsPanel/MusicVolumeSlider
@onready var sfx_slider = $SettingsPanel/SFXVolumeSlider
@onready var mute_button = $SettingsPanel/MuteButton
@onready var music_player = $MenuMusicPlayer
@onready var click_player = $ClickSoundPlayer

@onready var highscore_label = $LeaderboardPanel/Highscore

@export var bus_name: String
@export var bus_index: int

func _ready():
	print("Transition to Main Menu")
	hide_panels_except(0)
	initialize_text()

# Main Menu

func _on_play_button_pressed():
	print("Play button pressed")
	click_player.play()
	Global.new_game() # reset game
	get_tree().change_scene_to_file("res://Scenes/game_screen.tscn")

func _on_guide_button_pressed():
	print("Guide button pressed")
	click_player.play()
	hide_panels_except(1)

func _on_settings_button_pressed():
	print("Settings button pressed")
	click_player.play()
	hide_panels_except(2)

func _on_leaderboard_button_pressed():
	print("Highscore button pressed")
	click_player.play()
	hide_panels_except(3)

func _on_exit_button_pressed():
	print("Exit button pressed")
	click_player.play()
	get_tree().quit()

# Settings Menu

func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS, value)

func _on_sfx_volume_slider_value_changed(value):
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

func _on_back_button_pressed():
	print("Any Back button pressed")
	click_player.play()
	hide_panels_except(0)

func hide_panels_except(target: int):
	print("-hide panels func-")
	match target:
		0: # except main menu
			main_menu_panel.visible = true
			settings_panel.visible = false
			leaderboard_panel.visible = false
			guide_panel.visible = false
		1: # except guide
			main_menu_panel.visible = false
			guide_panel.visible = true
			settings_panel.visible = false
			leaderboard_panel.visible = false
		2: # except settings
			main_menu_panel.visible = false
			guide_panel.visible = false
			settings_panel.visible = true
			leaderboard_panel.visible = false
		3: # except leaderboard
			main_menu_panel.visible = false
			guide_panel.visible = false
			settings_panel.visible = false
			leaderboard_panel.visible = true

func initialize_text():
	print("-initialize text func-")
	$MainMenuPanel/Title.text = "Shapemorize"
	$MainMenuPanel/PlayButton.text = "Play"
	$MainMenuPanel/GuideButton.text = "Guide"
	$MainMenuPanel/SettingsButton.text = "Settings"
	$MainMenuPanel/LeaderboardButton.text = "Highscore"
	$MainMenuPanel/ExitButton.text = "Exit"
	
	$GuidePanel/Title.text = "Guide"
	$GuidePanel/BackButton.text = "Back"
	
	$SettingsPanel/Title.text = "Settings"
	$SettingsPanel/MusicVolumeLabel.text = "Music Volume"
	music_slider.value = AudioServer.get_bus_volume_db(MUSIC_BUS)
	$SettingsPanel/SFXVolumeLabel.text = "SFX Volume"
	sfx_slider.value = AudioServer.get_bus_volume_db(SFX_BUS)
	mute_button.text = "Mute"
	$SettingsPanel/BackButton.text = "Back"
	
	$LeaderboardPanel/Title.text = "Leaderboard"
	highscore_label.text = "Highscore: " + str(Global.highscore)
	$LeaderboardPanel/BackButton.text = "Back"

