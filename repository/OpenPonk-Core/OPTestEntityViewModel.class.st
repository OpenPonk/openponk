"
Mock view model for OPTestEntityModel. 
Used exclusively for testing view model behavior and registry mapping.
"
Class {
	#name : 'OPTestEntityViewModel',
	#superclass : 'OPTestModelViewModel',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestEntityViewModel class >> modelClass [
    ^ OPTestEntityModel
]

{ #category : 'private' }
OPTestEntityViewModel >> basicRemoveModel [

	self modelRootViewModel model entities
		remove: self model
		ifAbsent: [ ]
]
