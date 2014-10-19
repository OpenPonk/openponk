initialization
initializePalette: aPalette editor: anEditor
	| callback transitionCallback |
	callback := [ :class | anEditor selectElementItem: [ self addModelElement: class new ] ].
	transitionCallback := [ 
	anEditor
		selectEdgeItem: [ 
			DCInteractiveLine new
				lineBuilder: [ :fromView :toView | DCRTMultiLine edgeFrom: fromView to: toView ];
				whenCompleted: [ :fromView :toView | 
							| controller from to |
							from := self findControllerByView: fromView.
							to := self findControllerByView: toView.
							controller := self addModelElement: (DCFsmTransition from: from model to: to model).
							self updateView.
							controller ];
				yourself ] ].
	aPalette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ callback value: DCFsmInitialState ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ callback value: DCFsmState ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ callback value: DCFsmFinalState ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: transitionCallback ] ];
		addGroup: [ :group | 
					group
						name: 'Actions';
						addItem: [ :item | 
									item
										name: 'Cancel selection';
										action: [ anEditor cancelSelection ] ] ]