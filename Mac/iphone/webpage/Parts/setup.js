/* 
 This file was generated by Dashcode and is covered by the 
 license.txt included in the project.  You may edit this file, 
 however it is recommended to first turn off the Dashcode 
 code generator otherwise the changes will be lost.
 */
var dashcodePartSpecs = {
    "blackColorChip": { "creationFunction": "CreatePushButton", "initialHeight": 28, "initialWidth": 30, "leftImageWidth": 1, "onclick": "colorChanged", "rightImageWidth": 1 },
    "blueColorChip": { "creationFunction": "CreatePushButton", "initialHeight": 28, "initialWidth": 30, "leftImageWidth": 1, "onclick": "colorChanged", "rightImageWidth": 1 },
    "done": { "creationFunction": "CreatePushButton", "initialHeight": 30, "initialWidth": 49, "leftImageWidth": 5, "onclick": "flipToFront", "rightImageWidth": 5, "text": "Done" },
    "familyTitle": { "creationFunction": "CreateText", "text": "Font" },
    "fontColor": { "creationFunction": "CreateText", "text": "Color" },
    "footer": { "creationFunction": "CreateText", "text": "Developed with Dashcode" },
    "greenColorChip": { "creationFunction": "CreatePushButton", "initialHeight": 28, "initialWidth": 30, "leftImageWidth": 1, "onclick": "colorChanged", "rightImageWidth": 1 },
    "infoButton": { "creationFunction": "CreatePushButton", "customImage": "Images/info.png", "customImagePosition": "PushButton.IMAGE_POSITION_CENTER", "customImagePressed": "Images/info_clicked.png", "initialHeight": 40, "initialWidth": 40, "leftImageWidth": 1, "onclick": "flipToSettings", "rightImageWidth": 1 },
    "purpleColorChip": { "creationFunction": "CreatePushButton", "initialHeight": 28, "initialWidth": 30, "leftImageWidth": 1, "onclick": "colorChanged", "rightImageWidth": 1 },
    "redColorChip": { "creationFunction": "CreatePushButton", "initialHeight": 28, "initialWidth": 30, "leftImageWidth": 1, "onclick": "colorChanged", "rightImageWidth": 1 },
    "reset": { "creationFunction": "CreatePushButton", "initialHeight": 33, "initialWidth": 157, "leftImageWidth": 5, "onclick": "clearSettings", "rightImageWidth": 5, "text": "Clear Settings" },
    "sizeTitle": { "creationFunction": "CreateText", "text": "Size" },
    "text": { "creationFunction": "CreateText", "text": "Settings" },
    "title": { "creationFunction": "CreateText", "text": "Utility" },
    "views": { "creationFunction": "CreateStackLayout", "subviewsTransitions": [{ "direction": "right-left", "duration": "", "timing": "ease-in-out", "type": "flip" }, { "direction": "right-left", "duration": "", "timing": "ease-in-out", "type": "flip" }] }
};