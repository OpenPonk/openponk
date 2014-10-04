as yet unclassified
initializePalette: aPalette editor: anEditor
	aPalette
		addGroup: [ :group | 
					group
						name: 'Class';
						addItem: [ :item | 
									item
										name: 'Class';
										action: [ anEditor selectElementItem: DCUmliteClass ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ anEditor selectEdgeItem: DCUmliteAssociation ] ] ];
		addGroup: [ :group | 
					group
						name: 'Actions';
						addItem: [ :item | 
									item
										name: 'Cancel selection';
										action: [ anEditor cancelSelection ] ];
						addItem: [ :item | 
									item
										name: 'Delete';
										action: [ anEditor selectDelete ] ] ]