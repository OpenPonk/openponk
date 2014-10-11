initialization
initializeWidgets
	textEditorModel := self newText.
	statusModel := self newLabel.
	treeModel := self newTree.
	formModel := self instantiate: DCDynamicForm.
	roassalModel := self instantiate: RoassalModel.
	paletteModel := self instantiate: DCPaletteModel.
	self cancelSelection.
	self focusOrder
		add: roassalModel;
		add: paletteModel;
		add: formModel;
		add: statusModel