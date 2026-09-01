"
Mock view model for OPTestRelationModel. 
Used exclusively for testing relationship handler logic and domain model attachment.
"
Class {
	#name : 'OPTestRelationViewModel',
	#superclass : 'OPTestModelViewModel',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestRelationViewModel class >> modelClass [
    ^ OPTestRelationModel
]

{ #category : 'construction' }
OPTestRelationViewModel >> attachModelFrom: sourceViewModel to: targetViewModel [
	self model source: sourceViewModel model.
	self model target: targetViewModel model.
]

{ #category : 'private' }
OPTestRelationViewModel >> basicRemoveModel [
	self modelRootViewModel model entities remove: self model ifAbsent: [ ]
]

{ #category : 'accessing' }
OPTestRelationViewModel >> modelSource [

	^ self model source
]

{ #category : 'accessing' }
OPTestRelationViewModel >> modelTarget [

	^ self model target
]
