Class {
	#name : #ManifestOpenPonkCore,
	#superclass : #PackageManifest,
	#category : #'OpenPonk-Core-Manifest'
}

{ #category : #'code-critics' }
ManifestOpenPonkCore class >> ruleReTestClassNotInPackageWithTestEndingNameV1FalsePositive [
	^ #(#(#(#RGPackageDefinition #(#'OpenPonk-Core')) #'2020-05-27T10:56:37.652665+02:00') )
]
