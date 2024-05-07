Class {
	#name : 'OPTestAbstractModel',
	#superclass : 'Model',
	#instVars : [
		'uuid'
	],
	#category : 'OpenPonk-Core-Controllers - Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers - Tests'
}

{ #category : 'comparing' }
OPTestAbstractModel >> = other [
	^ self uuid = other uuid and: [ self name = other name ]
]

{ #category : 'accessing' }
OPTestAbstractModel >> name [
	^ 'container'
]

{ #category : 'accessing' }
OPTestAbstractModel >> uuid [
	^ uuid ifNil: [ uuid := '6875c7ff-b858-0d00-9c00-47750005dc5d' ]
]

{ #category : 'accessing' }
OPTestAbstractModel >> uuid: aStringOrUUID [
	uuid := aStringOrUUID isString
		ifTrue: [ UUID fromString: aStringOrUUID ]
		ifFalse: [ aStringOrUUID ]
]
