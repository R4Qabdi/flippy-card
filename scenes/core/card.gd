extends Control
@export var cid:int = 1
@export var cname:String
@export var cvalue:String
@export var csuit:String
@export var cfacing:String
func _ready() -> void:
	var data :Dictionary = load_json_dict("res://scenes/json/card_database.json")
	#print(data)
	var path = data[str(cid)]["path"]
	$text.texture=load(path)

func _process(delta: float) -> void:
	pass

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("RAAAAAAAAAAAAAAAAAA")

func _on_text_mouse_entered() -> void:
	print("hover enter")

func _on_text_mouse_exited() -> void:
	print("hover exit")

func load_json_dict(path: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		push_error("JSON file is empty or missing: " + path)
		return {}
	var data = JSON.parse_string(text)
	if data == null or typeof(data) != TYPE_DICTIONARY:
		push_error("JSON is not a Dictionary")
		return {}

	return data
