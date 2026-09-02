"
Stores metadata for this package. 
These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser.
"
Class {
	#name : 'ManifestOpenPonkCore',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-Core-Manifest',
	#package : 'OpenPonk-Core',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkCore class >> ruleRTInvocationSequenceRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#OPTRelationshipWithPathPointsController #layout #false)) #'2021-07-21T17:15:27.877427+02:00') #(#(#RGMethodDefinition #(#OPTRelationshipWithPathPointsController #layout: #false)) #'2021-07-21T17:17:28.272427+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkCore class >> ruleReTestClassNotInPackageWithTestEndingNameV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-Core')) #'2020-05-27T10:56:37.652665+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkCore class >> ruleRefersToClassRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPViewModel #modelType #false)) #'2026-09-02T14:19:14.522+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkCore class >> ruleStringConcatenationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPMementoDirectorySerializer #loadModelFrom: #false)) #'2024-10-17T12:14:35.401+02:00') )
]
