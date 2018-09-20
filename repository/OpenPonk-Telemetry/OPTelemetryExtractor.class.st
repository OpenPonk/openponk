Class {
	#name : #OPTelemetryExtractor,
	#superclass : #Object,
	#category : 'OpenPonk-Telemetry'
}

{ #category : #'as yet unclassified' }
OPTelemetryExtractor >> metadataFor: aPlugin [
	^ {#pharo -> self pharoVersion.
	#openponk -> self opVersion.
	#plugin -> (self pluginVersionFor: aPlugin).
	#user -> self user} asDictionary
]

{ #category : #accessing }
OPTelemetryExtractor >> opVersion [
	^ {#version -> OPVersion version.
	#gitCommit -> OPVersion gitCommit} asDictionary
]

{ #category : #accessing }
OPTelemetryExtractor >> pharoVersion [
	^ {#name -> SystemVersion current version.
	#update -> SystemVersion current highestUpdate} asDictionary
]

{ #category : #accessing }
OPTelemetryExtractor >> pluginVersionFor: aPlugin [
	^ {#name -> aPlugin name.
	#className -> aPlugin className.
	#version -> aPlugin version.
	#gitCommit -> aPlugin gitCommit} asDictionary
]

{ #category : #accessing }
OPTelemetryExtractor >> user [
	^ {'uuid' -> OPTelemetry uuid asString} asDictionary
]
