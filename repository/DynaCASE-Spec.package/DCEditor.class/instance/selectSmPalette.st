as yet unclassified
selectSmPalette
	| palette element shape label |
	palette := paletteModel.
	palette
		addGroup: [ :group | 
					group
						name: 'Pseudostates';
						addItem: [ :item | 
									item
										name: 'Initial';
										action: [ 
													element := RTElement new.
													shape := (DCRoassalSmInitialState new)
														size: 25;
														color: Color black.
													element + shape.
													self addElement: element ] ] ];
		addGroup: [ :group | 
					group
						name: 'States';
						addItem: [ :item | 
									item
										name: 'State';
										action: [ 
													element := RTElement new.
													shape := (DCRoassalSmSimpleState new)
														size: 50;
														borderColor: Color black.
													label := (RTLabel new)
														text: 'Label';
														height: 10.
													element + shape.
													element + label.
													self addElement: element ] ];
						addItem: [ :item | 
									item
										name: 'Final state';
										action: [ 
													element := RTElement new.
													shape := (DCRoassalSmFinalState new)
														size: 25;
														color: Color black.
													element + shape.
													self addElement: element ] ] ];
		addGroup: [ :group | 
					group
						name: 'Transitions';
						addItem: [ :item | 
									item
										name: 'Transition';
										action: [ self inform: 'Not implemented' ] ] ]