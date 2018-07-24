initialization
initializePresenter
	super initializePresenter.
	list
		displayBlock: [ :aView | adapters displayFor: aView model ];
		icons: [ :aView | adapters iconFor: aView model ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aView | self openView: aView ] ]