Class {
	#name : #OPLabel,
	#superclass : #OPBoundNode,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #'ston-core' }
OPLabel class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #text )
]

{ #category : #accessing }
OPLabel >> defaultFontColor [

	^ Color black
]

{ #category : #accessing }
OPLabel >> defaultFontName [

	^ RSLabel defaultFont familyName
]

{ #category : #accessing }
OPLabel >> defaultFontSize [

	^ 10
]

{ #category : #accessing }
OPLabel >> defaultText [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPLabel >> emphasis [

	^ self stylesEmphasis
]

{ #category : #accessing }
OPLabel >> fontColor [

	^ self
		  stylePropertyNamed: #fontColor
		  ifAbsent: [ self defaultFontColor ]
]

{ #category : #accessing }
OPLabel >> fontName [

	^ self
		  stylePropertyNamed: #fontName
		  ifAbsent: [ self defaultFontName ]
]

{ #category : #accessing }
OPLabel >> fontSize [

	^ self
		  stylePropertyNamed: #fontSize
		  ifAbsent: [ self defaultFontSize ]
]

{ #category : #testing }
OPLabel >> isResizableByUser [

	^ false
]

{ #category : #accessing }
OPLabel >> noText [

	self text: ''
]

{ #category : #rendering }
OPLabel >> renderBasicShape [

	^ RSLabel new
		  text: self text;
		  yourself
]

{ #category : #accessing }
OPLabel >> resetText [

	self text: nil
]

{ #category : #accessing }
OPLabel >> stylesEmphasis [

	| emphasis |
	emphasis := TextEmphasis normal.
	(self stylePropertyNamed: #fontBold ifAbsent: [ false ]) ifTrue: [ 
		emphasis add: TextEmphasis bold ].
	(self stylePropertyNamed: #fontItalic ifAbsent: [ false ]) ifTrue: [ 
		emphasis add: TextEmphasis italic ].
	(self stylePropertyNamed: #fontStrikeThrough ifAbsent: [ false ]) 
		ifTrue: [ emphasis add: TextEmphasis struckOut ].
	(self stylePropertyNamed: #fontUnderline ifAbsent: [ false ]) 
		ifTrue: [ emphasis add: TextEmphasis underlined ].
	^ emphasis
]

{ #category : #accessing }
OPLabel >> text [

	^ text ifNil: [ self defaultText ]
]

{ #category : #accessing }
OPLabel >> text: aString [

	text := aString
]

{ #category : #rendering }
OPLabel >> updateRenderFromModel [

	super updateRenderFromModel.

	self roassalShape emphasis: self emphasis.

	self roassalShape text: self text.

	roassalShape signalUpdate
]

{ #category : #initialization }
OPLabel >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	
	self roassalShape
		fontSize: self fontSize;
		fontName: self fontName;
		color: self fontColor;
		emphasis: self stylesEmphasis.

	roassalShape signalUpdate
]
