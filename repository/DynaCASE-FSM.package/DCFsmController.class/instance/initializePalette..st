initialization
initializePalette: aPalette
	aPalette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ self activateItem: item ];
										createElement: [ 
													| controller |
													controller := DCFsmInitialStateController new.
													controller createView value ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ self activateItem: item ];
										createElement: [ 
													| controller |
													controller := DCFsmStateController new.
													controller createView value ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ self activateItem: item ];
										createElement: [ 
													| controller |
													controller := DCFsmFinalStateController new.
													controller createView value ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									| fromElement |
									fromElement := nil.
									item
										name: 'Transition';
										action: [ 
													fromElement := nil.
													self activateItem: item ];
										createElement: [ :element | 
													| controller |
													controller := nil.
													fromElement
														ifNil: [ fromElement := element ]
														ifNotNil: [ 
															controller := DCFsmTransitionController new.
															controller createView value: fromElement value: element ].
													controller ] ] ]