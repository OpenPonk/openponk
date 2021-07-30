"
I am the default serializer and do nothing at all.
"
Class {
	#name : #OPNullSerializer,
	#superclass : #OPMementoFileSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPNullSerializer >> formatName [
	^ 'opp'
]

{ #category : #saving }
OPNullSerializer >> loadMementoFrom: aFile [
	^ nil
]

{ #category : #saving }
OPNullSerializer >> materializeFrom: aStream [
	^ nil
]

{ #category : #saving }
OPNullSerializer >> saveMemento: aMemento to: aFile [
	"do nothing"
]

{ #category : #saving }
OPNullSerializer >> serialize: anObject to: aStream [
	"do nothing"
]
