"
I am a Calypso browser command that allows developers to file out (export to a standard .st source file) all classes contained within a specific package tag directly from the system browser context menu.
"
Class {
	#name : 'OPSycFileOutPackageTagCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'tags'
	],
	#category : 'OpenPonk-Tools-Export',
	#package : 'OpenPonk-Tools',
	#tag : 'Export'
}

{ #category : 'activation' }
OPSycFileOutPackageTagCommand class >> fullBrowserMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdExtraMenuGroup for: ClyTaggedClassGroup asCalypsoItemContext
]

{ #category : 'accessing' }
OPSycFileOutPackageTagCommand >> defaultMenuIconName [
	^ #save
]

{ #category : 'accessing' }
OPSycFileOutPackageTagCommand >> defaultMenuItemName [
	^ 'File out'
]

{ #category : 'execution' }
OPSycFileOutPackageTagCommand >> execute [
	tags do: [ :each |
		(each respondsTo: #fileOut)
			ifTrue: [ each fileOut ]
			ifFalse: [ (each package tagNamed: each name) fileOut ] ]
]

{ #category : 'execution' }
OPSycFileOutPackageTagCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	tags := aToolContext selectedItems collect: [ :each | each actualObject ]
]
