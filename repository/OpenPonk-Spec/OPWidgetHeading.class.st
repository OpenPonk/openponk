Class {
	#name : #OPWidgetHeading,
	#superclass : #Object,
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #'instance creation' }
OPWidgetHeading class >> forLabel: aLabel [
	^ self new forLabel: aLabel
]

{ #category : #'instance creation' }
OPWidgetHeading >> forLabel: aString [
	^ (TabMorph label: aString icon: nil morph: nil)
		closeable: false;
		selected: true;
		hResizing: #spaceFill;
		asSpecAdapter
]
