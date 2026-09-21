"
Mock view model for OPTestContainerModel. 
Used exclusively for testing the view model hierarchy and lifecycle operations.
"
Class {
	#name : 'OPTestContainerViewModel',
	#superclass : 'OPTestModelViewModel',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestContainerViewModel class >> modelClass [
    ^ OPTestContainerModel
]

{ #category : 'removing' }
OPTestContainerViewModel >> basicRemoveModel [

	self parentContainerModel ifNotNil: [ :parentContainer |
		(parentContainer respondsTo: #removeModel:)
			ifTrue: [ parentContainer removeModel: self model ]
			ifFalse: [
				(parentContainer respondsTo: #remove:)
					ifTrue: [ parentContainer remove: self model ] ] ]
]
