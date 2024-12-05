Class {
	#name : 'OPDiagramOnlyShape',
	#superclass : 'OPBoundNode',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'uuid',
		'announcer'
	],
	#category : 'OpenPonk-Core-CommonElements',
	#package : 'OpenPonk-Core',
	#tag : 'CommonElements'
}

{ #category : 'accessing' }
OPDiagramOnlyShape class >> neoJsonMapping: mapper [

	mapper
		for: self do: [ :mapping | 
			mapping mapInstVars: self stonAllInstVarNames.
			(mapping mapInstVar: #uuid) valueSchema: UUID.
			mapping
				mapProperty: #className
				getter: [ :object | object className ]
				setter: [ :object :value | 
					object assert: object className = value ] ];
		for: UUID customDo: [ :mapping | 
			mapping
				encoder: [ :uuid | uuid asString ];
				decoder: [ :string | 
					[ UUID fromString: string ]
						on: Error
						do: [ string ] ] ]
]

{ #category : 'ston-core' }
OPDiagramOnlyShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #uuid )
]

{ #category : 'comparing' }
OPDiagramOnlyShape >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ aComparable class = self class and: [ self uuid < aComparable uuid ]
]

{ #category : 'comparing' }
OPDiagramOnlyShape >> = aComparable [
	"Compare the receiver with the argument and answer with true if the
	receiver is equal to the argument. Otherwise answer false."

	^ aComparable class = self class and: [ self uuid = aComparable uuid ]
]

{ #category : 'accessing' }
OPDiagramOnlyShape >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'comparing' }
OPDiagramOnlyShape >> hash [
	"Hash must be redefined whenever = is redefined."

	^ self uuid hash
]

{ #category : 'initialization' }
OPDiagramOnlyShape >> initialize [

	super initialize.
	uuid := UUID new
]

{ #category : 'testing' }
OPDiagramOnlyShape >> isDiagramOnly [

	^ true
]

{ #category : 'accessing' }
OPDiagramOnlyShape >> modelElements [

	^ { self }
]

{ #category : 'accessing' }
OPDiagramOnlyShape >> modelElements: aCollection [

	(aCollection noneSatisfy: [ :any | any ~= self ]) ifTrue: [ ^ self ].
	self shouldNotImplement
]

{ #category : 'rendering' }
OPDiagramOnlyShape >> updateRenderFromModel [

	"do nothing - there is no model"
]

{ #category : 'accessing' }
OPDiagramOnlyShape >> uuid [

	^ uuid
]

{ #category : 'announcement registration' }
OPDiagramOnlyShape >> when: anAnnouncementClass send: aSelector to: aReceiver [

	^ self announcer
		  when: anAnnouncementClass
		  send: aSelector
		  to: aReceiver
]
