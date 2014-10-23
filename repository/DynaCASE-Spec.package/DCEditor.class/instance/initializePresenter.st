initialization
initializePresenter
	textEditorModel doItReceiver: DCTextEditorBindings new.
	textEditorModel doItReceiver view: self canvasModel roassalView.
	self initializeTopMenu.
	self formModel whenAcceptedDo: [ self treeModel updateTree ]