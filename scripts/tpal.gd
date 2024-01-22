@icon("res://addons/tooltip_pal/icons/comment.svg")
class_name TPal
extends Control

var tpal_manager: TPalManager = TPalManager

@export var position_from: Control

## What & where is the box
@export var tpal_draw: TPalDraw = preload("res://addons/tooltip_pal/resources/tpal_draw_default.tres")

## The actions & state of the box
@export var tpal_oc: TPalOC = preload("res://addons/tooltip_pal/resources/tpal_oc_default.tres")

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	tpal_draw.viewport = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)	
	pass

func _on_mouse_entered():
	TPalManager.tpal_mouse_enter.emit()
	
	var position_from: Node
	
	if position_from != null:
		position_from = self.position_from
	else:
		position_from = get_parent()

	
	#var screen_coord = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * position_from.
	
	tpal_oc.mouse_enter(tpal_draw.generate_tpal(position_from))
	
		
	pass

func _on_mouse_exited():
	tpal_oc.mouse_exit(tpal_draw.tooltip)
	pass
