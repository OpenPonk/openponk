"
Minimal concrete node test double subclassing OPNode directly without OPBoundNode bounds storage.
"
Class {
	#name : 'OPTestNode',
	#superclass : 'OPNode',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'rendering' }
OPTestNode >> renderBasicShape [

	^ RSBox new
		  size: 40 @ 25;
		  yourself
]
