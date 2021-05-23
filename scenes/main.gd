extends Node

export(Array, Resource) var buildings

onready var hud: = $HUD
onready var player: = $Player
onready var map: = $Map
onready var building_update_timer:=$BuildingUpdateTimer

onready var city=ServiceLocator.get_city()

func _ready():
	var version=ProjectSettings.get_setting("application/config/version")
	Log.info("Open City Prototype", "v"+version)
	hud.set_buildings(buildings)
	city.set_map(map)
	_setup_signals()


func on_building_timer():
	get_tree().call_group("building", "on_building_update", building_update_timer.wait_time)

func get_building_resource(name: String):
	for building in buildings:
		if building.name==name:
			return building
	assert(false, "Building "+name+" not found")

func save():
	var result=map.serialize()
	var save_game = File.new()
	save_game.open("res://savegame.json", File.WRITE)
	save_game.store_line(JSON.print(result))
	save_game.close()

func load_game():
	var save_game = File.new()
	save_game.open("res://savegame.json", File.READ)
	var data=save_game.get_line()
	var game_data=JSON.parse(data)
	save_game.close()

func _setup_signals():
	hud.connect("building_resource_selected", player,"on_building_resource_selected")
	hud.connect("demolish_building_selected", player,"on_demolish_building_selected")
	hud.connect("save", self,"save")
	hud.connect("load_game", self,"load_game")
	map.connect("tile_selected", player, "on_tile_selected")
	player.connect("building_selected", hud, "show_building_info")
	building_update_timer.connect("timeout", self, "on_building_timer")
	
	city.connect("money_updated", hud, "on_money_updated")
	city.connect("population_updated", hud, "on_population_updated")
	city.add_money(0) # To kickstart the signals