Class {
	#name : #OPTestModel,
	#superclass : #Model,
	#instVars : [
		'uuid'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #comparing }
OPTestModel >> = other [
	^ self uuid = other uuid and: [ self name = other name ]
]

{ #category : #accessing }
OPTestModel >> name [
	^ 'container'
]

{ #category : #accessing }
OPTestModel >> uuid [
	^ uuid ifNil: [ uuid := '6875c7ff-b858-0d00-9c00-47750005dc5d' ]
]

{ #category : #accessing }
OPTestModel >> uuid: aStringOrUUID [
	uuid := aStringOrUUID isString
		ifTrue: [ UUID fromString: aStringOrUUID ]
		ifFalse: [ aStringOrUUID ]
]
