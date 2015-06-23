menu
menuCommandOn: aBuilder
	<worldMenu>
	(aBuilder item: #DynaOntoUML)
		icon: DCIcons current dcOmlDiagramIcon;
		label: 'DC OntoUML Editor';
		parent: #MostUsedTools;
		action: [ self exampleEmpty ];
		with: [ 
					(aBuilder item: #DynaOntoExamples)
						parent: #DynaOntoUML;
						label: 'Simple Class Diagram';
						icon: DCIcons current dcOmlDiagramIcon;
						action: [ self exampleDiagram ] ]