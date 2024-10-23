Class {
	#name : 'OPOpenPonkShapeStyle',
	#superclass : 'OPShapeStyle',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fillColor [
	^ self at: #fillColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fillColor: aColor [
	self at: #fillColor put: aColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fillOpacity [
	^ self at: #fillOpacity
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fillOpacity: aNumber [
	self at: #fillOpacity put: aNumber
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontBold [
	^ self at: #fontBold
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontBold: aBoolean [
	self at: #fontBold put: aBoolean
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontColor [
	^ self at: #fontColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontColor: aColor [
	self at: #fontColor put: aColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontItalic [
	^ self at: #fontItalic
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontItalic: aBoolean [
	self at: #fontItalic put: aBoolean
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontName [
	^ self at: #fontName
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontName: aFontName [
	self at: #fontName put: aFontName
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontSize [
	^ self at: #fontSize
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontSize: aFontSize [
	self at: #fontSize put: aFontSize
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontStrikeThrough [
	^ self at: #fontStrikeThrough
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontStrikeThrough: aBoolean [
	self at: #fontStrikeThrough put: aBoolean
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontUnderline [
	^ self at: #fontUnderline
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> fontUnderline: aBoolean [
	self at: #fontUnderline put: aBoolean
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeColor [
	^ self at: #strokeColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeColor: aColor [
	self at: #strokeColor put: aColor
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeDashLength [
	^ self at: #strokeDashLength
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeDashLength: aCollection [
	self at: #strokeDashLength put: aCollection
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeOpacity [
	^ self at: #strokeOpacity
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeOpacity: aNumber [
	self at: #strokeOpacity put: aNumber
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeWidth [
	^ self at: #strokeWidth
]

{ #category : 'accessing' }
OPOpenPonkShapeStyle >> strokeWidth: aNumber [
	self at: #strokeWidth put: aNumber
]
