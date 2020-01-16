Class {
	#name : #OPPragmaMenuBuilder,
	#superclass : #PragmaMenuBuilder,
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #'instance creation' }
OPPragmaMenuBuilder class >> cachedPragmaKeyword: aPragmaKeyword model: aModel [
	"Build a builder using aPragmaKeyword as the pragma keyword and aModel a the model of the resulting builder"

	^ (self withAllPragmaKeywords: (Array with: aPragmaKeyword) model: aModel)
		pragmaCollector: (OPPragmaCache current collectorForKeyword: aPragmaKeyword);
		yourself
]

{ #category : #accessing }
OPPragmaMenuBuilder >> pragmaCollector: aCollector [
	self assert: [ pragmaCollector isNil ] description: 'Pragma Collector cannot be changed.'.
	pragmaCollector := aCollector.
"	pragmaCollector whenChangedSend: #reset to: self"
]
