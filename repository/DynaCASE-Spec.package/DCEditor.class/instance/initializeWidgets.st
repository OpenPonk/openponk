initialization
initializeWidgets
	textEditorModel := self newText.
	treeModel := self newTree.
	menuModel := self instantiate: MenuModel.
	formModel := self instantiate: DCDynamicForm.
	canvasModel := self instantiate: DCCanvasModel.
	paletteModel := self instantiate: DCPaletteModel.
	self focusOrder
		add: canvasModel;
		add: paletteModel;
		add: formModel