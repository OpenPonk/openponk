Extension { #name : 'OPDiagramControllerTest' }

{ #category : '*OpenPonk-Spec-Tests' }
OPDiagramControllerTest >> cleanupContextMenusSince: initialMenus [
	| currentMenus |
	currentMenus := self currentWorld submorphs select: [ :each | each isKindOf: MenuMorph ].
	(currentMenus reject: [ :each | initialMenus includes: each ])
		do: [ :menu | menu delete ]
]

{ #category : '*OpenPonk-Spec-Tests' }
OPDiagramControllerTest >> testInitializePalette [

	| palette |
	palette := OPPalette new.
	self assert: palette items size equals: 2.
	controller initializePalette: palette.
	self assert: palette items size equals: 3
]

{ #category : '*OpenPonk-Spec-Tests' }
OPDiagramControllerTest >> testRoassalShapeContextClickedBuildsAndOpensContextMenu [
	| pluginRegistry canvasPresenter entityA entityB controllerA controllerB menusBefore |
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: OPTestPlugin new.
	[
		OPPluginRegistry setDefault: pluginRegistry.
		canvasPresenter := OPCanvasPresenter new.
		controller canvasPresenter: canvasPresenter.
		entityA := OPTestEntityModel new.
		entityB := OPTestEntityModel new.
		model add: entityA.
		model add: entityB.
		controllerA := controller showInDiagramModel: entityA.
		controllerB := controller showInDiagramModel: entityB.

		menusBefore := (self currentWorld submorphs select: [ :each | each isKindOf: MenuMorph ]) asIdentitySet.
		[
			controllerA roassalShape announce: (RSMouseRightClick new shape: controllerA roassalShape; yourself).
			self cleanupContextMenusSince: menusBefore.

			(canvasPresenter canvas propertyAt: OPRSSelectableCanvas)
				selectShapes: (RSGroup with: controllerA roassalShape with: controllerB roassalShape)
				byEvent: (RSMouseClick new canvas: canvasPresenter canvas; position: 0 @ 0; yourself).
			controllerA roassalShape announce: (RSMouseRightClick new shape: controllerA roassalShape; yourself)
		] ensure: [ self cleanupContextMenusSince: menusBefore ]
	] ensure: [ OPPluginRegistry resetDefault ]
]
