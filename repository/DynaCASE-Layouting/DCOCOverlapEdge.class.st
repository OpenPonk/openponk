Class {
	#name : 'DCOCOverlapEdge',
	#superclass : 'DCGTEdge',
	#instVars : [
		'routes'
	],
	#category : 'DynaCASE-Layouting-OCR',
	#package : 'DynaCASE-Layouting',
	#tag : 'OCR'
}

{ #category : 'accessing' }
DCOCOverlapEdge >> routes [
	^ routes
]

{ #category : 'accessing' }
DCOCOverlapEdge >> routes: anObject [
	routes := anObject
]
