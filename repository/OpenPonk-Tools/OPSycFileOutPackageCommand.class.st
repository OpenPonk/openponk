"
I am a Calypso browser command that allows developers to file out (export to a standard .st source file) an entire package directly from the system browser context menu.
"
Class {
	#name : 'OPSycFileOutPackageCommand',
	#superclass : 'SycPackageCommand',
	#category : 'OpenPonk-Tools-Export',
	#package : 'OpenPonk-Tools',
	#tag : 'Export'
}

{ #category : 'activation' }
OPSycFileOutPackageCommand class >> fullBrowserMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: CmdExtraMenuGroup for: ClyFullBrowserPackageContext
]

{ #category : 'accessing' }
OPSycFileOutPackageCommand >> defaultMenuIconName [
	^ #save
]

{ #category : 'accessing' }
OPSycFileOutPackageCommand >> defaultMenuItemName [
	^ 'File out'
]

{ #category : 'execution' }
OPSycFileOutPackageCommand >> execute [
	packages do: [ :each | each fileOut ]
]
