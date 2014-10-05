building widgets
createWidgets
	components do: [ :item | self assign: item second to: ('control' , item first) asSymbol ]