extends Node

# constants
const SAVEFILE = "user://SETTINGS.cfg"

const SETTINGS_GAMEPLAY_CLASSIC:Dictionary = {
	"paddle_height": 4,
	"paddle_speed": 4,
	"ball_size": 1,
	"ball_min_speed": 4,
	"ball_max_speed": 12,
	"ball_speed_increase": 4,
}
const SETTINGS_GAMEPLAY_BIG:Dictionary = {
	"paddle_height": 20,
	"paddle_speed": 12,
	"ball_size": 10,
	"ball_min_speed": 4,
	"ball_max_speed": 12,
	"ball_speed_increase": 4,
}
const SETTINGS_GAMEPLAY_SPEED:Dictionary = {
	"paddle_height": 10,
	"paddle_speed": 14,
	"ball_size": 2,
	"ball_min_speed": 5,
	"ball_max_speed": 20,
	"ball_speed_increase": 5,
}

const SETTINGS_PLAYERS:Dictionary = {
	"paddle_1": 0,
	"paddle_2": 1,
}
const SETTINGS_TEMPLATES:Dictionary = {
	"gameplay": 1,
}
const SETTINGS_GAMEPLAYS:Dictionary = {
	"custom": SETTINGS_GAMEPLAY_CLASSIC,
	"classic": SETTINGS_GAMEPLAY_CLASSIC,
	"big": SETTINGS_GAMEPLAY_BIG,
	"speed": SETTINGS_GAMEPLAY_SPEED
}

const SETTINGS_SECTIONS:Dictionary = {
	"players": SETTINGS_PLAYERS,
	"templates": SETTINGS_TEMPLATES,
	"gameplays": SETTINGS_GAMEPLAYS,
}

# variables
var data:Dictionary = {}

func _ready():
	load_data()

func load_data():
	# create new ConfigFile object
	var config = ConfigFile.new()
	# load in existing settings from file
	var error = config.load(SAVEFILE)
	
	# if no file
	if error != OK:
		# get default data from constant
		data = SETTINGS_SECTIONS
		# save and return
		save_data()
		return
	
	# set data from config file
	for config_section in config.get_sections():
		data[config_section] = {}
		for config_section_key in config.get_section_keys(config_section):
			data[config_section][config_section_key] = config.get_value(config_section, config_section_key)

func save_data():
	# create new ConfigFile object
	var config = ConfigFile.new()
	
	for config_section in data:
		for config_section_key in data[config_section]:
			config.set_value(config_section, config_section_key, data[config_section][config_section_key])
	
	# finally save to file
	config.save(SAVEFILE)
