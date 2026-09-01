"
Mock domain model representing a container (inner node) holding child entities. 
Used exclusively for unit and integration testing.
"
Class {
	#name : 'OPTestContainerModel',
	#superclass : 'OPTestAbstractModel',
	#instVars : [
		'entities'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestContainerModel >> add: anEntity [

	^ entities add: anEntity
]

{ #category : 'accessing' }
OPTestContainerModel >> allElements [

	^ self entities
]

{ #category : 'accessing' }
OPTestContainerModel >> entities [
	^ entities
]

{ #category : 'initialization' }
OPTestContainerModel >> initialize [
	super initialize.
	entities := OrderedCollection new
]

{ #category : 'accessing' }
OPTestContainerModel >> name [
	^ 'container'
]
