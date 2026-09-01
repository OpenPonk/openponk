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

	| entities |
	entities := self registry project models select: [ :each |
		            each respondsTo: #entities ].
	entities ifEmpty: [
			entities := self registry projectViewModel childrenModels select: [
				            :each | each respondsTo: #entities ] ].

	[ entities isNotEmpty ] whileTrue: [
			entities
				detect: [ :any | any entities includes: self model ]
				ifFound: [ :found | ^ self registry viewModelFor: found ]
				ifNone: [
						entities := (entities flatCollectAsSet: #entities) select: [
							            :each | each respondsTo: #entities ] ] ].

	^ nil
]

{ #category : 'accessing' }
OPTestModelViewModel >> icon [

	^ self iconNamed: #empty
]
