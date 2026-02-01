extends Node2D


func _ready() -> void:
	pass # Replace with function body.

func connect_card_signals(card):
	card.connect("hover", on_card_hover)
	card.connect("hover_exit", on_card_exit_hover)

func on_card_hover(card):
	print("hovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	card.get_node("textures").position.y = 0
	slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y-10),0.2)#biar bisa lebih ke kanan fungsi dari komen ini

func on_card_exit_hover(card):
	print("unhovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	card.get_node("textures").position.y = -10
	slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y+10),0.2)

func slide(node, from, to, duration) -> Tween:
	node.position = from
	var tween = create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	return tween




func _process(delta: float) -> void:
	pass
