Class {
	#name : #OPRSHandle,
	#superclass : #Object,
	#instVars : [
		'clickBox',
		'line',
		'shape'
	],
	#category : #'OpenPonk-Roassal3-Polyline'
}

{ #category : #accessing }
OPRSHandle >> createClickBoxShape [

	^ RSCircle new
		  size: self size + 4;
		  color: Color transparent;
		  borderColor: Color transparent;
		  yourself
]

{ #category : #accessing }
OPRSHandle >> createShape [
	^ RSEllipse new
		size: self size;
		color: Color blue;
		borderColor: Color black;
		yourself
]

{ #category : #removing }
OPRSHandle >> remove [

	shape remove.
	clickBox remove.
	shape announcer unsubscribe: self.
	clickBox announcer unsubscribe: self.
	line announcer unsubscribe: self.
	shape := nil.
	clickBox := nil.
	line := nil
]

{ #category : #accessing }
OPRSHandle >> shape [
	^ shape
]

{ #category : #accessing }
OPRSHandle >> size [

	^ self subclassResponsibility
]
