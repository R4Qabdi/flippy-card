extends Node2D
const MOUSE_RAY_MASK = 1<<1
var playerbettedcard
var oppbettedcard
var stolencard
var randpick
var situation
var playercoins:int=0
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
				if situation == "player steal card" or situation =="player destroy and steal card":
					$"../playerhand".cards_in_opp_hand.erase(card)
					$"../playerhand".update_new_card_pos_for_opp()
					card.get_node("textures/hover").visible = false
					card.change_facing()
					$"../playerhand".cards_in_hand.append(card)
					$"../playerhand".update_new_card_pos()
					
					for n in $"../playerhand".cards_in_opp_hand:
						n.selectable = false
					for i in $"../playerhand".cards_in_hand:
						i.selectable = true
					checkwin()
					
					situation = "player stole card"
				else:
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
	#cfp = 1
	#cfo = 0
	print(str(cfp) + "-" + str(cfo))
	#print(playerbettedcard)
	#print(oppbettedcard)
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
		checkwin()
	if !cfp and !cfo:
		notif("both lose",null,null)
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		checkwin()
	
	if cfp and !cfo:
		notif("you win",str(playerbettedcard.points),"opponent")
		#slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		#slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		$"../playerhand".cards_in_hand.append(playerbettedcard)
		$"../playerhand".update_new_card_pos()
		
		#THIS IS WHERE IT WILL GET INTERESTING
		$"../anim".play("RESET")
		if playerbettedcard.points == 1:
			playercoins +=1
			$"../options/option/Label".text = "Do you want to destroy\n your opponent's card?(-1 coins)"
			situation ="player destroy card"
			$"../animdec".play("question")
		elif playerbettedcard.points == 2:
			playercoins +=2
			$"../options/option/Label".text = "Do you want to take\n your opponent's card?(-2 coins)"
			situation ="player take card"
			$"../animdec".play("question")
		elif playerbettedcard.points == 3:
			playercoins +=3
			oppbettedcard.change_facing()
			$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
			$"../playerhand".update_new_card_pos_for_opp()
			$"../options/option/Label".text = "Do you want to steal\n your opponent's card?(-3 coins)"
			situation ="player steal card"
			$"../animdec".play("question")
		elif playerbettedcard.points == 4:
			playercoins +=4
			#$"../playerhand".cards_in_opp_hand.erase(oppbettedcard)
			$"../options/option/Label".text = "Do you want to destroy and steal\n your opponent's card?(-4 coins)"
			situation ="player destroy and steal card"
			$"../animdec".play("question")
		else:
			slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		$"../playerhand".update_new_card_pos()
	$"../coinflip/point/Label".text = str(playercoins)

	if !cfp and cfo:
		notif("you lose",str(oppbettedcard.points),"opponent")
		#slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		#slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
		oppbettedcard.change_facing()
		$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
		$"../playerhand".update_new_card_pos_for_opp()
		$"../anim".play("RESET")
		#RAAAHHH THIS IS WHERE I ADDED A NEW FEATURE FOR THE OPP WIN CONDITION
		#hmmm idk, maybe starts with who playing it
		if get_parent().name == "limine" :
			if oppbettedcard.points == 1:
				print("anjay selebew")
				slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
				
			elif oppbettedcard.points == 2:
				playerbettedcard.change_facing()
				$"../playerhand".cards_in_opp_hand.append(playerbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
				
			elif oppbettedcard.points == 3:
				$"../playerhand".cards_in_hand.append(playerbettedcard)
				#playerbettedcard.change_facing()
				$"../playerhand".update_new_card_pos()
				await delay(1)
				if $"../playerhand".cards_in_hand.size() > 0:
					var randomcard = $"../playerhand".cards_in_hand.pick_random()
					randomcard.change_facing()
					$"../playerhand".cards_in_opp_hand.append(randomcard)
					$"../playerhand".cards_in_hand.erase(randomcard)
				$"../playerhand".update_new_card_pos()
				$"../playerhand".update_new_card_pos_for_opp()
				
			elif oppbettedcard.points == 4:
				slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
				await delay(1)
				if $"../playerhand".cards_in_hand.size() > 0:
					var randomcard = $"../playerhand".cards_in_hand.pick_random()
					randomcard.change_facing()
					$"../playerhand".cards_in_opp_hand.append(randomcard)
					$"../playerhand".cards_in_hand.erase(randomcard)
				$"../playerhand".update_new_card_pos()
				$"../playerhand".update_new_card_pos_for_opp()
			else:
				slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		else: print("limine lagi ga main woilah wkwkwkwkw")
		checkwin()
		

func checkwin():
	for i in $"../playerhand".cards_in_hand:
		#print($"../playerhand".cards_in_hand[i].selectable)
		i.selectable = true
		#print($"../playerhand".cards_in_hand[i].selectable)
	
	if $"../playerhand".cards_in_hand.size() == 0 and $"../playerhand".cards_in_opp_hand.size() == 0 :
			disable_all_cards()
			await delay(1)
			tie()
	else:
		if $"../playerhand".cards_in_opp_hand.size() == 0 :
			disable_all_cards()
			await delay(1)
			winner()
		elif $"../playerhand".cards_in_hand.size() == 0 :
			disable_all_cards()
			await delay(1)
			loser()

func disable_all_cards():
	for i in $"../playerhand".cards_in_hand:
		i.selectable = false

func _on_yes_pressed() -> void:
	player_decision(true)
	$"../anim".play_backwards("question")
	$"../anim".queue("RESET")

func _on_no_pressed() -> void:
	player_decision(false)
	$"../anim".play_backwards("question")
	$"../anim".queue("RESET")

func player_decision(agree):
	match situation:
		"player destroy card":
			if agree:
				playercoins -= 1
				print("hancur lo")
				slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
				checkwin()
				situation = null
			else:
				for n in $"../playerhand".cards_in_hand:
					n.selectable = true
				oppbettedcard.change_facing()
				$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
				situation = null
		"player take card":
			if agree:
				playercoins -= 2
				print("kuambil lo")
				oppbettedcard.selectable = true
				$"../playerhand".cards_in_hand.append(oppbettedcard)
				$"../playerhand".update_new_card_pos()
				checkwin()
				situation = null
			else:
				for n in $"../playerhand".cards_in_hand:
					n.selectable = true
				oppbettedcard.change_facing()
				$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
				situation = null
		"player steal card":
			if agree:
				playercoins -= 3
				print("kucuri lo")
				disable_all_cards()
				for n in $"../playerhand".cards_in_opp_hand:
					n.selectable = true
				checkwin()
			else:
				situation = "fek"
				for n in $"../playerhand".cards_in_hand:
					n.selectable = true
				#$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
		"player destroy and steal card":
			if agree:
				playercoins -= 4
				print("double action lo")
				slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
				$"../playerhand".cards_in_opp_hand.erase(oppbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
				disable_all_cards()
				for n in $"../playerhand".cards_in_opp_hand:
					n.selectable = true
				checkwin()
			else:
				situation = "fek"
				for n in $"../playerhand".cards_in_hand:
					n.selectable = true
				$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
				oppbettedcard.change_facing()
				#$"../playerhand".cards_in_opp_hand.append(oppbettedcard)
				$"../playerhand".update_new_card_pos_for_opp()
	$"../coinflip/point/Label".text = str(playercoins)


func winner():
	print("you are winnaa")
	$"../anim".play("RESET")
	$"../animdec".play("RESET")
	$"../options/result/Label".text = "you just won against your opponent!\n now what?"
	$"../anim".queue("result")
func loser():
	print("you are lossaa")
	$"../anim".play("RESET")
	$"../animdec".play("RESET")
	$"../options/result/Label".text = "you just lost >~>\n now what?"
	$"../anim".queue("result")
func tie():
	print("you are lossaa")
	$"../anim".play("RESET")
	$"../animdec".play("RESET")
	$"../options/result/Label".text = "it's a tie, i never thought of this would happen\n now what?"
	$"../anim".queue("result")

func notif(state, msg, who):
	match state:
		"both win":
			$"../options/both/Label".text = "both win \nswitch cards"
			$"../anim".play("both")
		
		"both lose":
			$"../options/both/Label".text = "both lose \ncards destroyed"
			$"../anim".play("both")
		
		"you win":
			$"../options/both/Label".text = "you win \n+"+msg+" coins"
			$"../anim".play("both")
			
		
		'you lose':
			$"../options/both/Label".text = "you lose\n"+who+" gained +"+msg+" coins"
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
		print(result)
		if result[0].collider.get_parent().selectable:
			return result[0].collider.get_parent()
	return null

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
