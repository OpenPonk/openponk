Class {
	#name : #OPTabHeaderAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#instVars : [
		'morph'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #factory }
OPTabHeaderAdapter >> buildWidget [

	morph := TabLabelMorph new.
	morph
		roundedCorners: #( 1 4 );
		changeTableLayout;
		listDirection: #leftToRight;
		listCentering: #center;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		label: (self presenter label ifNil: [ '' ]);
		tabSelector: self;
		layoutInset: (morph theme tabLabelInsetFor: self).
	^ morph
]

{ #category : #factory }
OPTabHeaderAdapter >> selectedTab [

	^ morph
]
