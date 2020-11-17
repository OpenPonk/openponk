"
I represent a view of a model. The content of the model can be filtered, explicitly shown, or explicitly hidden.
Further I contain the layout of the entities in the view, and layout/configuration of the view itself.
"
Class {
	#name : #OPDiagram,
	#superclass : #Object,
	#instVars : [
		'name',
		'isOpen',
		'filters',
		'layout',
		'notes',
		'order',
		'isSelected',
		'camera',
		'version',
		'visibleElements',
		'model',
		'options'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #'instance creation' }
OPDiagram class >> emptyOfModel: aModel [
	^ self new
		name: aModel name;
		model: aModel;
		isOpen: false;
		isSelected: false;
		yourself
]

{ #category : #accessing }
OPDiagram class >> neoJsonMapping: mapper [
	mapper
		for: self
			do: [ :mapping | 
			mapping mapInstVars: mapping identifier instVarNames \ #(model).
			(mapping mapInstVar: #layout) valueSchema: #UUIDsWithPoints.
			(mapping mapInstVar: #camera) valueSchema: OPDiagramCamera.
			(mapping mapInstVar: #visibleElements)
				valueSchema: #ObjectsWithUUIDs ];
		for: #ObjectsWithUUIDs
			customDo: [ :mapping | mapping listOfElementSchema: #ObjectWithUUID ];
		for: #ObjectWithUUID
			customDo: [ :mapping | 
			mapping
				encoder: [ :object | object uuid asString ];
				decoder:
						[ :string | OPModelObjectReference withUUID: (UUID fromString: string) ] ];
		for: UUID
			customDo: [ :mapping | 
			mapping
				encoder: [ :uuid | uuid asString ];
				decoder: [ :string | UUID fromString: string ] ];
		for: #UUIDsWithPoints
			customDo: [ :mapping | 
			mapping
				reader: [ :jsonReader | 
					| map |
					map := jsonReader mapClass new.
					jsonReader
						parseMapKeysDo: [ :key | 
							| value |
							value := jsonReader nextAs: OPElementLayout.
							map at: (UUID fromString: key) put: value ].
					map ];
				writer: [ :jsonWriter :map | 
					jsonWriter
						writeMapStreamingDo: [ :mapWriter | 
							map
								keysAndValuesDo:
									[ :key :value | mapWriter writeKey: key asString value: value as: OPElementLayout ] ] ] ]
]

{ #category : #'instance creation' }
OPDiagram class >> ofModel: aModel fromJson: aStream [
	^ ((NeoJSONReader on: aStream) nextAs: self)
		model: aModel;
		yourself
]

{ #category : #'instance creation' }
OPDiagram class >> ofModel: aModel fromJsonString: aString [
	^ self ofModel: aModel fromJson: aString readStream
]

{ #category : #'instance creation' }
OPDiagram class >> withWholeModel: aModel [
	^ (self emptyOfModel: aModel)
		allElementsVisible;
		yourself
]

{ #category : #copying }
OPDiagram >> = otherDiagram [
	^ self asJson = otherDiagram asJson
]

{ #category : #accessing }
OPDiagram >> allElementsVisible [
	| aCollection |
	aCollection := OrderedCollection new.
	(aCollection stub anySatisfy: Any) will: [ true ].
	(aCollection stub noneSatisfy: Any) will: [ false ].
	(aCollection stub ifEmpty: (Kind of: BlockClosure))
		will: [ aCollection ].
	(aCollection stub ifNotEmpty: (Kind of: BlockClosure))
		will: [ :block | block value ].
	self visibleElements: aCollection
]

{ #category : #converting }
OPDiagram >> asInfo [
	^ OPDiagramInfo new
		diagramName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		modelName: self modelName;
		modelType: self modelType;
		yourself
]

{ #category : #serializing }
OPDiagram >> asJson [
	^ String << [ :stream | self asJsonTo: stream ]
]

{ #category : #serializing }
OPDiagram >> asJsonTo: stream [
	^ (OPJsonWriter on: stream) nextPut: self
]

{ #category : #accessing }
OPDiagram >> camera [
	^ camera
]

{ #category : #accessing }
OPDiagram >> camera: aCameraSettings [
	camera := aCameraSettings
]

{ #category : #initialization }
OPDiagram >> initialize [
	super initialize.
	visibleElements := OrderedCollection new.
	options := Dictionary new
]

{ #category : #accessing }
OPDiagram >> isOpen [
	^ isOpen
]

{ #category : #accessing }
OPDiagram >> isOpen: aBoolean [
	isOpen := aBoolean
]

{ #category : #accessing }
OPDiagram >> isSelected [
	^ isSelected
]

{ #category : #accessing }
OPDiagram >> isSelected: aBoolean [
	isSelected := aBoolean
]

{ #category : #accessing }
OPDiagram >> layout [
	^ layout 
]

{ #category : #accessing }
OPDiagram >> layout: aCollection [
	layout := aCollection
]

{ #category : #accessing }
OPDiagram >> model [
	^ model
		"ifNil: [ self project models
				detect:
					[ :each | each class name = self modelType and: [ each name = self modelName ] ] ]"
]

{ #category : #accessing }
OPDiagram >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPDiagram >> modelName [
	^ (model respondsTo: #name)
		ifTrue: [ model name ]
		ifFalse: [ model className ]
]

{ #category : #accessing }
OPDiagram >> modelType [
	^ (model respondsTo: #typeName)
		ifTrue: [ model typeName ]
		ifFalse: [ model className ]
]

{ #category : #accessing }
OPDiagram >> name [
	^ name
]

{ #category : #accessing }
OPDiagram >> name: aName [
	name := aName
]

{ #category : #copying }
OPDiagram >> newCopy [
	| newView |
	newView := self class ofModel: model fromJsonString: self asJson.
	newView name: 'copy of ' , self name.
	^ newView
]

{ #category : #accessing }
OPDiagram >> notes [
	^ notes
]

{ #category : #accessing }
OPDiagram >> notes: aCollection [
	notes := aCollection
]

{ #category : #accessing }
OPDiagram >> options [
	^ options
]

{ #category : #accessing }
OPDiagram >> options: aDictionary [
	options := aDictionary
]

{ #category : #accessing }
OPDiagram >> order [
	^ order ifNil: [ 0 ]
]

{ #category : #accessing }
OPDiagram >> order: anOrder [
	order := anOrder
]

{ #category : #printing }
OPDiagram >> printOn: aStream [
	super printOn: aStream.
	aStream << '(' << self name printString << '@'
		<< self modelName printString << '-' << ')'
]

{ #category : #converting }
OPDiagram >> updateFromInfo: anInfo [
	self isOpen: anInfo isOpen.
	self isSelected: anInfo isSelected.
	self order: anInfo order
]

{ #category : #accessing }
OPDiagram >> updateFromRoassalView: aView [
	self
		camera:
			(OPDiagramCamera new
				offset: aView canvas camera position;
				zoom: aView canvas camera scale)
]

{ #category : #accessing }
OPDiagram >> visibleElements [
	^ visibleElements
]

{ #category : #accessing }
OPDiagram >> visibleElements: aCollection [
	visibleElements := aCollection
]
