building widgets
createWidgets
	self instantiateModels: #(#label #LabelModel).
	self label label: self name.
	items do: [ :item | self assign: item to: ('button' , item hash asString) asSymbol ]