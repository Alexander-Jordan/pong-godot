extends Node

# constanst
const SAVEFILE = "user://SETTINGS.cfg"
const GLOBAL_USER = "Global"
const PADDLE_SPEED:int = 400
const BALL_MIN_SPEED: int = 400
const BALL_MAX_SPEED: int = 1200
const DEFAULT_SETTINGS:Dictionary = {
	"paddle_speed": PADDLE_SPEED,
	"ball_min_speed": BALL_MIN_SPEED,
	"ball_max_speed": BALL_MAX_SPEED,
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
		# get default data from constants
		data = {GLOBAL_USER: DEFAULT_SETTINGS}
		# save and return
		save_data()
		return
	
	# sections should be user based ("Global" is for all users without specific user settings)
	for section in config.get_sections():
		# first create the section (user) to be stored
		data[section] = {}
		# get defined settings names from constant
		for setting in DEFAULT_SETTINGS:
			# get and store config section setting in data section setting
			data[section][setting] = config.get_value(section, setting, DEFAULT_SETTINGS[setting])

func save_data():
	# create new ConfigFile object
	var config = ConfigFile.new()
	
	# sections should be user based ("Global" is for all users without specific user settings)
	for section in data:
		# get defined settings names from constant
		for setting in DEFAULT_SETTINGS:
			# check if the setting from data is defined in constant
			if data.has(setting):
				# set config setting to data setting
				config.set_value(section, setting, data[section][setting])
			else:
				# set config setting to default
				config.set_value(section, setting, DEFAULT_SETTINGS[setting])
	
	# finally save to file
	config.save(SAVEFILE)
