initialization
initializePresenter
	super initializePresenter.
	list
		displayBlock: [ :aModel | self displayFor: aModel ];
		icons: [ :aModel | self iconFor: aModel ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aModel | self openDiagram: aModel ] ]