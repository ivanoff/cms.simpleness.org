/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
    config.toolbar_Full =
    [
	['Source','-','Save'],
	['Cut','Copy','Paste'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	['Image','Table','HorizontalRule','SpecialChar'],
	['TextColor','BGColor'],
	['Link','Unlink','Anchor','-','Templates'],
	'/',
	['Styles','Format','Font','FontSize'],
	['Bold','Italic','Underline','Strike'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['NumberedList','BulletedList','-','Subscript','Superscript','-','Outdent','Indent']
    ];
/*
    config.toolbar_Full =
    [
	['Source','-','Save','NewPage','Preview'],
	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat','-','Maximize', 'ShowBlocks'],
	'/',
	['Bold','Italic','Underline','Strike'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['NumberedList','BulletedList','-','Subscript','Superscript','-','Outdent','Indent','Blockquote','CreateDiv'],
	['Link','Unlink','Anchor','-','Templates'],
	'/',
	['Styles','Format','Font','FontSize'],
	['TextColor','BGColor'],
	['Image','Flash','Table','HorizontalRule','SpecialChar','PageBreak']
    ];
*/
};
