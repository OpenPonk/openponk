"
I represent a view of a model. The content of the model can be filtered, explicitly shown, or explicitly hidden.
Further I contain the layout of the entities in the view, and layout/configuration of the view itself.
"
Class {
	#name : #OPDiagram,
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
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #'instance creation' }
OPDiagram class >> defaultDiagramFor: aModel [
	^ self new
		name: 'default';
		model: aModel;
		isOpen: false;
		isSelected: false
]

{ #category : #'instance creation' }
OPDiagram class >> fromJson: aString [
	^ (NeoJSONReader on: aString readStream)
		mapInstVarsFor: self;
		for: self
			do: [ :mapping | 
			(mapping mapInstVar: #camera) valueSchema: OPDiagramCamera.
			(mapping mapInstVar: #layout) valueSchema: #MapOfPoints".
			(mapping mapInstVar: #filters) valueSchema: #ListOfFilters" ];
		mapInstVarsFor: OPDiagramCamera;
		for: OPDiagramCamera
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
OPDiagram >> asInfo [
	^ OPDiagramInfo new
		modelType: self modelType;
		modelName: self modelName;
		modelVersion: self modelVersion;
		diagramName: self name;
		isOpen: self isOpen;
		isSelected: self isSelected;
		order: self order;
		yourself
]

{ #category : #serializing }
OPDiagram >> asJson [
	^ String
		<< [ :stream | 
			(OPJsonWriter on: stream)
				for: OPDiagram
					do: [ :mapping | 
					mapping
						mapInstVars:
							mapping identifier instVarNames
								\ #(project model modelName modelType modelVersion).
					#(modelName modelVersion modelType) do: [ :each | mapping mapAccessor: each ] ];
				mapInstVarsFor: OPDiagramCamera;
				mapInstVarsFor: Point;
				nextPut: self ]
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
	filters := OrderedCollection new.
	visibleElements := OrderedCollection new.
	options := Dictionary new
]

{ #category : #testing }
OPDiagram >> isDefault [
	^ self name = 'default'
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
	^ layout ifNil: [ #() asDictionary ]
]

{ #category : #accessing }
OPDiagram >> layout: aCollection [
	layout := aCollection
]

{ #category : #accessing }
OPDiagram >> model [
	self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	model ifNotNil: [ ^ model ].
	^ self project models
		detect:
			[ :each | each class name = self modelType and: [ each name = self modelName ] ]
]

{ #category : #accessing }
OPDiagram >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPDiagram >> modelName [
	^ model ifNil: [ modelName ] ifNotNil: #name
]

{ #category : #accessing }
OPDiagram >> modelName: aString [
	modelName := aString
]

{ #category : #accessing }
OPDiagram >> modelType [
	^ model
		ifNil: [ modelType ]
		ifNotNil: [ "NSP compat"
			(model respondsTo: #typeName)
				ifTrue: [ model typeName ]
				ifFalse: [ model class name ] ]
]

{ #category : #accessing }
OPDiagram >> modelType: aString [
	modelType := aString
]

{ #category : #accessing }
OPDiagram >> modelVersion [
	^ model
		ifNil: [ modelVersion ]
		ifNotNil: [ "NSM compat"
			(model respondsTo: #version)
				ifTrue: [ model version ]
				ifFalse: [ nil ] ]
]

{ #category : #accessing }
OPDiagram >> modelVersion: aModelVersion [
	modelVersion := aModelVersion
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
	newView := self class fromJson: self asJson.
	newView name: 'copy of ' , self name.
	newView model: model.
	newView project: project.
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
	aStream << '(' << self name printString << '@' << self modelName printString << '-'
		<< self modelVersion printString << ')'
]

{ #category : #accessing }
OPDiagram >> project [
	^ project
]

{ #category : #accessing }
OPDiagram >> project: aProject [
	project := aProject
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
