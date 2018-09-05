initialization
initializePresenter
	super initializePresenter.
	list
		displayBlock: [ :aView | self displayFor: aView ];
		icons: [ :aView | adapters iconFor: aView model ];
		doubleClickAction: [ list selectedItem ifNotNil: [ :aView | self openView: aView ] ];
		menu: [ :menu | self contextMenu: menu for: list selectedItem ]