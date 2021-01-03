Class {
	#name : #OPCommonElement,
	#superclass : #Object,
	#instVars : [
		'owner',
		'uuid'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPCommonElement >> owner [
	^ owner
]

{ #category : #accessing }
OPCommonElement >> uuid [
	^ uuid ifNil: [ uuid := UUID new ]
]

{ #category : #accessing }
OPCommonElement >> uuid: aUUID [
	uuid := aUUID
]
