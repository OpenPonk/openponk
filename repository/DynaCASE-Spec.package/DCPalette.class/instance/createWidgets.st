building widgets
createWidgets
	items do: [ :item | self assign: item to: ('button' , item hash asString) asSymbol ]