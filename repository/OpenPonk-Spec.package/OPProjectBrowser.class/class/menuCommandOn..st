world menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #OpenPonk)
		icon: OPIcons current dynacaseIcon;
		parent: #MostUsedTools;
		withSeparatorAfter;
		action: [ self open ]