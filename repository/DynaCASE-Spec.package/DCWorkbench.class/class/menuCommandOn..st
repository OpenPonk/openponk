menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #'DynaCASE example OntoUML')
		parent: #MostUsedTools;
		action: [ self exampleOntoUml ].
	(aBuilder item: #'DynaCASE example FSM')
		parent: #MostUsedTools;
		action: [ self exampleFsm ].
	(aBuilder item: #'DynaCASE example Umlite')
		parent: #MostUsedTools;
		action: [ self exampleUmlite ]