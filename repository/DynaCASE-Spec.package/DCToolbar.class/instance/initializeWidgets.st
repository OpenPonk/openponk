initialization
initializeWidgets
	menuModel := self instantiate: MenuModel.
	groupModel := MenuGroupModel new.
	menuModel addMenuGroup: groupModel