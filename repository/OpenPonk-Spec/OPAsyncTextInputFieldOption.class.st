Class {
	#name : #OPAsyncTextInputFieldOption,
	#superclass : #Object,
	#instVars : [
		'name',
		'description'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #'instance creation' }
OPAsyncTextInputFieldOption class >> named: aName description: aDescription [

	^ self new
		  name: aName;
		  description: aDescription;
		  yourself
]

{ #category : #accessing }
OPAsyncTextInputFieldOption >> description [

	^ description
]

{ #category : #accessing }
OPAsyncTextInputFieldOption >> description: anObject [

	description := anObject
]

{ #category : #accessing }
OPAsyncTextInputFieldOption >> name [

	^ name
]

{ #category : #accessing }
OPAsyncTextInputFieldOption >> name: anObject [

	name := anObject
]
