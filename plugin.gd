@tool
extends EditorPlugin

#region Constants

const CUSTOM_TYPE_NAME: String = "TPal"
const AUTOLOADER_NAME: String = "TPalManager"

#endregion


#region Variables

var editor_panel_instance

#endregion


#region Private Functions

func _enter_tree() -> void:
	add_custom_type(CUSTOM_TYPE_NAME, "Control", preload("res://addons/tooltip_pal/scripts/tpal.gd"), preload("res://addons/tooltip_pal/icons/comment.svg"))
	add_autoload_singleton(AUTOLOADER_NAME, "res://addons/tooltip_pal/scripts/autoloader/tpal_autoloader.gd")
	_make_visible(false)

	connect("scene_changed", _scene_changed)


func _exit_tree() -> void:
	remove_custom_type(CUSTOM_TYPE_NAME)

	remove_control_from_bottom_panel(editor_panel_instance)
	#editor_panel_instance.queue_free()
#	if framed_viewfinder_panel_instance:
	disconnect("scene_changed", _scene_changed)


#func _has_main_screen():
#	return true;


func _make_visible(visible):
	if editor_panel_instance:
		editor_panel_instance.set_visible(visible)


func _scene_changed(scene_root: Node) -> void:
	editor_panel_instance.viewfinder.scene_changed(scene_root)

#endregion


#region Public Functions

func get_version() -> String:
	var config: ConfigFile = ConfigFile.new()
	config.load(get_script().resource_path.get_base_dir() + "/plugin.cfg")
	return config.get_value("plugin", "version")

#endregion
