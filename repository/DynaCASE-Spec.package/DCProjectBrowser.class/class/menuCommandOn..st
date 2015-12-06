world menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #DynaCASE)
		icon: DCIcons current dynacaseIcon;
		parent: #MostUsedTools;
		withSeparatorAfter;
		action: [ self open ]