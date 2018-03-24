initialization
initializePresenter
	super initializePresenter.
	list
		displayBlock: [ :aModel | adapters displayFor: aModel ];
		icons: [ :aModel | adapters iconFor: aModel ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aModel | self openDiagram: aModel ] ]