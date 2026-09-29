"
Null Object implementation of a Roassal interaction. 
Performs no actions when attached to a shape, serving as a safe default or placeholder.
"
Class {
	#name : 'OPRSNoInteraction',
	#superclass : 'RSInteraction',
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'hooks' }
OPRSNoInteraction >> onShape: aShape [
	"do nothing"
]
