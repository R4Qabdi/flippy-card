extends Control

const MOUSE_RAY_MASK = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name == "mainmenu":
		RenderingServer.set_default_clear_color(Color("#2a2349"))
	if name == "menu":
		RenderingServer.set_default_clear_color(Color("#90bcc6"))
	if name =="thegame":
		RenderingServer.set_default_clear_color(Color("#1f1e33"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var option = mouse_raycast()
		if event.is_pressed():
			if option:
				if option.name == "tutor":
					get_tree().change_scene_to_file("res://scenes/realthing/thegame.tscn")
					#$tutor/select.visible = true
				if option.name == "limine":
					get_tree().change_scene_to_file("res://scenes/core/tests.tscn")
				if option.name == "reina":
					get_tree().change_scene_to_file("res://scenes/realthing/thegame.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#ProjectSettings.get("display/window/size/viewport_width")
	var mouseloc = get_global_mouse_position()
	var cameraloc = $camera.position
	var jarak = mouseloc.distance_to(cameraloc)
	var arah = mouseloc.direction_to(cameraloc)
	$camera.position = arah*(clamp(jarak, 0, 400)/50) 
	#+ Vector2(
		#ProjectSettings.get("display/window/size/viewport_width")/2,
		#ProjectSettings.get("display/window/size/viewport_height")/2)
	#print("jarak = "+str(floor(jarak)))
	#print("arah = "+str(arah))
	
	var option = mouse_raycast()
	
	if option:
		if option.name == "tutor":
			get_node_or_null("tutor/select").visible = true
		else: get_node_or_null("tutor/select").visible = false
		if option.name == "limine":
			get_node_or_null("limine/select").visible = true
		else: get_node_or_null("limine/select").visible = false
		if option.name == "reina":
			get_node_or_null("reina/select").visible = true
		else: get_node_or_null("reina/select").visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/realthing/menu.tscn")

func _on_exit_pressed() -> void:get_tree().quit()

func mouse_raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MOUSE_RAY_MASK
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		return result[0].collider
	return result
