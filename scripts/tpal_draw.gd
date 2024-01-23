extends Resource
class_name TPalDraw

enum DirectionEnum {TOP, RIGHT, BOTTOM, LEFT}
@export var direction: DirectionEnum = DirectionEnum.RIGHT
@export var panel: PackedScene = preload("res://addons/tooltip_pal/scenes/panels/default_panel.tscn")
@export var directionMargin: int = 0
@export var force_in_bounds: bool = true
@export var margin_left: int = 0
@export var margin_top: int = 0 
@export var margin_right: int = 0 
@export var margin_bottom: int = 0

var viewport: Vector2
var tooltip: Control

func determineShift(direction: TPalDraw.DirectionEnum, directionMargin: int, tooltip_panel: Vector2, parent: Vector2) -> Vector2:
	var directionShift = Vector2(0,0)
	var marginalShift = Vector2(0,0)
	
	match direction:
		TPalDraw.DirectionEnum.TOP:
			directionShift = Vector2(0, -tooltip_panel.y)
			marginalShift = Vector2(0, -directionMargin)
		TPalDraw.DirectionEnum.RIGHT:
			directionShift = Vector2(parent.x, 0)
			marginalShift = Vector2(directionMargin, 0)
		TPalDraw.DirectionEnum.BOTTOM:
			directionShift = Vector2(0, parent.y)
			marginalShift = Vector2(0, directionMargin)
		TPalDraw.DirectionEnum.LEFT:
			directionShift = Vector2(-tooltip_panel.x, 0)
			marginalShift = Vector2(-directionMargin, 0)

	return directionShift + marginalShift

# Repositions the tooltip's global position to remain within the viewport.
func force_inside_viewport(tooltip):
	# Calculate end position now for readability sake.
	var tooltipEndPos = tooltip.global_position + tooltip.size

	# Setting global position because we are working relative to the viewport.
	if tooltip.global_position.x < 0: 
		tooltip.global_position.x = 0
	if tooltip.global_position.y < 0: 
		tooltip.global_position.y = 0
	if tooltipEndPos.x > viewport.x: 
		tooltip.global_position.x = viewport.x - tooltip.size.x
	if tooltipEndPos.y > viewport.y:
		tooltip.global_position.y = viewport.y - tooltip.size.y

func generate_tpal() -> Control:
	return panel.instantiate()


func position_from_size(position_from: Node) -> Vector2:
	var position_from_size = Vector2(0,0)
	
	if position_from.has_method("size"):
		position_from_size = position_from.size
		
	return position_from_size
	
