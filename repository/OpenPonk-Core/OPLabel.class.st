Class {
	#name : #OPLabel,
	#superclass : #OPShape,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

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
OPLabel >> text [

	^ self subclassResponsibility
]
