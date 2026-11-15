"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestOpenPonkCoreTests',
	#superclass : 'PackageManifest',
	#category : 'OpenPonk-Core-Tests-Manifest',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestOpenPonkCoreTests class >> ruleEqualNilRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPProjectTest #testEqualityWithNonProjectReturnsFalse #false)) #'2026-11-15T14:57:01.271+01:00') )
]
