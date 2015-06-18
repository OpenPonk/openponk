toolbar
toolbarFor: aGroup
	<DCEditorToolbar: 10000>
	(aGroup addItem: 'Diagram Controller')
		description: 'Inspect Diagram Controller';
		action: [ self diagramController inspect ].

	(self diagramController isMemberOf: DCFsmController)
		ifTrue: [ 
			(aGroup addItem: 'Simulation')
				description: '';
				action: [ DCFsmSimulator new openOn: self diagramController ] ]