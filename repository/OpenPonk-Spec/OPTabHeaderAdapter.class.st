Class {
	#name : 'OPTabHeaderAdapter',
	#superclass : 'SpAbstractMorphicAdapter',
	#instVars : [
		'morph'
	],
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'factory' }
OPTabHeaderAdapter >> buildWidget [

	morph := OPTabLabelMorph new.
	morph
		roundedCorners: #( 1 4 );
		changeTableLayout;
		listDirection: #leftToRight;
		listCentering: #center;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		label: (self presenter label ifNil: [ '' ]);
		tabSelector: self;
		layoutInset: (morph theme tabLabelInsetFor: self);
		borderStyle: BorderStyle simple.
	^ morph
]

{ #category : 'factory' }
OPTabHeaderAdapter >> selectedTab [

	^ morph
]
