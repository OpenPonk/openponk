Extension { #name : #GLMMorphicRenderer }

{ #category : #'*OpenPonk-UI' }
GLMMorphicRenderer >> renderOPActionListPresentation: anActionListPresentation [ 
	^OPGLMMorphicActionListRenderer render: anActionListPresentation from: self
]
