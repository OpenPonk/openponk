"
Specialized Magritte element description that represents an executable action rather than a data property. Used in dynamically generated forms to render interactive buttons bound to specific controller or model methods.
"
Class {
	#name : 'OPMAActionDescription',
	#superclass : 'MAElementDescription',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'accessing' }
OPMAActionDescription class >> defaultAction [
	^ [  ]
]

{ #category : 'testing' }
OPMAActionDescription class >> isAbstract [
	^ false
]

{ #category : 'accessing-properties' }
OPMAActionDescription class >> label [
	^ 'Action'
]

{ #category : 'visiting' }
OPMAActionDescription >> acceptMagritte: aVisitor [
	aVisitor visitActionDescription: self
]

{ #category : 'visiting' }
OPMAActionDescription >> action [
	^ self propertyAt: #action ifAbsent: [ self class defaultAction ]
]

{ #category : 'visiting' }
OPMAActionDescription >> action: aBlock [
	self propertyAt: #action put: aBlock
]
