Class {
	#name : 'OPDiagramOnlyShape',
	#superclass : 'OPBoundNode',
	#traits : 'OPTBorderColoredAsStroke - {#updateRenderFromStyles}',
	#classTraits : 'OPTBorderColoredAsStroke classTrait',
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

{ #category : 'accessing' }
OPDiagramOnlyShape >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'initialization' }
OPDiagramOnlyShape >> initialize [

	super initialize.
	uuid := UUID new
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

{ #category : 'accessing' }
OPDiagramOnlyShape >> strokeColor: aColor [

	"ignore for now"
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
