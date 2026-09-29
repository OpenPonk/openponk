"
Unit tests for OPNote. 
Ensures that visual notes are correctly constructed, rendered, and initialized without an underlying structural domain model.
"
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

{ #category : 'running' }
OPNoteTest >> testEmpty [

	self skip
]
