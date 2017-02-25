accessing
testBlockFor: anObject
	| blocks |
	blocks := Dictionary
		with:
			OPCanvasModel
				-> [ :prg | prg arguments first = self model editor plugin className ]
		with: OPEditor -> [ :prg | prg arguments first = self model plugin className ]
		with:
			OPWorkbenchToolbar
				->
					[ :prg | prg arguments first = self model projectController project className ]
		with:
			OPModelNavigator
				->
					[ :prg | prg arguments first = self model projectController project className ].
	^ blocks at: anObject class