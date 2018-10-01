"
I collect information about errors and such and send it to remove server.
"
Class {
	#name : #OPTelemetry,
	#superclass : #Object,
	#classInstVars : [
		'uuid',
		'reports',
		'enableMetrics'
	],
	#category : #'OpenPonk-Telemetry'
}

{ #category : #accessing }
OPTelemetry class >> current [
	^ self new
]

{ #category : #accessing }
OPTelemetry class >> enableMetrics [
	^ enableMetrics ifNil: [ enableMetrics := false ]
]

{ #category : #accessing }
OPTelemetry class >> enableMetrics: aBoolean [
	enableMetrics := aBoolean
]

{ #category : #accessing }
OPTelemetry class >> reports [
	^ reports ifNil: [ reports := OrderedCollection new ]
]

{ #category : #loading }
OPTelemetry class >> storeLoadUuid [
	| location |
	location := FileLocator imageDirectory asFileReference / 'uuid.ston'.
	location exists
		ifFalse: [ location writeStreamDo: [ :stream | stream << (STON toStringPretty: UUID new) ] ].
	^ STON fromString: location contents
]

{ #category : #accessing }
OPTelemetry class >> uuid [
	^ uuid ifNil: [ uuid := self storeLoadUuid ]
]

{ #category : #accessing }
OPTelemetry >> enabled [
	^ Sentry enabled & Sentry autoSubmit
]

{ #category : #accessing }
OPTelemetry >> mimeType [
	^ ZnMimeType applicationJson
]

{ #category : #reporting }
OPTelemetry >> reportMetric: aPayload plugin: aPlugin [
	| data |
	self enabled
		ifFalse: [ ^ self ].
	data := OPTelemetryExtractor new metadataFor: aPlugin.
	data at: #payload put: aPayload asDictionary.
	self send: data
]

{ #category : #reporting }
OPTelemetry >> send: data [
	[ | response |
	[ response := ZnEasy post: self url data: (self serializedData: data) ]
		on: NetworkError
		do: [ :error | response := error ].
	self class reports add: data -> response ] fork
]

{ #category : #reporting }
OPTelemetry >> serializedData: data [
	^ ZnEntity with: (STON toJsonString: data) type: self mimeType
]

{ #category : #accessing }
OPTelemetry >> url [
	^ 'https://1cee374d0c7b400cbc13e9c81522b334:05a690aac42f4167b919f606a3bc82b7@sentry.openponk.ccmi.fit.cvut.cz/4'
]
