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
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #specs }
DocLibraryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		spacing: 3;
		add: #toolbar expand: false
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
DocLibraryPresenter >> clickAt: path [
	tree clickAtPath: path
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
	docSearchObject := DocSearchEnvironment new.
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

{ #category : #'search bar' }
DocLibraryPresenter >> resetSearchEnv [
	searchEnv := nil.
	searchPattern := ''
]

{ #category : #api }
DocLibraryPresenter >> retrieveSpec: aSelector [
	| searchLayout |
	searchLayout := super retrieveSpec: aSelector.
	searchLayout add: self searchBar withConstraints: [  :constraints | constraints height: 20 ];
	add: (SpBoxLayout newHorizontal
			spacing: 10;
			add: #tree withConstraints: [  :constraints | constraints width: 300 ];
			add: #editor expand: true fill: true  ;
			yourself) expand: true.
	^ searchLayout
]

{ #category : #'search bar' }
DocLibraryPresenter >> searchAction [
	| chapters env |
	"Create collection with all chapters of the library"
	chapters := OrderedCollection new.
	searchInput owner library books do: [ :book | 
		chapters addAll: book chapters].
	"Execute the search"
	env:= DocSearchEnvironment on: (DocSearchRange chapters: chapters posInterval: (1 to: chapters first lastPosition)).
	env search: searchPattern.
	"Display the number of occurence"
	^ env

]

{ #category : #'search bar' }
DocLibraryPresenter >> searchBar [
	searchInput := SpTextInputFieldPresenter new placeholder: 'Enter you search'.
	occurenceDisplay := SpTextInputFieldPresenter new beNotEditable.
	self setSearchAction;
	setChapterDropList.

	^ SpBoxLayout newHorizontal
		  add: searchInput;
		  add: self setSearchButton
		  height: 20;
		  add: self setPreviousButton
		  height: 20;
		  add: self setNextButton
		  height: 20;
		  add: self setPreviousChapterButton
		  height: 20;
		  add: self setNextChapterButton
		  height: 20;
		  add: chapterDropList;
		  add: occurenceDisplay
]

{ #category : #accessing }
DocLibraryPresenter >> searchEnv [

	^ searchEnv
]

{ #category : #'search bar' }
DocLibraryPresenter >> setChapterDropList [
	chapterDropList := SpDropListPresenter new 
		help: 'Select the chapter.';
		display: [ :resultEntry | resultEntry chapter title ];
		whenSelectedItemChangedDo: [ :resultEntry | 
			searchEnv firstOccurrenceOf: resultEntry chapter.
			searchInput owner clickAt: resultEntry chapter path.
			self updateOccurenceDisplay ];
		extent: 400@20;
		yourself
]

{ #category : #'search bar' }
DocLibraryPresenter >> setLastOccurenceByChapter: occurenceCollection [
	| lastChapterOccurence lastOccurenceByChapter |
	lastOccurenceByChapter := OrderedCollection new.
	lastChapterOccurence := 0.
	occurenceCollection doWithIndex: [ :o :i |  lastChapterOccurence := lastChapterOccurence + o. lastOccurenceByChapter add: lastChapterOccurence ].
	^ lastOccurenceByChapter
]

{ #category : #'search bar' }
DocLibraryPresenter >> setNextButton [
	^ SpButtonPresenter new
				     label: 'Next';
				     action: [ 
							searchEnv ifNotNil: [ [ 
							searchEnv nextResultEntry.
							searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds  do: [ "nothing" ] ]  ]
]

{ #category : #'search bar' }
DocLibraryPresenter >> setNextChapterButton [
	^ SpButtonPresenter new
				     label: 'Next chapter';
				     action: [ 
							searchEnv ifNotNil: [ [ 
							searchEnv nextChapterInResultEntries.
							searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds  do: [ "nothing" ] ]  ]
]

{ #category : #'search bar' }
DocLibraryPresenter >> setPreviousButton [
	^ SpButtonPresenter new
					     label: 'Previous';
					     action: [ 
								searchEnv ifNotNil: [ [ 
								searchEnv prevResultEntry.
								searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds  do: [ "nothing" ] ]  ]
]

{ #category : #'search bar' }
DocLibraryPresenter >> setPreviousChapterButton [
	^ SpButtonPresenter new
				     label: 'Previous chapter';
				     action: [ 
							searchEnv ifNotNil: [ [ 
							searchEnv prevChapterInResultEntries.
							searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds  do: [ "nothing" ] ]  ]
]

{ #category : #'search bar' }
DocLibraryPresenter >> setSearchAction [
	searchInput whenSubmitDo: [ 
		searchPattern = searchInput text 
				ifTrue: [ 
					searchEnv ifNotNil: [ [ 
							searchEnv nextResultEntry.
							searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds  do: [ "nothing" ] ]
			   ] 
				ifFalse: [ 
					[ searchPattern := searchInput text.
					searchEnv := self searchAction.
					"Display in presenter the first occurence"
					searchInput owner clickAt: searchEnv currentResultEntry chapter path.
					chapterDropList items: searchEnv firstResultEntriesForEachChapters.
					self updateOccurenceDisplay ] on: SubscriptOutOfBounds,MessageNotUnderstood  do: [ "nothing" ].		
				]	].
			
]

{ #category : #'search bar' }
DocLibraryPresenter >> setSearchButton [
	^ SpButtonPresenter new
					   label: 'Search';
					   action: [ [
							searchPattern := searchInput text.
							searchEnv := self searchAction.
							"Display in presenter the first occurence"
							searchInput owner clickAt: searchEnv currentResultEntry chapter path.
							chapterDropList items: searchEnv firstResultEntriesForEachChapters.
							self updateOccurenceDisplay ] on: SubscriptOutOfBounds,MessageNotUnderstood  do: [ "nothing" ]  ]
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

{ #category : #'search bar' }
DocLibraryPresenter >> updateOccurenceDisplay [
	occurenceDisplay text: searchEnv currentEntryIndex asString , '/' , searchEnv resultEntries size asString , ' in ', searchEnv currentResultEntry chapter title
]

{ #category : #tree }
DocLibraryPresenter >> updateTree [

	tree roots: tree roots.
	tree expandAll.
	

]
