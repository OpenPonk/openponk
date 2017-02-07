initialization
initialize
	items := OrderedCollection new.
	selectedItem := nil.
	selectedTool := nil.
	super initialize.
	self bindKeyCombination: Character escape toAction: [ self selectSelectionTool ]