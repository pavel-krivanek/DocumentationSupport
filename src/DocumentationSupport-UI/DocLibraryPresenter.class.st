"
A presenter of the documentaion library.

Currently the top-most UI. 

## Usage

```
DocLibraryPresenter open: #LibraryName.
```
"
Class {
	#name : #DocLibraryPresenter,
	#superclass : #DocModelPresenter,
	#instVars : [
		'library',
		'tree',
		'editor',
		'toolbar',
		'treeMenu'
	],
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #specs }
DocLibraryPresenter class >> defaultSpec [

	^ SpBoxLayout newVertical
		spacing: 3;
		add: #toolbar expand: false;
		add: (SpBoxLayout newHorizontal
			spacing: 10;
			add: #tree withConstraints: [  :constraints | constraints width: 300 ];
			add: #editor expand: true fill: true  ;
			yourself) expand: true
]

{ #category : #'instance creation' }
DocLibraryPresenter class >> on: aLibrary [ 

	^ self basicNew 
		library: aLibrary;
		initialize
]

{ #category : #opening }
DocLibraryPresenter class >> open: libraryName [

	<script>

	DocLibrary libraries ifEmpty: [ 
		DocLibrary loadFromRepositories ].
	(self on: (DocLibrary named: libraryName)) openWithSpec.

]

{ #category : #actions }
DocLibraryPresenter >> addNewBook [

	| newBook |
	
	newBook := library addNewBook.
		
	self updateTree.
	tree selectItem: newBook
]

{ #category : #actions }
DocLibraryPresenter >> addNewChapter [

	| newChapter |
	tree selectedItem ifNil: [ 
		self inform: 'No book or chapter selected'.
		^ self ].
	
	newChapter := tree selectedItem addNewChapter.
		
	self updateTree.
	tree selectItem: newChapter
]

{ #category : #events }
DocLibraryPresenter >> aspect: anAspect changedFrom: anOrigin [

	anOrigin = self ifTrue: [ ^ self ].
	
	anAspect = #books ifTrue: [ self updateTree ].	
	anAspect = #chapters ifTrue: [ self updateTree ].
	anAspect = #hierarchyNames ifTrue: [ self refreshTree ].
]

{ #category : #actions }
DocLibraryPresenter >> delete: anObject [

	((self confirm: 'Really delete ', anObject name, '?') = true)
		ifFalse: [ ^ self ].
	
	anObject delete.

	tree roots: tree roots.
	tree expandAll.
	

]

{ #category : #actions }
DocLibraryPresenter >> export [ 

	library repository export: library.
	library makeClean

]

{ #category : #initialization }
DocLibraryPresenter >> initializePresenters [ 

	super initializePresenters.
		
	tree := self newTree.
	editor := self instantiate: DocPanePresenter.
	editor parent: self.
	
	tree 
		roots: library books;
 		children: [ :aBookOrChapter | aBookOrChapter children ];
		displayIcon: [ :aBookOrChapter | aBookOrChapter icon ];
		display: [ :aBookOrChapter | aBookOrChapter title ];
		dragEnabled: true;
		dropEnabled: true;
		wantsDrop: [ :transfer | transfer passenger allSatisfy: [ :each | each isKindOf: DocChapter ] ];
		acceptDrop: [ :transfer | 		
			transfer target ifNotNil: [
				transfer target acceptDrop: transfer passenger ] ];
		expandAll.
		

		
	tree transmitTo: editor.
	
	self setupTreeMenu.
	
	self initializeToolbar.
	
	library whenAspectChangedNotify: self 

]

{ #category : #initialization }
DocLibraryPresenter >> initializeToolbar [

	toolbar := self newToolbar
		addStyle: 'stToolbar';
		fillWith: self toolbarActions;
		yourself
]

{ #category : #initialization }
DocLibraryPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Library';
		initialExtent: 1100@850;
		windowIcon: (self iconNamed: #book)
]

{ #category : #accessing }
DocLibraryPresenter >> library [

	^ library
]

{ #category : #accessing }
DocLibraryPresenter >> library: anObject [

	library := anObject
]

{ #category : #actions }
DocLibraryPresenter >> openChapter: aKey [

	| aChapter | 
	
	aChapter := library chapterOfKey: aKey.
	tree selectItem: aChapter.
		
	
	

]

{ #category : #actions }
DocLibraryPresenter >> openInWindow: item [

	item openIn: self application
]

{ #category : #tree }
DocLibraryPresenter >> refreshTree [ 

	tree refresh

]

{ #category : #tree }
DocLibraryPresenter >> setupTreeMenu [
	
	treeMenu := SpMenuPresenter new.
	treeMenu 
		addItem: [ :item | item
			icon: (self iconNamed: #open);
			name: 'Open in a new window';
			action: [ self openInWindow: tree selectedItem ] ].

	treeMenu 
		addItem: [ :item | item
			icon: (self iconNamed: #delete);
			name: 'Delete';
			action: [ self delete: tree selectedItem ] ].

	treeMenu 
		addItem: [ :item | item
			icon: (self iconNamed: #glamorousInspect);
			name: 'Inspect';
			action: [ tree selectedItem inspect ] ].

	tree contextMenu: treeMenu.

]

{ #category : #actions }
DocLibraryPresenter >> toolbarActions [

	^ CmCommandGroup forSpec
		register: (CmCommandGroup forSpec
			register: (DocExportCommand forSpecContext: self);
			register: (DocAddChapterCommand forSpecContext: self);
			register: (DocAddBookCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : #tree }
DocLibraryPresenter >> updateTree [

	tree roots: tree roots.
	tree expandAll.
	

]
