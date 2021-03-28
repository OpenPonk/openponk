"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestOpenPonkSpec,
	#superclass : #PackageManifest,
	#category : #'OpenPonk-Spec-Manifest'
}

{ #category : #'code-critics' }
ManifestOpenPonkSpec class >> ruleRBContainsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#OPModelTypeSelector #addModel #false)) #'2021-03-04T21:09:27.51689+01:00') )
]
