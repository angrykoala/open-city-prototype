extends Character

class_name Collector

var target_building: Building
var origin_building: Building

var ammount_to_get: int
var resource_ammount: int
var resource_type: int

func _ready():
	var target=map.resource_manager.get_target_building_with_resource(resource_type, ammount_to_get, map_position)
	_set_target(target)

func arrived_to_destination():
	.arrived_to_destination()
	if target_building:
		target_building.character_arrived(self)
		if target_building==origin_building:
			_despawn()
		else:
			if target_building.is_in_group("storage"):
				var ammount=target_building.try_to_get(resource_type, ammount_to_get)
				resource_ammount=ammount
			return_to_origin()

func return_to_origin():
	_set_target(origin_building)

func _set_target(target:Building):
	target_building=target
	if target_building:
		var new_path=map.navigation.get_road_path_to_building(map_position, target_building.map_position)
		set_path(new_path)

func _despawn():
	queue_free()