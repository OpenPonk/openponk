building widgets
createWidgets
	| symbol |
	groups
		do: [ :group | 
			symbol := ('group' , group hash asString) asSymbol.
			self assign: group to: symbol ]