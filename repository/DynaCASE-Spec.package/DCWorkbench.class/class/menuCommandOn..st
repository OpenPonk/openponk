menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #'DynaCASE example1')
		parent: #MostUsedTools;
		action: [ self example1 ].
	(aBuilder item: #'DynaCASE example3')
		parent: #MostUsedTools;
		action: [ self example3 ]