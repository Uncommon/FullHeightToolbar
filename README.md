FullHeightToolbar
===================

A toolbar with full-height items, like the status items in Xcode, iTunes, and Instruments. Especially Instruments.

Implementation
--------------
The challenge with full-height toolbar items is that you can't extend a custom view to cover the label area. The workaround: hide the labels, make *every* item use custom views, and draw the labels yourself.

This seems to be the approach used in Instruments, which unlike Xcode and iTunes has a normal customizable toolbar. But notice how, in the customize sheet, the standard items (Space and Colors) don't line up vertically with the custom items, and the Show popup is gone so you can't hide the labels. Another side effect is that in the overflow menu, everything has a blank name. All of these indicate that the Instruments toolbar is messing with labels.

Without really trying, I ended up with an implementation that doesn't have the vertical alignment or overflow menu issues. But this is unfinished and there are surely other things, so please feel free to file issues.
