I manage autosaving and undo/redo operations of a single controller.

!! Warning

As I manage only a single controller, do not rely on this for cross-model operations (such as instance modeling), as changes in the "linked-to" model can make your model invalid if you undo/redo/recover only the instance.