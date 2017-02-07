private - building widgets
createWidgets
	components do: [ :each | self assign: each to: ('control' , each hash asString) asSymbol ]