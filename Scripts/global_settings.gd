extends Node

# constants
const SAVEFILE = "user://SETTINGS.cfg"

const SETTINGS_TEMPLATE_PADDLE_CLASSIC:Dictionary = {
	"paddle_height": 4,
	"paddle_speed": 4,
}
const SETTINGS_TEMPLATE_PADDLE_BIG:Dictionary = {
	"paddle_height": 20,
	"paddle_speed": 8,
}
const SETTINGS_TEMPLATE_PADDLE_SPEED:Dictionary = {
	"paddle_height": 10,
	"paddle_speed": 14,
}

const SETTINGS_TEMPLATE_BALL_CLASSIC:Dictionary = {
	"ball_size": 1,
	"ball_min_speed": 4,
	"ball_max_speed": 12,
	"ball_speed_increase": 4,
}
const SETTINGS_TEMPLATE_BALL_BIG:Dictionary = {
	"ball_size": 10,
	"ball_min_speed": 4,
	"ball_max_speed": 12,
	"ball_speed_increase": 4,
}
const SETTINGS_TEMPLATE_BALL_SPEED:Dictionary = {
	"ball_size": 2,
	"ball_min_speed": 6,
	"ball_max_speed": 20,
	"ball_speed_increase": 8,
}

const SETTINGS_PADDLE:Dictionary = {
	"custom": SETTINGS_TEMPLATE_PADDLE_CLASSIC,
	"classic": SETTINGS_TEMPLATE_PADDLE_CLASSIC,
	"big": SETTINGS_TEMPLATE_PADDLE_BIG,
	"speed": SETTINGS_TEMPLATE_PADDLE_SPEED,
}
const SETTINGS_BALL:Dictionary = {
	"custom": SETTINGS_TEMPLATE_BALL_CLASSIC,
	"classic": SETTINGS_TEMPLATE_BALL_CLASSIC,
	"big": SETTINGS_TEMPLATE_BALL_BIG,
	"speed": SETTINGS_TEMPLATE_BALL_SPEED,
}

const SETTINGS_PADDLES:Dictionary = {
	"paddle_1": {
		"type": 0,
		"current_template": "classic",
		"templates": SETTINGS_PADDLE,
	},
	"paddle_2": {
		"type": 1,
		"current_template": "classic",
		"templates": SETTINGS_PADDLE,
	}
}

const SETTINGS_SECTIONS:Dictionary = {
	"paddles": SETTINGS_PADDLES,
	"ball": {
		"current_template": "classic",
		"templates": SETTINGS_BALL,
	},
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
