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

{ #category : 'private' }
OPTestContainerViewModel >> basicRemoveModel [
	"Do nothing, container is root"
]
