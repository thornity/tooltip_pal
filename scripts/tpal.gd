@icon("res://addons/tooltip_pal/icons/comment.svg")
class_name TPal
extends Control

var tpal_manager: TPalManager = TPalManager

@export var target_position_node: Node

## What & where is the box
@export var tpal_draw: TPalDraw = preload("res://addons/tooltip_pal/resources/tpal_draw_default.tres")

## The actions & state of the box
@export var tpal_oc: TPalOC = preload("res://addons/tooltip_pal/resources/tpal_oc_default.tres")

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	
	tpal_draw.viewport = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)	
	pass

func _on_mouse_entered():
	
	TPalManager.tpal_mouse_enter.emit()
	
	var position_from: Node = target_position_node
	if !position_from:
		position_from = get_parent()
	
	#I'm moving some behaviour back in here, I'm going to let this node manage its resources and the scene, 
	#    have the resources only used as a data store.
	var tpal := tpal_draw.generate_tpal()
	TPalManager.add_child(tpal)
	
	#Let's get the tpal transforms
	var tpal_transform := tpal.get_canvas_transform()
	
	if !(position_from is Node2D or position_from is Control):
		assert("Target Node is not a Control or Node2d")
	
	var origin_transform = tpal_transform * position_from.get_canvas_transform().affine_inverse()
	var target_local_position = position_from.position * origin_transform
	
	
	# I did not verify if this works
	if tpal_draw.force_in_bounds: 
		tpal_draw.force_inside_viewport(tpal)
	
	tpal.position = target_local_position

	
	#Temporary hack to remove the tooltip when leaving
	connect("mouse_exited", func(): tpal.queue_free(),CONNECT_ONE_SHOT)
	
	pass

func _on_mouse_exited():
	#tpal_oc.mouse_exit(tpal_draw.tooltip)
	pass
