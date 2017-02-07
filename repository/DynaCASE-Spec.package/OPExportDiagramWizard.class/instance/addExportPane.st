adding
addExportPane
	| pane |
	pane := WizardSinglePane new.
	pane name: 'Save diagram to a *.png file'.
	pane
		addPart:
			(SaveChooseFilePart new
				validExtensions: #(png);
				yourself)
		associatedTo: #targetFile.
	"pane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Heading';
				defaultValue: [ :args | modelName ];
				suffix: 'Added heading to the top left corner')
		associatedTo: #diagramName."
	self addPane: pane