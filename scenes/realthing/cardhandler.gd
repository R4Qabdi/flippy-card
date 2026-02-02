extends Node2D
const MOUSE_RAY_MASK = 1<<1
var playerbettedcard
var oppbettedcard
var randpick
func _ready() -> void:
	pass # Replace with function body.

func connect_card_signals(card):
	#ts doesnt need to connect, these signal thing is broken af
	card.connect("hover", on_card_hover)
	card.connect("hover_exit", on_card_exit_hover)

func on_card_hover(card):pass
	#broken shiiii
	
	#print("hovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	#card.get_node("textures").position.y = 0
	#slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y-10),0.2)

func on_card_exit_hover(card):pass
	#broken shiiii
	
	#print("unhovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	#card.get_node("textures").position.y = -10
	#slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y+10),0.2)

func slide(node, from, to, duration) -> Tween:
	node.position = from
	var tween = create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	return tween

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = mouse_raycast()
			
			#print(card)
			if card :
				playerbettedcard = card
				card.selectable = false
				card.get_node("textures/hover").visible = false
				
				handle(card, "player")
				randpick = randi_range(0,$"../playerhand".cards_in_opp_hand.size()-1)
				oppbettedcard = $"../playerhand".cards_in_opp_hand[randpick]
				
				handle(oppbettedcard,"opp")
				await delay(1)
				coinflip()

func coinflip():
	var cfp = randi_range(0,1)
	var cfo = randi_range(0,1)
	print(str(cfp) + "-" + str(cfo))
	print(playerbettedcard)
	print(oppbettedcard)
	playerbettedcard.get_node("textures").position.y = 0
	oppbettedcard.get_node("textures").position.y = 0
	#$"../coinflip".visible = true
	if cfp :
		$"../coinflip/playercoin".play("heads")
	else :
		$"../coinflip/playercoin".play("tails")
	if cfo :
		$"../coinflip/oppcoin".play("heads")
	else :
		$"../coinflip/oppcoin".play("tails")
	await delay(1)
	
	$"../coinflip/playercoin".stop()
	$"../coinflip/oppcoin".stop()
	await delay(1)
	if cfp and cfo:
		notif("both win",null,null)
		slide(playerbettedcard, playerbettedcard.position, $"../cardslot/foropp".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../cardslot/forplayer".position, 0.2)
		oppbettedcard.selectable = true
		$"../playerhand".cards_in_hand.append(oppbettedcard)
		$"../playerhand".cards_in_opp_hand.append(playerbettedcard)
		
		playerbettedcard.change_facing()
		$"../playerhand".update_new_card_pos()
		$"../playerhand".update_new_card_pos_for_opp()
	if !cfp and !cfo:
		notif("both lose",null,null)
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
	if cfp and !cfo:
		notif("you win",str(playerbettedcard.points),"opponent")
		#slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		$"../playerhand".cards_in_hand.append(playerbettedcard)
		$"../playerhand".update_new_card_pos()
		
		
	if !cfp and cfo:
		notif("you lose",str(oppbettedcard.points),"opponent")
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		#slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		oppbettedcard.change_facing()
		$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
		$"../playerhand".update_new_card_pos_for_opp()
	
	if $"../playerhand".cards_in_opp_hand.size() == 0 :
		winner()
	
	for i in range(0, $"../playerhand".cards_in_hand.size()):
		print($"../playerhand".cards_in_hand[i].selectable)
		$"../playerhand".cards_in_hand[i].selectable = true
		print($"../playerhand".cards_in_hand[i].selectable)
	#$"../coinflip".visible = false
func winner():
	print("you are winnaa")
func notif(state, msg, who):
	match state:
		"both win":
			$"../options/both/Label".text = "both win \nswitch cards"
			$"../anim".play("both")
		
		"both lose":
			$"../options/both/Label".text = "both lose \ncards destroyed"
			$"../anim".play("both")
		
		"you win":
			$"../options/both/Label".text = "you win \n+"+msg+" cents"
			$"../anim".play("both")
		
		'you lose':
			$"../options/both/Label".text = "you lose\n"+who+" gained +"+msg+" cents"
			#$"../options/opp/Label".text = who+" gained +"+msg+" cents"
			#$"../anim".play("opp")
			$"../anim".play("both")
			
func handle(card, who):
	match who:
		"player":
			$"../playerhand".cards_in_hand.erase(card)
			for i in range(0, $"../playerhand".cards_in_hand.size()):
				$"../playerhand".cards_in_hand[i].selectable = false
			$"../playerhand".update_new_card_pos()
			playerbettedcard.get_node("textures").position.y = 0
			slide(card, card.position, $"../cardslot/forplayer".position, 0.2)
		"opp":
			$"../playerhand".cards_in_opp_hand[randpick].change_facing()
			$"../playerhand".cards_in_opp_hand.erase($"../playerhand".cards_in_opp_hand[randpick])
			#for i in range(0, $"../playerhand".cards_in_opp_hand.size()):
				#$"../playerhand".cards_in_opp_hand[i].selectable = false
			$"../playerhand".update_new_card_pos_for_opp()
			oppbettedcard.get_node("textures").position.y = 0
			slide(card, card.position, $"../cardslot/foropp".position, 0.2)
			

func mouse_raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MOUSE_RAY_MASK
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		if result[0].collider.get_parent().selectable:
			return result[0].collider.get_parent()
	return null

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
