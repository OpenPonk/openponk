Class {
	#name : #OPEntryCompletion,
	#superclass : #EntryCompletion,
	#instVars : [
		'lastChosen'
	],
	#category : #'OpenPonk-Morphic-Polymorph'
}

{ #category : #'as yet unclassified' }
OPEntryCompletion >> choose: aToken [

	lastChosen := aToken.
	super choose: aToken
]

{ #category : #accessing }
OPEntryCompletion >> chooserWith: aToken [

	aToken = lastChosen ifTrue: [ ^ chooser ].
	^ super chooserWith: aToken
]

{ #category : #initialization }
OPEntryCompletion >> initialize [

	super initialize.
	lastChosen := ''
]

{ #category : #initialization }
OPEntryCompletion >> setChooserWith: aToken labels: labels [
	chooser 
		ifNil: [chooser := OPIdentifierChooserMorph 
							labels: labels
							chooseBlock: [:option | self choose: option text ].
					chooser on: #keyStroke send: #keystrokeInChooser: to: self].
	^ chooser
]
