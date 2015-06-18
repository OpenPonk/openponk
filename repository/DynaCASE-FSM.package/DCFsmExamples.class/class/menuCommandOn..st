menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #'DC Finite State Machine')
		icon: DCIcons current dcFsmDiagramIcon;
		parent: #MostUsedTools;
		action: [ self exampleEmpty ];
		with: [ 
					(aBuilder item: #'FSM Example')
						parent: #'DC Finite State Machine';
						label: 'FSM Example Divisibility';
						icon: DCIcons current dcFsmDiagramIcon;
						action: [ self exampleDivisibility ] ]