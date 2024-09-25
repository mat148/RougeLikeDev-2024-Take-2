extends EntityNew
class_name StairWayUp

var is_interacting: bool = false
var entity: EntityNew = null

func _ready() -> void:
	SignalBus.interact_event.connect(move_entity_up)

func move_entity_up() -> void:
	if is_interacting:
		entity.move(Vector3i(0,0,1))

func _on_hit_box_component_area_entered(area: Area2D) -> void:
	is_interacting = true
	entity = area.get_parent()

func _on_hit_box_component_area_exited(area: Area2D) -> void:
	is_interacting = false
	entity = null
