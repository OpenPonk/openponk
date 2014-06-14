as yet unclassified
initializeWidgets

    view := DCPDrawing new asSpecAdapter.
    button1 := self newButton.
    button2 := self newButton.

    button1 label: 'Neco button'.
    button2 label: 'Cosi button'.

    self focusOrder
        add: button1;
        add: button2.