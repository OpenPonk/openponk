initialization
initializePalette: aPalette editor: anEditor
	aPalette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ anEditor selectElementItem: DCFsmInitialState ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ anEditor selectElementItem: DCFsmState ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ anEditor selectElementItem: DCFsmFinalState ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ anEditor selectEdgeItem: DCFsmTransition ] ] ];
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