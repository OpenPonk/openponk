Class {
	#name : 'OPNoteTest',
	#superclass : 'OPAbstractNodeTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'instance creation' }
OPNoteTest >> newModelInstance [

	^ nil
]

{ #category : 'hooks' }
OPNoteTest >> shapeClass [
	^ OPNote
]

{ #category : 'instance creation' }
OPNoteTest >> testEmpty [

	self skip
]
