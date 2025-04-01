extends Control

func _ready():
	show_category(0)

func show_category(target: int):
	match target:
		0:
			$Category1.hide()
			$Category2.hide()
			$Category3.hide()
			$Category4.hide()
		1:
			$Category1.show()
			$Category2.hide()
			$Category3.hide()
			$Category4.hide()
		2:
			$Category1.hide()
			$Category2.show()
			$Category3.hide()
			$Category4.hide()
		3:
			$Category1.hide()
			$Category2.hide()
			$Category3.show()
			$Category4.hide()
		4:
			$Category1.hide()
			$Category2.hide()
			$Category3.hide()
			$Category4.show()
		5:
			$Category1.show()
			$Category2.show()
			$Category3.show()
			$Category4.show()

func show_shape(cat, shape: String):
	if cat > 0 and cat < 5:
		var category_name = "Category" + str(cat)
		print(category_name)
		var category = get_node(category_name)
		match shape:
			"Square":
				category.get_node("BlueSquare").show()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").hide()
			"Circle":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").show()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").hide()
			"Triangle":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").show()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").hide()
			"Rhombus":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").show()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").hide()
			"Pentagon":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").show()
				category.get_node("PurpleHexagon").hide()
			"Hexagon":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").show()
			"":
				category.get_node("BlueSquare").hide()
				category.get_node("RedCircle").hide()
				category.get_node("YellowTriangle").hide()
				category.get_node("GreenRhombus").hide()
				category.get_node("OrangePentagon").hide()
				category.get_node("PurpleHexagon").hide()
