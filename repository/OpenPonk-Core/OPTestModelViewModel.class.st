"
Mock implementation of a ViewModel used exclusively for OpenPonk unit and integration tests.
"
Class {
	#name : 'OPTestModelViewModel',
	#superclass : 'OPViewModel',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
OPTestModelViewModel class >> isAbstract [

	^ self = OPTestModelViewModel
]

{ #category : 'accessing' }
OPTestModelViewModel class >> modelClass [
    ^ OPTestAbstractModel
]

{ #category : 'accessing' }
OPTestModelViewModel >> childrenModels [

	^ (self model respondsTo: #entities)
		  ifTrue: [ self model entities ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'accessing' }
OPTestModelViewModel >> dependentElements [

	^ super dependentElements
	  ,
		  (self modelRootViewModel allChildrenModels select: [ :eachElement |
				   (eachElement respondsTo: #source) and: [
					   eachElement source = self model or: [
						   eachElement target = self model ] ] ])
]

{ #category : 'accessing' }
OPTestModelViewModel >> findParentViewModel [

	| entities261 |
	(self registry project models includes: self model)
		ifTrue: [ ^ self registry projectViewModel ].
	entities261 := self registry project models select: [ :eachModel261 |
		eachModel261 respondsTo: #entities ].
	entities261 ifEmpty: [
		entities261 := self registry projectViewModel childrenModels select: [
			:eachChildModel261 | eachChildModel261 respondsTo: #entities ] ].

	[ entities261 isNotEmpty ] whileTrue: [
		entities261
			detect: [ :anyContainer261 | anyContainer261 entities includes: self model ]
			ifFound: [ :foundContainer261 | ^ self registry viewModelFor: foundContainer261 ]
			ifNone: [
				entities261 := (entities261 flatCollectAsSet: #entities) select: [
					:eachNestedEntity261 | eachNestedEntity261 respondsTo: #entities ] ] ].

	^ nil
]

{ #category : 'accessing' }
OPTestModelViewModel >> icon [

	^ self iconNamed: #empty
]
