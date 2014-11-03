menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #'DynaCASE exampleFsm')
		parent: #MostUsedTools;
		action: [ self exampleFsm ].
	(aBuilder item: #'DynaCASE exampleUmlite')
		parent: #MostUsedTools;
		action: [ self exampleUmlite ]