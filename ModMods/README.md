# ModMods

A personal set of tweaks to existing mods:

## CircuitHUD V2:
- Switches to the correct surface when going to a combinator, if Space Exploration is installed.
- Added some missing Locale strings.

## Kux Zooming Reinvented:
- Added a setting to restore the last known zoom level when changing surfaces and/or jumping positions.  This is useful when using Space Exploration's navigation satellite pins or Circuit HUD's go-to-combinator functionality. Before, both mods would result in 1) zooming the user in on the destination, and 2) when you use the mousewheel again then the zoom would suddenly jump back to the previously remembered zoom level. Now the zoom level is maintained in both situations.  However, due to me not wanting to restore the zoom on *every* movement, for example when the character is simply walking, there's a distance threshold setting.  This also has the side effect that you can go to a Space Exploration pin or Circuit HUD combinator twice in a row to allow it to zoom to its desired zoom level.

## Early Logistics:
- When Krastorio 2 is installed alongside Space Exploration, it adds additional space-based technologies, so this removes those technologies as well.
- Also removing the requirements from all downstream technologies, so for example Logistic Cargo Wagon and AAI Containers logistic versions won't require space-based technologies either.

## Krastorio 2:
- Fixes some discrepancies between the base game and Krastorio 2 icons for oil processing.
- Brings back the base game icons for Light and Heavy oil instead of Krastorio 2's new icons.
- Makes the icon for Petroleum Gas the same color as the fluid in pipes/tanks (purple).
- Uses the Petroleum Gas icon for the basic-oil-processing recipe, since Krastorio 2 uses the Light Oil icon and Heavy Oil icon for advanced-oil-processing and oil-processing-heavy respectively.
- Uses the loader graphics from AAI Loaders if that mod is installed and set to graphics-only mode.
