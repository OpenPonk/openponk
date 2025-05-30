"
I represent a view of a model. The content of the model can be filtered, explicitly shown, or explicitly hidden.
Further I contain the layout of the entities in the view, and layout/configuration of the view itself.
"
Class {
	#name : 'OPLegacyDiagram',
	#superclass : 'Object',
	#instVars : [
		'name',
		'isOpen',
		'layout',
		'order',
		'isSelected',
		'camera',
		'visibleElements',
		'model',
		'commonElements'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'instance creation' }
OPLegacyDiagram class >> emptyOfModel: aModel [
	^ self new
		name: aModel name;
		model: aModel;
		isOpen: false;
		isSelected: false;
		yourself
]

{ #category : 'testing' }
OPLegacyDiagram class >> isDeprecated [
	"Use OPDiagram instead"

	^ true
]

{ #category : 'accessing' }
OPLegacyDiagram class >> neoJsonMapping: mapper [

	mapper
		for: self do: [ :mapping | 
			mapping mapInstVars: mapping identifier instVarNames \ #( model ).
			(mapping mapInstVar: #layout) valueSchema: #UUIDsWithPoints.
			(mapping mapInstVar: #camera) valueSchema: OPLegacyDiagramCamera.
			(mapping mapInstVar: #commonElements) valueSchema: #CommonElements.
			(mapping mapInstVar: #visibleElements) valueSchema:
					#ObjectsWithUUIDs ];
		for: #CommonElements
		customDo: [ :mapping | mapping listOfElementSchema: #CommonElement ];
		for: #CommonElement customDo: [ :mapping | 
			mapping reader: [ :jsonReader | 
					| map element |
					map := jsonReader parseMap.
					element := (self class environment at:
							            (map at: #className) asSymbol) new.
					NeoJSONReader
						fromString: (OPJsonWriter toString: map)
						as: element class ] ];
		for: #ObjectsWithUUIDs
		customDo: [ :mapping | mapping listOfElementSchema: #ObjectWithUUID ];
		for: #ObjectWithUUID customDo: [ :mapping | 
			mapping
				encoder: [ :object | object uuid asString ];
				decoder: [ :string | 
					OPModelObjectReference withUUID: ([ UUID fromString: string ]
								 on: Error
								 do: [ string ]) ] ];
		for: UUID customDo: [ :mapping | 
		mapping
			encoder: [ :uuid | uuid asString ];
			decoder: [ :string | 
				[ UUID fromString: string ]
					on: Error
					do: [ string ] ] ];
		for: #UUIDsWithPoints customDo: [ :mapping | 
		mapping
			reader: [ :jsonReader | 
				| map |
				map := jsonReader mapClass new.
				jsonReader parseMapKeysDo: [ :key | 
						| value |
						value := jsonReader nextAs: OPLegacyElementLayout.
						map
							at: ([ UUID fromString: key ]
									 on: Error
									 do: [ key ])
							put: value ].
				(map associations sorted: [ :a :b | a value < b value ])
					asOrderedDictionary ];
			writer: [ :jsonWriter :map | 
				jsonWriter writeMapStreamingDo: [ :mapWriter | 
						map keysAndValuesDo: [ :key :value | 
								mapWriter
									writeKey: key asString
									value: value
									as: OPLegacyElementLayout ] ] ] ]
]

{ #category : 'instance creation' }
OPLegacyDiagram class >> ofModel: aModel fromJson: aStream [
	^ ((NeoJSONReader on: aStream) nextAs: self)
		model: aModel;
		yourself
]

{ #category : 'instance creation' }
OPLegacyDiagram class >> ofModel: aModel fromJsonString: aString [
	^ self ofModel: aModel fromJson: aString readStream
]

{ #category : 'instance creation' }
OPLegacyDiagram class >> withWholeModel: aModel [
	^ (self emptyOfModel: aModel)
		setAllElementsVisible;
		yourself
]

{ #category : 'copying' }
OPLegacyDiagram >> = otherDiagram [
	^ self asJson = otherDiagram asJson
]

{ #category : 'converting' }
OPLegacyDiagram >> asInfo [
	self deprecated: 'OPDiagramInfo is no longer used'.
	
	^ OPDiagramInfo new
		diagramName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		modelName: self modelName;
		modelType: self modelType;
		yourself
]

{ #category : 'serializing' }
OPLegacyDiagram >> asJson [

	^ String streamContents: [ :stream | self asJsonTo: stream ]
]

{ #category : 'serializing' }
OPLegacyDiagram >> asJsonTo: stream [
	^ (OPJsonWriter on: stream) nextPut: self
]

{ #category : 'converting' }
OPLegacyDiagram >> asOPDiagram [

	| diagram adapters allModelElements layoutsPerModel diagramController canvas controllersByModels |
	diagram := OPOpenPonkDiagram forModelElement: self model.
	[ :job |
	job title: 'Transforming older version of project'.
	job progress: 0.
	diagram name: self name.
	diagram isOpen: self isOpen.
	diagram isSelected: self isSelected.
	diagram camera: self camera.
	adapters := OPNavigatorAdapters new.
	job progress: 0.1.
	allModelElements := ((Set with: self model)
	                     , (adapters allChildrenFor: self model)
	                     , commonElements collect: [ :each |
		                     each uuid -> each ]) asDictionary.
	job progress: 0.2.
	visibleElements := (visibleElements collect: [ :each |
		                    each modelObjectFrom: allModelElements ])
		                   sorted: [ :a :b |
		                   adapters dependsTypeOf: b on: a in: model ].
	job progress: 0.3.
	layoutsPerModel := (layout associations collect: [ :each |
		                    (allModelElements at: each key) -> each value ])
		                   asDictionary.
	job progress: 0.4.
	diagramController := (OPPluginRegistry default pluginFor: model)
		                     diagramControllerClass new.
	diagramController
		model: model;
		diagramElement: diagram.
	canvas := RSCanvas new.
	job progress: 0.5.
	controllersByModels := (visibleElements copyWithout: model) collect: [
		                       :each |
		                       | controller diagramElement |
		                       controller := diagramController
			                                     newControllerFor: each.
		                       diagramController addController: controller.
		                       diagramElement := controller
			                                         ensureDiagramElement.
		                       diagramElement owningElement ifNotExists: [
			                       diagramElement owningElement:
				                       controller ownerDiagramElement ].
		                       each -> controller ].
	job progress: 0.7.
	diagram renderIn: canvas.
	job progress: 0.8.
	controllersByModels do: [ :eachModelAndController |
		layoutsPerModel
			at: eachModelAndController key
			ifPresent: [ :eachLayout |
				eachLayout applyToDiagramElement:
					eachModelAndController value diagramElement ] ].
	job progress: 0.9.
	diagram removeRender.
	job progress: 1 ] asJob run.
	^ diagram
]

{ #category : 'accessing' }
OPLegacyDiagram >> camera [
	^ camera
]

{ #category : 'accessing' }
OPLegacyDiagram >> camera: aCameraSettings [
	camera := aCameraSettings
]

{ #category : 'accessing' }
OPLegacyDiagram >> commonElements [
	^ commonElements
]

{ #category : 'accessing' }
OPLegacyDiagram >> commonElements: anObject [
	commonElements := anObject
]

{ #category : 'comparing' }
OPLegacyDiagram >> hash [

	^ self asJson hash
]

{ #category : 'initialization' }
OPLegacyDiagram >> initialize [
	super initialize.
	commonElements := #().
	visibleElements := OrderedCollection new
]

{ #category : 'accessing' }
OPLegacyDiagram >> isOpen [
	^ isOpen
]

{ #category : 'accessing' }
OPLegacyDiagram >> isOpen: aBoolean [
	isOpen := aBoolean
]

{ #category : 'accessing' }
OPLegacyDiagram >> isSelected [
	^ isSelected
]

{ #category : 'accessing' }
OPLegacyDiagram >> isSelected: aBoolean [
	isSelected := aBoolean
]

{ #category : 'accessing' }
OPLegacyDiagram >> layout [
	^ layout
]

{ #category : 'accessing' }
OPLegacyDiagram >> layout: aCollection [

	layout := (aCollection associations sorted: [ :a :b | 
		           a value < b value ]) asOrderedDictionary
]

{ #category : 'accessing' }
OPLegacyDiagram >> model [
	^ model
		"ifNil: [ self project models
				detect:
					[ :each | each class name = self modelType and: [ each name = self modelName ] ] ]"
]

{ #category : 'accessing' }
OPLegacyDiagram >> model: aModel [
	model := aModel
]

{ #category : 'accessing' }
OPLegacyDiagram >> modelName [
	^ (model respondsTo: #name)
		ifTrue: [ model name ]
		ifFalse: [ model className ]
]

{ #category : 'accessing' }
OPLegacyDiagram >> modelType [
	^ (model respondsTo: #typeName)
		ifTrue: [ model typeName ]
		ifFalse: [ model className ]
]

{ #category : 'accessing' }
OPLegacyDiagram >> name [
	^ name
]

{ #category : 'accessing' }
OPLegacyDiagram >> name: aName [
	name := aName
]

{ #category : 'copying' }
OPLegacyDiagram >> newCopy [
	| newView |
	newView := self class ofModel: model fromJsonString: self asJson.
	newView name: 'copy of ' , self name.
	^ newView
]

{ #category : 'accessing' }
OPLegacyDiagram >> order [
	^ order ifNil: [ 0 ]
]

{ #category : 'accessing' }
OPLegacyDiagram >> order: anOrder [
	order := anOrder
]

{ #category : 'printing' }
OPLegacyDiagram >> printOn: aStream [

	super printOn: aStream.
	aStream << '('.
	self name printOn: aStream.
	aStream << '@'.
	self modelName printOn: aStream.
	aStream << ')'
]

{ #category : 'accessing' }
OPLegacyDiagram >> setAllElementsVisible [

	visibleElements := nil
]

{ #category : 'converting' }
OPLegacyDiagram >> updateFromInfo: anInfo [
	self deprecated: 'OPDiagramInfo is no longer used'.
	
	self isOpen: anInfo isOpen.
	self isSelected: anInfo isSelected.
	self order: anInfo order
]

{ #category : 'accessing' }
OPLegacyDiagram >> updateFromRoassalCanvas: aView [
	self
		camera:
			(OPLegacyDiagramCamera new
				offset: aView canvas camera position;
				zoom: aView canvas camera scale)
]

{ #category : 'accessing' }
OPLegacyDiagram >> visibleElements [

	self deprecated:
		'Use visibleElementsOrIfNotSet: with block as parameter. Variable visibleElements is not set usually when all elements should be visible'.

	^ self visibleElementsOrIfNotSet: [ {  } ]
]

{ #category : 'accessing' }
OPLegacyDiagram >> visibleElements: aCollection [
	visibleElements := aCollection
]

{ #category : 'accessing' }
OPLegacyDiagram >> visibleElementsOrIfNotSet: aBlock [

	visibleElements ifNil: [ visibleElements := aBlock value ].
	^ visibleElements
]
