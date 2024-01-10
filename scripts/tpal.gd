@icon("res://addons/tooltip_pal/icons/comment.svg")

class_name TPal
extends Control

var tpal_manager: TPalManager = TPalManager

@export var position_from: Control

## TODO
@export var tpal_draw: TPalDraw = preload("res://addons/tooltip_pal/resources/tpal_draw_default.tres")

## TODO
@export var tpal_oc: TPalOC = preload("res://addons/tooltip_pal/resources/tpal_oc_default.tres")


var tooltip: Control

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	pass

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
func forceInsideViewport(tooltip):
	# Calculate end position now for readability sake.
	var tooltipEndPos = tooltip.global_position + tooltip.size

	# Setting global position because we are working relative to the viewport.
	if tooltip.global_position.x < 0: 
		tooltip.global_position.x = 0
	if tooltip.global_position.y < 0: 
		tooltip.global_position.y = 0
	if tooltipEndPos.x > get_viewport_rect().size.x: 
		tooltip.global_position.x = get_viewport_rect().size.x - tooltip.size.x
	if tooltipEndPos.y > get_viewport_rect().size.y:
		tooltip.global_position.y = get_viewport_rect().size.y - tooltip.size.y

func _on_mouse_entered():
	tooltip = tpal_oc.panel.instantiate() as Control
	
	if position_from != null:
		tooltip.global_position = position_from.global_position
		pass
	else:
		position_from = get_parent()

	tooltip.global_position = position_from.global_position + determineShift(tpal_draw.direction, tpal_draw.directionMargin, tooltip.size, position_from.size)

	if tpal_draw.forceInBounds: 
		forceInsideViewport(tooltip)
	
	tpal_manager.add_child(tooltip)
		
	pass

func _on_mouse_exited():
	tpal_manager.remove_child(tooltip)
	pass
