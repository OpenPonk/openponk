Extension { #name : #GLMMorphicRenderer }

{ #category : #'*OpenPonk-Spec' }
GLMMorphicRenderer >> renderOPCherryPickTreePresentation: aPresentation [ 
	^ OPGLMMorphicCherryPickTreeRenderer render: aPresentation from: self
]
