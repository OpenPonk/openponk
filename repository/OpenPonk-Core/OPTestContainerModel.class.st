"
I am a mock representing a tree inner node entity.
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

{ #category : 'initialization' }
OPTestContainerModel >> name [
	^ 'container'
]
