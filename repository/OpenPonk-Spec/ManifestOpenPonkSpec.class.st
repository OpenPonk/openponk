"
Stores metadata for the OpenPonk-Spec package. 
Encapsulates the graphical user interface components of OpenPonk built on top of the Spec framework, handling layouts, dialogs, forms, and the core workbench.
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
ManifestOpenPonkSpec class >> ruleReShouldSendSuperInitializeAsFirstMessageV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#OPWorkbench #initialize #false)) #'2026-08-30T22:36:32.027+02:00') #(#(#RGMethodDefinition #(#OPDynamicForm #initialize #false)) #'2026-08-30T22:36:53.117+02:00') #(#(#RGMethodDefinition #(#OPPalette #initialize #false)) #'2026-08-30T22:37:01.49+02:00') #(#(#RGMethodDefinition #(#OPVersionInfo #initialize #false)) #'2026-08-30T22:37:21.918+02:00') #(#(#RGMethodDefinition #(#OPProjectBrowser #initialize #false)) #'2026-08-30T22:39:17.276+02:00') )
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
