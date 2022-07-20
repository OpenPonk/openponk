Class {
	#name : #OPEntryCompletionOption,
	#superclass : #EntryCompletion,
	#instVars : [
		'text',
		'subtext'
	],
	#category : #'OpenPonk-Morphic-Polymorph'
}

{ #category : #'as yet unclassified' }
OPEntryCompletionOption class >> withText: aString [

	^ self withText: aString subtext: nil
]

{ #category : #'as yet unclassified' }
OPEntryCompletionOption class >> withText: aString subtext: subtextString [

	^ self new
		  text: aString;
		  subtext: subtextString;
		  yourself
]

{ #category : #accessing }
OPEntryCompletionOption >> subtext [

	^ subtext
]

{ #category : #accessing }
OPEntryCompletionOption >> subtext: anObject [

	subtext := anObject
]

{ #category : #accessing }
OPEntryCompletionOption >> text [

	^ text
]

{ #category : #accessing }
OPEntryCompletionOption >> text: anObject [

	text := anObject
]
