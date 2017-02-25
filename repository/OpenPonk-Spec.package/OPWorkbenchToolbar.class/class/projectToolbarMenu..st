as yet unclassified
projectToolbarMenu: aBuilder
	<opProjectSubmenu>
	| workbenchToolbar |
	workbenchToolbar := aBuilder model.
	(aBuilder group: #ProjectOpening)
		order: 0;
		with: [ (aBuilder item: 'New')
				icon: Smalltalk ui icons smallNew;
				enabled: false;
				order: 1;
				action: [ OPProjectBrowser open ].
			(aBuilder item: 'Open...')
				icon: Smalltalk ui icons smallOpen;
				action: [  ].
			(aBuilder item: 'Save')
				icon: Smalltalk ui icons smallSave;
				action: [ OPSaveProjectWindow new
						projectController: workbenchToolbar projectController;
						open ].
			(aBuilder item: 'Save as...')
				icon: Smalltalk ui icons smallSaveAs;
				action: [  ].
			(aBuilder item: 'Close Project')
				icon: Smalltalk ui icons windowClose;
				action: [  ] ];
		withSeparatorAfter.
	(aBuilder group: #ProjectOptions)
		order: 1000;
		with: [ (aBuilder item: 'Properties...')
				icon: Smalltalk ui icons configuration;
				action: [ workbenchToolbar projectController project maEdit ] ];
		withSeparatorAfter.
	(aBuilder group: #Quit)
		order: 9999;
		with: [ (aBuilder item: 'Exit')
				icon: Smalltalk ui icons smallQuit;
				action: [ workbenchToolbar workbench delete ] ]