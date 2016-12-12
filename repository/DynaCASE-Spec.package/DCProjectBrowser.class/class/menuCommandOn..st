world menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #OpenPonk)
		icon: DCIcons current dynacaseIcon;
		parent: #MostUsedTools;
		withSeparatorAfter;
		action: [ self open ]