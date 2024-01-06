@icon("res://addons/tooltip_pal/icons/comment.svg")

class_name TooltipPal
extends Control

@export var position_from: Control

enum DirectionEnum {UP, RIGHT, DOWN, LEFT}
@export var direction: DirectionEnum
@export var directionalMargin: int
## When enabled, keeps the tooltip inside the viewport
@export var forceInBounds: bool
## Uses the parent rect as the hover activator instead of this rect.
@export var useParentRect : bool = true

# TODO: implement
@export var hover_time: float
@export var panel: PackedScene

var tooltip: Control

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	switch_to_parent_rect(useParentRect)
	pass

# Changes hover activator rect to parent or self.
func switch_to_parent_rect(value: bool):
	if value:
			get_parent().connect("mouse_entered", _on_mouse_entered)
			get_parent().connect("mouse_exited", _on_mouse_exited)
			mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		# Need to check if there is a connection to prevent Error out.
		if get_parent().is_connected("mouse_entered", _on_mouse_entered): 
			get_parent().disconnect("mouse_entered", _on_mouse_entered)
		if get_parent().is_connected("mouse_exited", _on_mouse_exited):
			get_parent().disconnect("mouse_exited", _on_mouse_exited)
		mouse_filter = Control.MOUSE_FILTER_STOP

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
