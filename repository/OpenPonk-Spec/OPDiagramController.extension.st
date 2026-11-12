Extension { #name : 'OPDiagramController' }

{ #category : '*OpenPonk-Spec' }
OPDiagramController >> roassalShapeContextClicked: anEvent [

	| shapes menu |
	shapes := (self selectedElements includes: anEvent shape)
		          ifTrue: [ self selectedElements ]
		          ifFalse: [ { anEvent shape } ].
	menu := CmdContextMenuActivation
		        buildContextMenuFor: self canvasPresenter
		        inContext:
		        (OPRoassalShapeContext for: self canvasPresenter of: shapes).
	menu popUpInWorld
]
