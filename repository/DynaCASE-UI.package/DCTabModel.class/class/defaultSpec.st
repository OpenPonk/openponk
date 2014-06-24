specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						newRow: [ :mainRow | 
							mainRow
								newColumn: [ :leftCol | 
											leftCol
												newRow: [ :row | row add: #canvasMorph ];
												newRow: [ :row | row add: #statusText ] ]
									width: 600;
								newColumn: [ :rightCol | 
											rightCol
												newRow: [ :row | row add: #paletteModel ];
												newRow: [ :row | row add: #formModel ] ] ] ];
		yourself