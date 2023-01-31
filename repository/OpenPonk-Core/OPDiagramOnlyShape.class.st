Class {
	#name : #OPDiagramOnlyShape,
	#superclass : #OPShape,
	#instVars : [
		'uuid'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPDiagramOnlyShape class >> neoJsonMapping: mapper [

	mapper
		for: self do: [ :mapping | 
			mapping mapInstVars:
					mapping identifier allInstVarNames \ #( announcer ).
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

{ #category : #accessing }
OPDiagramOnlyShape >> initialize [

	super initialize.
	uuid := UUID new
]

{ #category : #accessing }
OPDiagramOnlyShape >> modelElements: aCollection [

	aCollection ifEmpty: [ ^ self ].
	self shouldNotImplement
]

{ #category : #accessing }
OPDiagramOnlyShape >> uuid [

	^ uuid
]
