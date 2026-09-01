"
Abstract base class for draggable handles used to manipulate control points (routing points) along an edge or path within a Roassal canvas.
"
Class {
	#name : 'OPRSAbstractDraggableControlPointHandle',
	#superclass : 'Object',
	#instVars : [
		'clickBox',
		'line',
		'shape'
	],
	#category : 'OpenPonk-Roassal-Polyline',
	#package : 'OpenPonk-Roassal',
	#tag : 'Polyline'
}

{ #category : 'shapes' }
OPRSAbstractDraggableControlPointHandle >> createClickBoxShape [

	^ RSCircle new
		  size: self size + 4;
		  color: Color transparent;
		  yourself
]

{ #category : 'shapes' }
OPRSAbstractDraggableControlPointHandle >> createShape [

	^ RSEllipse new
		  size: self size;
		  color: Color white;
		  borderDo: [ :b | 
			  b
				  width: 2;
				  color: Color blue ];
		  yourself
]

{ #category : 'actions' }
OPRSAbstractDraggableControlPointHandle >> remove [

	shape remove.
	clickBox remove.
	shape announcer unsubscribe: self.
	clickBox announcer unsubscribe: self.
	line announcer unsubscribe: self.
	line from announcer unsubscribe: self.
	line to announcer unsubscribe: self.
	shape := nil.
	clickBox := nil.
	line := nil
]

{ #category : 'accessing' }
OPRSAbstractDraggableControlPointHandle >> shape [
	^ shape
]

{ #category : 'accessing' }
OPRSAbstractDraggableControlPointHandle >> size [

	^ self subclassResponsibility
]
