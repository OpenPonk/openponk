"
I am a Calypso browser command that allows developers to file out (export to a standard .st source file) all classes contained within a specific package tag directly from the system browser context menu.
"
Class {
	#name : 'OPSycFileOutPackageTagCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'tags'
	],
	#category : 'OpenPonk-DevTools-Export',
	#package : 'OpenPonk-DevTools',
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

	| filename |
	filename := tags size = 1
		            ifTrue: [ tags first name ]
		            ifFalse: [ 'packagefileout' ].

	^ Fileouter
		  fileoutNamed: filename
		  cofigureWith: [ :fileouter | tags do: [ :eachTag | eachTag classes do: [ :eachClass | fileouter addFullClass: eachClass ] ] ]
]

{ #category : 'execution' }
OPSycFileOutPackageTagCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	tags := aToolContext selectedItems collect: [ :each | each actualObject ]
]
