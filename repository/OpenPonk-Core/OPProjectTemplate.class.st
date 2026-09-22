Class {
	#name : 'OPProjectTemplate',
	#superclass : 'Object',
	#instVars : [
		'name',
		'icon',
		'modelFactory',
		'isExample'
	],
	#category : 'OpenPonk-Core-Templates',
	#package : 'OpenPonk-Core',
	#tag : 'Templates'
}

{ #category : 'instance creation' }
OPProjectTemplate class >> named: aString icon: anIcon modelFactory: aBlockClosure [
	"Answers a new template with default isExample setting to false."

	^ self
		named: aString
		icon: anIcon
		modelFactory: aBlockClosure
		isExample: false
]

{ #category : 'instance creation' }
OPProjectTemplate class >> named: aString icon: anIcon modelFactory: aBlockClosure isExample: aBoolean [
	"Answers a fully initialized project template descriptor."

	^ self new
		name: aString;
		icon: anIcon;
		modelFactory: aBlockClosure;
		isExample: aBoolean;
		yourself
]

{ #category : 'comparing' }
OPProjectTemplate >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ self name = anObject name and: [ self isExample = anObject isExample ]
]

{ #category : 'factory' }
OPProjectTemplate >> createModel [
	"Instantiates and returns a new model using the configured factory block."

	^ modelFactory cull: self name
]

{ #category : 'comparing' }
OPProjectTemplate >> hash [
	^ self name hash bitXor: self isExample hash
]

{ #category : 'accessing' }
OPProjectTemplate >> icon [
	"Answers the visual icon representing the template."

	^ icon
]

{ #category : 'accessing' }
OPProjectTemplate >> icon: anIcon [
	"Sets the visual icon representing the template."

	icon := anIcon
]

{ #category : 'accessing' }
OPProjectTemplate >> isExample [
	"Answers true if the template represents a populated demo model, false if it is an empty model."

	^ isExample ifNil: [ false ]
]

{ #category : 'accessing' }
OPProjectTemplate >> isExample: aBoolean [
	"Sets whether the template represents a populated demo model."

	isExample := aBoolean
]

{ #category : 'accessing' }
OPProjectTemplate >> modelFactory [
	"Answers the factory block closure responsible for instantiating the model."

	^ modelFactory
]

{ #category : 'accessing' }
OPProjectTemplate >> modelFactory: aBlockClosure [
	"Sets the factory block closure responsible for instantiating the model."

	modelFactory := aBlockClosure
]

{ #category : 'accessing' }
OPProjectTemplate >> name [
	"Answers the human-readable title of the template."

	^ name
]

{ #category : 'accessing' }
OPProjectTemplate >> name: aString [
	"Sets the human-readable title of the template."

	name := aString
]

{ #category : 'printing' }
OPProjectTemplate >> printOn: aStream [
	"Appends a string representation to the stream."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (name ifNil: [ 'unnamed' ]);
		nextPut: $)
]
