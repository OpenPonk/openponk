as yet unclassified
selectFsmPalette
	| palette |
	palette := paletteModel.
	palette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ self selectVertexItem: DCFsmInitialState ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ self selectVertexItem: DCFsmState ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ self selectVertexItem: DCFsmFinalState ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ self selectTransitionItem: DCFsmTransition ] ] ]