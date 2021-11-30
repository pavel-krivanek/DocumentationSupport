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
		'treeMenu',
		'docSearchObject'
	],
	#classInstVars : [
		'searchInput',
		'indexChapter',
		'occurence'
	],
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #specs }
DocLibraryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 3;
		add: #toolbar expand: false;
		add: self searchBar withConstraints: [  :constraints | constraints height: 20 ];		
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
	^ (self on: (DocLibrary named: libraryName)) openWithSpec.

]

{ #category : #actions }
DocLibraryPresenter class >> searchAction: searchText on: occurenceDisplay [
	occurence := 1.
	self searchActionDisplayOn: occurenceDisplay.
]

{ #category : #specs }
DocLibraryPresenter class >> searchBar [

	| occurenceDisplay searchText occurenceCollection chapterDropList lastOccurenceByChapter |
	searchInput := SpTextInputFieldPresenter new placeholder: 'Enter you search'.
	occurenceCollection := OrderedCollection new.
	chapterDropList := (SpDropListPresenter new
				display: [ :chapter | (searchInput owner docSearchObject actualOccurence: chapter) actualOccurence chapter title ];
				whenSelectedItemChangedDo: [ :chapterOccurence |  
					indexChapter := lastOccurenceByChapter indexOf: chapterOccurence. 
					self droplistChapterAction: occurenceCollection on: occurenceDisplay ]).
	indexChapter := 1.
	occurence := 1.
	occurenceDisplay := SpTextInputFieldPresenter new beNotEditable.
	searchInput whenSubmitDo: [ 
		searchText = searchInput text
			ifTrue: [ [self nextAction: occurenceCollection on: occurenceDisplay] on: SubscriptOutOfBounds  do: [ "nothing" ] ]
			ifFalse: [ [self searchAction: occurence  on: occurenceDisplay.
						  occurenceCollection  := searchInput owner docSearchObject nbOccurence.
						  lastOccurenceByChapter := self setLastOccurenceByChapter: occurenceCollection.
						  chapterDropList items: lastOccurenceByChapter.
						  searchText := searchInput text] on: SubscriptOutOfBounds  do: [ "nothing" ] ] ].

	^ SpBoxLayout newHorizontal
		  add: searchInput;
		  add: (SpButtonPresenter new
				   label: 'Search';
				   action: [ [self searchAction: occurence  on: occurenceDisplay.
					   			 searchText := searchInput text] on: SubscriptOutOfBounds  do: [ "nothing" ] ])
		  height: 20;
		  add: (SpButtonPresenter new
				   label: 'Prev';
				   action: [ [self prevAction: occurenceCollection on: occurenceDisplay] on: SubscriptOutOfBounds  do: [ "nothing" ] ])
		  height: 20;
		  add: (SpButtonPresenter new
				   label: 'Next';
				   action: [ [self nextAction: occurenceCollection on: occurenceDisplay] on: SubscriptOutOfBounds  do: [ "nothing" ] ])
		  height: 20;
		  add: (SpButtonPresenter new
				   label: 'Prev Chapter';
				   action: [ [self prevChapterAction: occurenceCollection on: occurenceDisplay] on: SubscriptOutOfBounds  do: [ "nothing" ] ])
		  height: 20;
		  add: (SpButtonPresenter new
				   label: 'Next Chapter';
				   action: [ [self nextChapterAction: occurenceCollection on: occurenceDisplay] on: SubscriptOutOfBounds  do: [ "nothing" ] ])
		  height: 20;
		  add: chapterDropList;
		  add: (SpBoxLayout newHorizontal
				   add: (occurenceDisplay text: '0/0')
				   width: 295) 
			height: 20
]

{ #category : #specs }
DocLibraryPresenter class >> setHighlightAndClick: docSearch in: presenter [
	| searchIndex |
	searchIndex := docSearch actualOccurence ifNil: [ ^ nil ].
	DocRichTextComposer searchIndex: searchIndex  index.
	DocRichTextComposer searchSize: searchInput text size.
	DocRichTextComposer searchHighLightEnableOn: true.
	presenter clickOnTree: docSearch actualOccurence asClickPath.
	^ DocRichTextComposer searchHighLightEnableOn: false
]

{ #category : #initialization }
DocLibraryPresenter class >> setLastOccurenceByChapter: occurenceCollection [
	| lastChapterOccurence lastOccurenceByChapter |
	lastOccurenceByChapter := OrderedCollection new.
	lastChapterOccurence := 0.
	occurenceCollection doWithIndex: [ :o :i |  lastChapterOccurence := lastChapterOccurence + o. lastOccurenceByChapter add: lastChapterOccurence ].
	^ lastOccurenceByChapter
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

{ #category : #'as yet unclassified' }
DocLibraryPresenter >> clickOnTree: aCollection [
	tree clickAtPath: aCollection
]

{ #category : #actions }
DocLibraryPresenter >> delete: anObject [

	((self confirm: 'Really delete ', anObject name, '?') = true)
		ifFalse: [ ^ self ].
	
	anObject delete.

	tree roots: tree roots.
	tree expandAll.
	

]

{ #category : #accessing }
DocLibraryPresenter >> docSearchObject [
	^ docSearchObject
]

{ #category : #accessing }
DocLibraryPresenter >> docSearchObject: aDocSearchObject [
	docSearchObject := aDocSearchObject
]

{ #category : #actions }
DocLibraryPresenter >> export [ 

	library repository export: library.
	library makeClean

]

{ #category : #initialization }
DocLibraryPresenter >> initializePresenters [ 

	super initializePresenters.
	docSearchObject := DocSearchBook new.
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

	| aGroup commandClasses |
	
	aGroup := CmCommandGroup forSpec.
	commandClasses := DocStCommand allSubclasses sorted: [ :a :b | a priority <= b priority ].
	commandClasses do: [ :aCommandClass | 
		aGroup register: (aCommandClass forSpecContext: self) ].

	^ CmCommandGroup forSpec
		  register: aGroup;
		  yourself
]

{ #category : #tree }
DocLibraryPresenter >> updateTree [

	tree roots: tree roots.
	tree expandAll.
	

]
