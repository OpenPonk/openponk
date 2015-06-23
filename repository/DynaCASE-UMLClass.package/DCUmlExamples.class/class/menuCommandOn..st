menu
menuCommandOn: aBuilder
	"<worldMenu>"
	(aBuilder item: #DynaUML)
		icon: DCIcons current dcOmlDiagramIcon;
		label: 'UML Class Diagram';
		parent: #MostUsedTools;
		action: [ self openEmpty ];
		with: [ 
					(aBuilder item: #DynaUMLExamples)
						parent: #DynaUML;
						label: 'Simple Class Diagram';
						icon: DCIcons current dcOmlDiagramIcon;
						action: [ self exampleSimple ] ]