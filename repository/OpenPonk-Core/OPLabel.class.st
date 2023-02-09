Class {
	#name : #OPLabel,
	#superclass : #OPShape,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'ston-core' }
OPLabel class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #text )
]

{ #category : #accessing }
OPLabel >> defaultEmphasis [

	^ TextEmphasis normal
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

	^ self
		  stylePropertyNamed: #fontEmphasis
		  ifAbsent: [ self defaultEmphasis ]
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

{ #category : #accessing }
OPLabel >> noText [

	self text: ''
]

{ #category : #rendering }
OPLabel >> renderBasicShape [

	roassalShape := RSLabel new.
	roassalShape
		fontSize: self fontSize;
		fontName: self fontName;
		color: self fontColor;
		text: self text;
		emphasis: self emphasis;
		model: self;
		yourself
]

{ #category : #accessing }
OPLabel >> resetText [

	self text: nil
]

{ #category : #accessing }
OPLabel >> text [

	^ text ifNil: [ self defaultText ]
]

{ #category : #accessing }
OPLabel >> text: aString [

	text := aString
]
