toolbar
toolbarFor: aGroup
	<DCEditorToolbar: 10000>
	(aGroup addItem: 'Diagram Controller')
		description: 'Inspect Diagram Controller';
		action: [ self diagramController inspect ].

	self plugin className asSymbol = #DCUmlClassPlugin
		ifTrue:
			[ (aGroup addItem: 'Generate Code')
				description: 'Generate Code';
				action:
						[ DCUmlCodeGeneratorWindow new
						model: self diagramController model;
						openWithSpec ] ].

	plugin toolbarForEditor: self inGroup: aGroup