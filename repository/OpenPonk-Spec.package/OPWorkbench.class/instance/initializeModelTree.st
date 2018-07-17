initialization
initializeModelTree
	| modelTreeTab projectTreeTab |
	(modelTreeTab := self newTab)
		label: 'Model Tree';
		icon: nil;
		retrievingBlock: [ (modelTreeWidget buildWithSpec: #withoutHeadingSpec) asWidget ].
	(projectTreeTab := self newTab)
		label: 'Project Tree';
		icon: nil;
		retrievingBlock: [ (navigatorModel buildWithSpec: #withoutHeadingSpec) asWidget ].
	modelTree
		addTab: modelTreeTab;
		addTab: projectTreeTab