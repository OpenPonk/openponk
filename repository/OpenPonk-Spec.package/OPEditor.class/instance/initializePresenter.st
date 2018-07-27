initialization
initializePresenter
	| menu |
	menu := OPDiagramToolbarActivation
		buildMenuInContext: (CmdSimpleToolContext for: canvasModel).
	menu buildSpecMenuOn: canvasMenuModel