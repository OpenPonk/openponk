Class {
	#name : #OPEditElementTextCommand,
	#superclass : #OPUICommand,
	#instVars : [
		'get',
		'set',
		'name'
	],
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #'instance creation' }
OPEditElementTextCommand class >> accessor: anAccessor on: anObject [
	^ self new
		accessor: anAccessor;
		on: anObject
]

{ #category : #'instance creation' }
OPEditElementTextCommand class >> executeAccessor: anAccessor on: anObject [
	^ self new
		accessor: anAccessor;
		on: anObject;
		execute
]

{ #category : #accessing }
OPEditElementTextCommand >> accessor: anAccessor [
	self getSelector: anAccessor.
	self setSelector: anAccessor , ':'.
	self name: (anAccessor capitalized splitOnCapitals joinUsing: ' ')
]

{ #category : #execute }
OPEditElementTextCommand >> announceChange [
	model announcer announce: OPElementTextAttributeChanged new
]

{ #category : #execute }
OPEditElementTextCommand >> execute [
	| result |
	result := UIManager default request: name initialAnswer: get value.
	result ifNil: [ ^ self ].
	set value: result.
	self announceChange
]

{ #category : #accessing }
OPEditElementTextCommand >> getSelector: anAccessor [
	self
		get: [ (MessageSend receiver: model selector: anAccessor) value ]
]

{ #category : #initialization }
OPEditElementTextCommand >> initialize [
	super initialize.
	self accessor: #text
]

{ #category : #accessing }
OPEditElementTextCommand >> setSelector: anAccessor [
	self
		set:
			[ :argument | (MessageSend receiver: model selector: anAccessor) value: argument ]
]
