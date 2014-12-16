initialization
initializePresenter
	textEditorModel doItReceiver: DCTextEditorBindings new.
	textEditorModel doItReceiver view: self canvasModel roassalView.
	self initializeCanvasMenu