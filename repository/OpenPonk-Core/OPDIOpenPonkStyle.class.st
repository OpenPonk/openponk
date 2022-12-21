Class {
	#name : #OPDIOpenPonkStyle,
	#superclass : #OPDIStyle,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPDIOpenPonkStyle >> fillColor [
	^ self at: #fillColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fillColor: aColor [
	self at: #fillColor put: aColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fillOpacity [
	^ self at: #fillOpacity
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fillOpacity: aNumber [
	self at: #fillOpacity put: aNumber
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontBold [
	^ self at: #fontBold
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontBold: aBoolean [
	self at: #fontBold put: aBoolean
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontColor [
	^ self at: #fontColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontColor: aColor [
	self at: #fontColor put: aColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontEmphasis [

	| emphasis |
	emphasis := TextEmphasis normal.
	self fontBold ifTrue: [ emphasis add: TextEmphasis bold ].
	self fontItalic ifTrue: [ emphasis add: TextEmphasis italic ].
	self fontStrikeThrough ifTrue: [ 
		emphasis add: TextEmphasis struckOut ].
	self fontUnderline ifTrue: [ emphasis add: TextEmphasis underlined ].
	^ emphasis
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontItalic [
	^ self at: #fontItalic
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontItalic: aBoolean [
	self at: #fontItalic put: aBoolean
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontName [
	^ self at: #fontName
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontName: aFontName [
	self at: #fontName put: aFontName
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontSize [
	^ self at: #fontSize
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontSize: aFontSize [
	self at: #fontSize put: aFontSize
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontStrikeThrough [
	^ self at: #fontStrikeThrough
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontStrikeThrough: aBoolean [
	self at: #fontStrikeThrough put: aBoolean
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontUnderline [
	^ self at: #fontUnderline
]

{ #category : #accessing }
OPDIOpenPonkStyle >> fontUnderline: aBoolean [
	self at: #fontUnderline put: aBoolean
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeColor [
	^ self at: #strokeColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeColor: aColor [
	self at: #strokeColor put: aColor
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeDashLength [
	^ self at: #strokeDashLength
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeDashLength: aCollection [
	self at: #strokeDashLength put: aCollection
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeOpacity [
	^ self at: #strokeOpacity
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeOpacity: aNumber [
	self at: #strokeOpacity put: aNumber
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeWidth [
	^ self at: #strokeWidth
]

{ #category : #accessing }
OPDIOpenPonkStyle >> strokeWidth: aNumber [
	self at: #strokeWidth put: aNumber
]
