Class {
	#name : 'OPTabHeaderPresenter',
	#superclass : 'SpLabelPresenter',
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'specs' }
OPTabHeaderPresenter class >> adapterName [

	^ #OPTabHeaderAdapter
]

{ #category : 'examples' }
OPTabHeaderPresenter class >> example [

	"This example opens a spec window with a label."

	^ self new
		  label: 'Tab header example';
		  open
]

{ #category : 'instance creation' }
OPTabHeaderPresenter class >> labelled: aString [

	^ self new
		  label: aString;
		  yourself
]

{ #category : 'specs' }
OPTabHeaderPresenter class >> title [

	^ 'Tab header'
]
