accessing
testBlockFor: aModel
	| blocks |
	blocks := Dictionary
		with: OPCanvasModel -> [ :prg | prg arguments first = aModel editor plugin className ]
		with: OPEditor -> [ :prg | prg arguments first = aModel plugin className ]
		with:
			OPWorkbenchToolbar
				-> [ :prg | prg arguments first = aModel projectController project className ]
		with:
			OPModelNavigator
				-> [ :prg | prg arguments first = aModel projectController project className ]
		with:
			OPProjectNavigator
				-> [ :prg | prg arguments first = aModel projectController project className ].
	^ blocks at: aModel class