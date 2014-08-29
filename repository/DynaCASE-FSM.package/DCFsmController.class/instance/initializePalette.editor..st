initialization
initializePalette: aPalette editor: anEditor
	aPalette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ anEditor selectVertexItem: DCFsmInitialState ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ anEditor selectVertexItem: DCFsmState ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ anEditor selectVertexItem: DCFsmFinalState ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ anEditor selectTransitionItem: DCFsmTransition ] ] ];
		addGroup: [ :group | 
					group
						name: 'Actions';
						addItem: [ :item | 
									item
										name: 'Cancel selection';
										action: [ 
													anEditor cancelSelection.
													anEditor statusModel text: '' ] ] ]