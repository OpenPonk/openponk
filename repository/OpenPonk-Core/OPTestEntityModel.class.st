"
I am a mock representing a tree leaf entity.
"
Class {
	#name : #OPTestEntityModel,
	#superclass : #Model,
	#instVars : [
		'uuid'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #comparing }
OPTestEntityModel >> = other [
	^ self uuid = other uuid and: [ self name = other name ]
]

{ #category : #accessing }
OPTestEntityModel >> name [
	^ 'container'
]

{ #category : #accessing }
OPTestEntityModel >> uuid [
	^ uuid ifNil: [ uuid := '6875c7ff-b858-0d00-9c00-47750005dc5d' ]
]

{ #category : #accessing }
OPTestEntityModel >> uuid: aStringOrUUID [
	uuid := aStringOrUUID isString
		ifTrue: [ UUID fromString: aStringOrUUID ]
		ifFalse: [ aStringOrUUID ]
]
