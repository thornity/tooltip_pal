@icon("res://addons/tooltip_pal/icons/comment.svg")

class_name TooltipPal
extends Control

@export var position_from: Control

enum DirectionEnum {UP, RIGHT, DOWN, LEFT}
@export var direction: DirectionEnum
@export var directionalMargin: int

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

func _on_mouse_entered():
	tooltip = panel.instantiate() as Control
	
	if position_from != null:
		tooltip.global_position = position_from.global_position
		pass
	else:
		position_from = get_parent()
	determineShift(direction, directionalMargin, tooltip.size, position_from.size)
		
	tooltip.global_position = determineShift(direction, directionalMargin, tooltip.size, position_from.size)

	print_debug(tooltip.global_position)

	pass

func _on_mouse_exited():
	position_from.remove_child(tooltip)
	pass
