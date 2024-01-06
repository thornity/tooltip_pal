@icon("res://addons/tooltip_pal/icons/comment.svg")

class_name TooltipPal
extends Control

@export var position_from: Control

enum DirectionEnum {UP, RIGHT, DOWN, LEFT}
@export var direction: DirectionEnum
@export var directionalMargin: int
@export var forceInBounds: bool

# TODO: implement
@export var hover_time: float
@export var panel: PackedScene

var tooltip: Control

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	pass

func determineShift(direction: DirectionEnum, directionalMargin: int, tooltip_panel: Vector2, parent: Vector2) -> Vector2:
	var directionShift = Vector2(0,0)
	var marginalShift = Vector2(0,0)
	
	match direction:
		DirectionEnum.UP:
			directionShift = Vector2(0, -tooltip_panel.y)
			marginalShift = Vector2(0, -directionalMargin)
		DirectionEnum.RIGHT:
			directionShift = Vector2(parent.x, 0)
			marginalShift = Vector2(directionalMargin, 0)
		DirectionEnum.DOWN:
			directionShift = Vector2(0, parent.y)
			marginalShift = Vector2(0, directionalMargin)
		DirectionEnum.LEFT:
			directionShift = Vector2(-tooltip_panel.x, 0)
			marginalShift = Vector2(-directionalMargin, 0)

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
	tooltip = panel.instantiate() as Control
	
	if position_from != null:
		tooltip.global_position = position_from.global_position
		pass
	else:
		position_from = get_parent()
	
	tooltip.global_position = determineShift(direction, directionalMargin, tooltip.size, position_from.size)
	
	position_from.add_child(tooltip)
	
	# Must do this repositioning after we have added it to the tree.
	if forceInBounds: 
		forceInsideViewport(tooltip)
		
	pass

func _on_mouse_exited():
	position_from.remove_child(tooltip)
	pass
