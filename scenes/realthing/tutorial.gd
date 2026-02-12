extends Control
var slide_index:int = 1
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("69a78bff"))
	project(slide_index)

func _process(delta: float) -> void:
	var mouseloc = get_global_mouse_position()
	var cameraloc = $camera.position
	var jarak = mouseloc.distance_to(cameraloc)
	var arah = mouseloc.direction_to(cameraloc)
	$camera.position = arah*(clamp(jarak, 0, 400)/50) + Vector2(320,180)
func _input(event):
	var is_mouse_click = event is InputEventMouseButton and event.pressed
	var is_key_press = event is InputEventKey and event.pressed
	
	if is_mouse_click or is_key_press:
		sound.play_sound("select")
		slide_index += 1
		project(slide_index)
		print(slide_index)
func project(index):
	match index:
		1:
			$Panel.visible=true
			$deck.visible=false
			$coinflip.visible=false
			$cards.visible=false
		2:
			$cards.visible=true 
			$Panel.visible=false
			$Panel2.visible=true
		3:
			$cards.visible=false
			$Panel2.visible=false
			$Panel22.visible=true
		4:
			$deck.visible=true
			$coinflip.visible=true
			$cards.visible=true 
			$Panel22.visible=false
			$Panel3.visible=true
		5:
			$Panel3.visible=false
			$Panel4.visible=true
		6:
			$Panel4.visible=false
			$Panel5.visible=true
		7:
			$Panel5.visible=false
			$Panel6.visible=true
		8:
			$Panel6.visible=false
			$Panel7.visible=true
		9:
			$Panel7.visible=false
			$Panel8.visible=true
		10:
			$Panel8.visible=false
			$Panel9.visible=true
		11:
			get_tree().change_scene_to_file("res://scenes/realthing/menu.tscn")
			
