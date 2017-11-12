initialization
initializePresenter
	super initializePresenter.
	tabManager
		whenTabSelected:
			[ :tab | self focusEditorOf: (editors associations detect: [ :pair | pair value second = tab ]) key ]