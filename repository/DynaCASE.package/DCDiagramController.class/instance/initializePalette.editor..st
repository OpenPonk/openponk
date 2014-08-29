initialization
initializePalette: aPalette editor: anEditor
	aPalette
		addGroup: [ :group | 
					group
						name: 'Class';
						addItem: [ :item | 
									item
										name: 'Class';
										action: [ anEditor selectVertexItem: DCUmlClass ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ anEditor selectTransitionItem: DCUmlAssociation ] ] ];
		addGroup: [ :group | 
					group
						name: 'Actions';
						addItem: [ :item | 
									item
										name: 'Cancel selection';
										action: [ 
													anEditor cancelSelection.
													anEditor statusModel text: '' ] ] ]