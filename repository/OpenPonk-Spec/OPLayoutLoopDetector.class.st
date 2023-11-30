Class {
	#name : #OPLayoutLoopDetector,
	#superclass : #Object,
	#instVars : [
		'boxes',
		'links',
		'processedBoxes'
	],
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #actions }
OPLayoutLoopDetector class >> haveLoopsBoxes: boxes links: links [

	^ self new
		  boxes: boxes;
		  links: links;
		  haveLoops
]

{ #category : #actions }
OPLayoutLoopDetector class >> popupHaveLoopsBoxes: boxes links: links [

	^ self new
		  boxes: boxes;
		  links: links;
		  popupHaveLoops
]

{ #category : #accessing }
OPLayoutLoopDetector >> boxes [

	^ boxes
]

{ #category : #accessing }
OPLayoutLoopDetector >> boxes: anObject [

	boxes := Array withAll: anObject
]

{ #category : #'as yet unclassified' }
OPLayoutLoopDetector >> hasBox: box loopsBackTo: loopsTo [

	| toBoxes |
	(processedBoxes includes: box) ifTrue: [ ^ false ].

	toBoxes := (links
		            select: [ :each | each from = box ]
		            thenCollect: [ :each | each to ]) intersection: boxes.

	processedBoxes add: box.

	^ toBoxes anySatisfy: [ :any |
		  (loopsTo includes: any) or: [
			  self hasBox: any loopsBackTo: loopsTo , { box } ] ]
]

{ #category : #'as yet unclassified' }
OPLayoutLoopDetector >> haveLoops [

	^ boxes anySatisfy: [ :box | self hasBox: box loopsBackTo: Set new ]
]

{ #category : #initialization }
OPLayoutLoopDetector >> initialize [

	super initialize.

	links := Set new.
	boxes := Array new.
	processedBoxes := Set new
]

{ #category : #accessing }
OPLayoutLoopDetector >> links [

	^ links
]

{ #category : #accessing }
OPLayoutLoopDetector >> links: anObject [

	links addAll: anObject
]

{ #category : #'as yet unclassified' }
OPLayoutLoopDetector >> popupHaveLoops [

	^ self haveLoops
		  ifTrue: [
			  (GrowlMorph
				   label: 'Failed to lay out'
				   contents:
					   'OpenPonk failed to lay out shapes. Using simple grid layout...')
				  backgroundColor: GrowlMorph theme warningBackgroundColor;
				  labelColor: GrowlMorph theme textColor;
				  textColor: GrowlMorph theme textColorForNonStandardBackground;
				  openInWorld.
			  ^ true ]
		  ifFalse: [ false ]
]
