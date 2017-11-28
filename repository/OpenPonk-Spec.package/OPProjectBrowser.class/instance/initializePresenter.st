initialization
initializePresenter
	super initializePresenter.
	recentList
		items: OPProjectStorage default projects;
		displayBlock: [ :each | each name ];
		doubleClickAction: [ self openProjectFromFile: recentList selectedItem storageFile ];
		handlesDoubleClick: true;
		menu: [ :menu | self projectMenu: menu for: recentList selectedItem ].
	projectNameInput
		autoAccept: true;
		whenTextChanged: [ :newValue | createProjectButton enabled: newValue isNotEmpty ].
	createProjectButton action: [ self createProject ].
	openProjectButton action: [ self openProjectFromFile ]