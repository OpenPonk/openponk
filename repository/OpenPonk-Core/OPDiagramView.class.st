"
I represent a view of a model. The content of the model can be filtered, explicitly shown, or explicitly hidden.
Further I contain the layout of the entities in the view, and layout/configuration of the view itself.
"
Class {
	#name : #OPDiagramView,
	#superclass : #Object,
	#instVars : [
		'project',
		'name',
		'isOpen',
		'filters',
		'layout',
		'notes',
		'modelName',
		'modelType',
		'order',
		'modelVersion',
		'isSelected',
		'camera',
		'version',
		'visibleElements',
		'model',
		'options'
	],
	#category : 'OpenPonk-Core-Views'
}

{ #category : #'instance creation' }
OPDiagramView class >> defaultViewFor: aModel [
	^ self new
		name: 'default';
		model: aModel;
		isOpen: false;
		isSelected: false
]

{ #category : #'instance creation' }
OPDiagramView class >> fromJson: aString [
	^ (NeoJSONReader on: aString readStream)
		mapInstVarsFor: self;
		for: self
			do: [ :mapping | 
			(mapping mapInstVar: #camera) valueSchema: OPDiagramViewCamera.
			(mapping mapInstVar: #layout) valueSchema: #MapOfPoints".
			(mapping mapInstVar: #filters) valueSchema: #ListOfFilters" ];
		mapInstVarsFor: OPDiagramViewCamera;
		for: OPDiagramViewCamera
			do: [ :mapping | (mapping mapInstVar: #offset) valueSchema: Point ];
		mapInstVarsFor: Point;
		for: #MapOfPoints customDo: [ :mapping | mapping mapWithValueSchema: Point ];
		for: #ListOfFilters
			customDo: [ :mapping | mapping listOfType: OrderedCollection andElementSchema: #Filter ];
"		for: #Filter
			customDo: [ :mapping | mapping decoder: [ :data | NSPDiagramViewFilter decodeFrom: data ] ];"
		nextAs: self
]

{ #category : #converting }
OPDiagramView >> asInfo [
	^ OPDiagramViewInfo new
		modelType: self modelType;
		modelName: self modelName;
		modelVersion: self modelVersion;
		viewName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		yourself
]

{ #category : #serializing }
OPDiagramView >> asJson [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				for: OPDiagramView
					do: [ :mapping | 
					mapping
						mapInstVars:
							mapping identifier instVarNames
								\ #(project model modelName modelType modelVersion).
					#(modelName modelVersion modelType) do: [ :each | mapping mapAccessor: each ] ];
				mapInstVarsFor: OPDiagramViewCamera;
				mapInstVarsFor: Point;
				nextPut: self ]
]

{ #category : #accessing }
OPDiagramView >> camera [
	^ camera
]

{ #category : #accessing }
OPDiagramView >> camera: aCameraSettings [
	camera := aCameraSettings
]

{ #category : #initialization }
OPDiagramView >> initialize [
	super initialize.
	filters := OrderedCollection new.
	visibleElements := OrderedCollection new.
	options := Dictionary new
]

{ #category : #testing }
OPDiagramView >> isDefault [
	^ self name = 'default'
]

{ #category : #accessing }
OPDiagramView >> isOpen [
	^ isOpen
]

{ #category : #accessing }
OPDiagramView >> isOpen: aBoolean [
	isOpen := aBoolean
]

{ #category : #accessing }
OPDiagramView >> isSelected [
	^ isSelected
]

{ #category : #accessing }
OPDiagramView >> isSelected: aBoolean [
	isSelected := aBoolean
]

{ #category : #accessing }
OPDiagramView >> layout [
	^ layout ifNil: [ #() asDictionary ]
]

{ #category : #accessing }
OPDiagramView >> layout: aCollection [
	layout := aCollection
]

{ #category : #accessing }
OPDiagramView >> model [
	self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	model ifNotNil: [ ^ model ].
	^ self project class name = #NSPProject
		ifTrue: [ self project models
				detect: [ :each | 
					each typeName = self modelType
						and: [ each name = self modelName and: [ each version = self modelVersion ] ] ] ]
		ifFalse: [ self project models
				detect: [ :each | each class name = self modelType and: [ each name = self modelName ] ] ]
]

{ #category : #accessing }
OPDiagramView >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPDiagramView >> modelName [
	^ model ifNil: [ modelName ] ifNotNil: #name
]

{ #category : #accessing }
OPDiagramView >> modelName: aString [
	modelName := aString
]

{ #category : #accessing }
OPDiagramView >> modelType [
	^ model
		ifNil: [ modelType ]
		ifNotNil: [ "NSP compat"
			(model respondsTo: #typeName)
				ifTrue: [ model typeName ]
				ifFalse: [ model class name ] ]
]

{ #category : #accessing }
OPDiagramView >> modelType: aString [
	modelType := aString
]

{ #category : #accessing }
OPDiagramView >> modelVersion [
	^ model
		ifNil: [ modelVersion ]
		ifNotNil: [ "NSM compat"
			(model respondsTo: #version)
				ifTrue: [ model version ]
				ifFalse: [ nil ] ]
]

{ #category : #accessing }
OPDiagramView >> modelVersion: aModelVersion [
	modelVersion := aModelVersion
]

{ #category : #accessing }
OPDiagramView >> name [
	^ name
]

{ #category : #accessing }
OPDiagramView >> name: aName [
	name := aName
]

{ #category : #copying }
OPDiagramView >> newCopy [
	| newView |
	newView := self class fromJson: self asJson.
	newView name: 'copy of ' , self name.
	newView model: model.
	newView project: project.
	^ newView
]

{ #category : #accessing }
OPDiagramView >> notes [
	^ notes
]

{ #category : #accessing }
OPDiagramView >> notes: aCollection [
	notes := aCollection
]

{ #category : #accessing }
OPDiagramView >> options [
	^ options
]

{ #category : #accessing }
OPDiagramView >> options: aDictionary [
	options := aDictionary
]

{ #category : #accessing }
OPDiagramView >> order [
	^ order ifNil: [ 0 ]
]

{ #category : #accessing }
OPDiagramView >> order: anOrder [
	order := anOrder
]

{ #category : #printing }
OPDiagramView >> printOn: aStream [
	super printOn: aStream.
	aStream << '(' << self name printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'
]

{ #category : #accessing }
OPDiagramView >> project [
	^ project
]

{ #category : #accessing }
OPDiagramView >> project: aProject [
	project := SRToOneLink
		on: self
		slot: #project
		oppositeSlot: #views
		updateFrom: project
		to: aProject
]

{ #category : #converting }
OPDiagramView >> updateFromInfo: anInfo [
	self isOpen: anInfo isOpen.
	self isSelected: anInfo isSelected.
	self order: anInfo order
]

{ #category : #accessing }
OPDiagramView >> updateFromRoassalView: aView [
	self
		camera:
			(OPDiagramViewCamera new
				offset: aView canvas camera position;
				zoom: aView canvas camera scale)
]

{ #category : #accessing }
OPDiagramView >> visibleElements [
	^ visibleElements
]

{ #category : #accessing }
OPDiagramView >> visibleElements: aCollection [
	visibleElements := aCollection
]
