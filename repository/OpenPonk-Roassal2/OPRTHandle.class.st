"
I am a handle for DCRTConnection.
"
Class {
	#name : #OPRTHandle,
	#superclass : #Object,
	#instVars : [
		'edge',
		'element',
		'clickBox'
	],
	#category : #'OpenPonk-Roassal2-Connection'
}

{ #category : #accessing }
OPRTHandle >> clickBoxShape [

	^ RTEllipse new
		  size: self size + 4;
		  color: Color transparent;
		  borderColor: Color transparent;
		  yourself
]

{ #category : #accessing }
OPRTHandle >> element [
	^ element
]

{ #category : #removing }
OPRTHandle >> remove [

	element remove.
	clickBox remove.
	element := nil.
	clickBox := nil.
	edge := nil
]

{ #category : #accessing }
OPRTHandle >> shape [
	^ RTEllipse new
		size: self size;
		color: [ :e | e shape colorFor: e ];
		borderColor: Color black;
		yourself
]

{ #category : #accessing }
OPRTHandle >> size [

	^ self subclassResponsibility
]
