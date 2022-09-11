# taken from the demo scripts

extends Node

signal initialised

var core: Discord.Core
var users: Discord.UserManager
var images: Discord.ImageManager
var activities: Discord.ActivityManager
var relationships: Discord.RelationshipManager
var networking: Discord.NetworkManager

#func _ready() -> void:
#	call_deferred("create_core")

func _process(_delta: float) -> void:
	if core:
		var result: int = core.run_callbacks()
		if result != Discord.Result.OK:
			print("Failed to run callbacks: ", enum_to_string(Discord.Result, result))
			destroy_core()


func _log_hook(level: int, message: String) -> void:
	print("[DISCORD] ", enum_to_string(Discord.LogLevel, level), ": ", message)


func create_core(app_id) -> bool:
	destroy_core()
	core = Discord.Core.new()
	var result: int = core.create(app_id, Discord.CreateFlags.NO_REQUIRE_DISCORD)

	if result != Discord.Result.OK:
		print("Failed to initialise Discord Core: ", enum_to_string(Discord.Result, result))
		destroy_core()
		return false

	core.set_log_hook(Discord.LogLevel.DEBUG, self, "_log_hook")

#	users = core.get_user_manager()
#	images = core.get_image_manager()
	activities = core.get_activity_manager()
#	relationships = core.get_relationship_manager()
#	networking = core.get_network_manager()

	emit_signal("initialised")
	return true


func destroy_core() -> void:
	core = null
	users = null
	images = null
	activities = null
	relationships = null
	networking = null

func enum_to_string(the_enum: Dictionary, value: int) -> String:
	var index := the_enum.values().find(value)
	var string: String = the_enum.keys()[index]
	return string
