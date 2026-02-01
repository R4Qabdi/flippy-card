extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func connect_card_signals(card):
	card.connect("hover", on_card_hover)
	card.connect("hover_exit", on_card_exit_hover)

func on_card_hover(card):pass
	#print("hovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	#card.get_node("textures").position.y = 0
	#slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y-10),0.2)#biar bisa lebih ke kanan fungsi dari komen ini

func on_card_exit_hover(card):pass
	#print("unhovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	#card.get_node("textures").position.y = -10
	#slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y+10),0.2)
