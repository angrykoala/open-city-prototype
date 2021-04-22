extends Building

export(Global.RESOURCES) var required_resource
export var consumption_rate:float=1
export var max_required_storage:int=5
export var max_market_distance:int= 10
export var max_population:int=10


var current_required_quantity: float=0

var population:HousePopulation

func _ready():
	add_to_group(Global.BUILDING_ROLES.HOUSE)
	population=HousePopulation.new(max_population)
	population.increase_population(5)
	
func _exit_tree():
	population.remove_all_population()

func on_building_update(delta: float): # TODO: improve
	.on_building_update(delta)
	_consume_resource(delta)
	if (current_required_quantity<consumption_rate or current_required_quantity==0):
		_find_market_food()

func _consume_resource(delta: float):
	if _has_required_quantity(delta):
		var consumed_ammount=consumption_rate*delta
		current_required_quantity=clamp(current_required_quantity-consumed_ammount, 0, max_required_storage)

func _has_required_quantity(delta: float):
	return current_required_quantity >= consumption_rate*delta


func _find_market_food():
	var markets=map.navigation.get_buildings_at_distance(map_position, [Global.BUILDING_ROLES.MARKET], max_market_distance)
	if markets.size()>0:
		var ammount=markets[0].get_resource_quantity()
		if ammount>0:
			var real_ammount=min(ammount, max_required_storage)
			markets[0].consume_resource(real_ammount)
			current_required_quantity=real_ammount
