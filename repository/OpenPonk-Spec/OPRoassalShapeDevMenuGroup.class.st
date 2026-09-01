"
Commander menu group that collects developer-specific diagnostic commands (like inspecting morphs or controllers) within the shape context menu.
"
Class {
	#name : 'OPRoassalShapeDevMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPRoassalShapeDevMenuGroup >> name [
	^'Development Only'
]
