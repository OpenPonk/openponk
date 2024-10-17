"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkSpec',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-Spec-Manifest',
	#package : 'OpenPonk-Spec',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkSpec class >> ruleRBContainsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#OPModelTypeSelector #addModel #false)) #'2021-03-04T21:09:27.51689+01:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkSpec class >> ruleRefersToClassRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'OPLegacyProjectLoadTest class' #generateFromProjectFile: #true)) #'2024-10-17T11:08:54.945+02:00') )
]

{ #category : 'code-critics' }
ManifestOpenPonkSpec class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'OPLegacyProjectLoadTest class' #generateFromProjectFile: #true)) #'2024-10-17T11:08:51.1+02:00') )
]
