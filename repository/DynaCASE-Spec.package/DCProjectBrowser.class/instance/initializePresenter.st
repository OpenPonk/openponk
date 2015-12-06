initialization
initializePresenter
	super initializePresenter.
	recentList
		items: DCProjectStorage default projects;
		displayBlock: [ :each | each name ];
		doubleClickAction: [ recentList selectedItem open ];
		handlesDoubleClick: true;
		menu: [ :menu | self projectMenu: menu ].
	projectNameInput
		autoAccept: true;
		whenTextChanged: [ :newValue | createProjectButton enabled: newValue isNotEmpty ].
	createProjectButton action: [ self createProject ]