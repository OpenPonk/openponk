Class {
	#name : 'DCRTLPosition',
	#superclass : 'Object',
	#instVars : [
		'ranking',
		'maxRanking',
		'position',
		'orientation',
		'bounds',
		'mark',
		'feature'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels',
	#package : 'DynaCASE-Layouting',
	#tag : 'GlobalEdgeLabels'
}

{ #category : 'accessing' }
DCRTLPosition >> bounds [
	^ bounds
]

{ #category : 'accessing' }
DCRTLPosition >> bounds: aRectangle [
	bounds := aRectangle
]

{ #category : 'accessing' }
DCRTLPosition >> center [
	^ self bounds center
]

{ #category : 'accessing' }
DCRTLPosition >> feature [
	^ feature
]

{ #category : 'accessing' }
DCRTLPosition >> feature: anObject [
	feature := anObject
]

{ #category : 'accessing' }
DCRTLPosition >> height [
	^ self bounds height
]

{ #category : 'accessing' }
DCRTLPosition >> mark [
	^ mark
]

{ #category : 'accessing' }
DCRTLPosition >> mark: aPoint [
	mark := aPoint
]

{ #category : 'accessing' }
DCRTLPosition >> maxRanking [
	^ maxRanking
]

{ #category : 'accessing' }
DCRTLPosition >> maxRanking: aNumber [
	maxRanking := aNumber
]

{ #category : 'accessing' }
DCRTLPosition >> orientation [
	^ orientation
]

{ #category : 'accessing' }
DCRTLPosition >> orientation: aSymbol [
	"#topLeft, #topRight, #bottomLeft, #bottomRight"
	orientation := aSymbol
]

{ #category : 'accessing' }
DCRTLPosition >> position [
	^ position
]

{ #category : 'accessing' }
DCRTLPosition >> position: aPoint [
	position := aPoint
]

{ #category : 'accessing' }
DCRTLPosition >> ranking [
	^ ranking
]

{ #category : 'accessing' }
DCRTLPosition >> ranking: aNumber [
	ranking := aNumber
]

{ #category : 'accessing' }
DCRTLPosition >> ranking: aNumber of: aMax [
	ranking := aNumber.
	maxRanking := aMax
]

{ #category : 'accessing' }
DCRTLPosition >> width [
	^ self bounds width
]
