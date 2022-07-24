Class {
	#name : #OPAsyncTextInputFieldPresenter,
	#superclass : #SpTextInputFieldPresenter,
	#instVars : [
		'entryCompletionFilter',
		'entriesByText',
		'monitor'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #'private - completion' }
OPAsyncTextInputFieldPresenter >> askSourceForCompletionOptionsFor: aString [

	| options |
	options := entryCompletionFilter value: aString.
	entriesByText at: aString put: options.

	monitor critical: [ 
		self text trimBoth = aString ifFalse: [ ^ self ].
		self adapter widget openChooser ]
]

{ #category : #accessing }
OPAsyncTextInputFieldPresenter >> entryCompletionFilter: aBlock [

	"The block accepts filled trimmed text and should return sequencable collection of OPEntryCompletionOption"

	entryCompletionFilter := aBlock.
	entriesByText := Dictionary new.
	self entryCompletion:
		(OPEntryCompletion new dataSourceBlock: [ :filledText | 
			 self findCompletionOptionsFor: filledText ])
]

{ #category : #'private - completion' }
OPAsyncTextInputFieldPresenter >> findCompletionOptionsFor: aString [

	| filledName |
	filledName := aString asString trimBoth.
	((filledName splitOn: Character space) noneSatisfy: [ :any | 
		 any trimBoth size >= 2 ]) ifTrue: [ ^ #(  ) ].
	^ entriesByText
		  at: filledName
		  ifPresent: [ :options | options ifNil: [ #(  ) ] ]
		  ifAbsent: [ 
			  entriesByText at: filledName put: nil.
			  [ self askSourceForCompletionOptionsFor: filledName ]
				  forkAt: Processor userBackgroundPriority
				  named: 'OpenPonk entry completion'.
			  #(  ) ]
]

{ #category : #initialization }
OPAsyncTextInputFieldPresenter >> initialize [

	super initialize.
	monitor := Monitor new
]

{ #category : #accessing }
OPAsyncTextInputFieldPresenter >> text: aString [

	"Set the text of the text presenter"

	monitor critical: [ text := aString ]
]
