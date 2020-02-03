Class {
	#name : #OPMementoFileSerializer,
	#superclass : #OPMementoSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPMementoFileSerializer >> formatName [
	^ 'opp'
]

{ #category : #saving }
OPMementoFileSerializer >> loadMementoFrom: aFile [
	^ aFile readStreamDo: [ :stream | self materializeFrom: stream ]
]

{ #category : #saving }
OPMementoFileSerializer >> materializeFrom: aStream [
	^ self subclassResponsibility
]

{ #category : #saving }
OPMementoFileSerializer >> saveMemento: aMemento to: aFile [
	aFile
		writeStreamDo: [ :stream | self serialize: aMemento to: stream ]
]

{ #category : #saving }
OPMementoFileSerializer >> serialize: anObject to: aStream [
	self subclassResponsibility
]
