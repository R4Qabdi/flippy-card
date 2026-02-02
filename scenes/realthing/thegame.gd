extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#1f1e33"))
	

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#ProjectSettings.get("display/window/size/viewport_width")
	var mouseloc = get_global_mouse_position()
	var cameraloc = $camera.position
	var jarak = mouseloc.distance_to(cameraloc)
	var arah = mouseloc.direction_to(cameraloc)
	$camera.position = arah*(clamp(jarak, 0, 400)/50) 
	
	if Input.is_action_just_pressed("debug-m"):
		print("jumlah kartu dalam deck : "+str(global.cards_in_deck_id.size()))
	if Input.is_action_just_pressed("debug-n"):
		print($playerhand.cards_in_opp_hand)
		print($playerhand.cards_in_hand)
