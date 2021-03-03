"
`name` - library name, identification of the library. Should be unique.
`books` - collection of books
`repository` - a repository attached to the library

Class side variables: 
`Libraries` - global dictionary of libraries. Clean using `cleanLibraries`
"
Class {
	#name : #DocLibrary,
	#superclass : #DocModel,
	#instVars : [
		'name',
		'books',
		'dirty',
		'repository'
	],
	#classVars : [
		'Libraries'
	],
	#category : #'DocumentationSupport-Model'
}

{ #category : #libraries }
DocLibrary class >> addLibrary: aLibrary [

	self libraries at: aLibrary name put: aLibrary.
	aLibrary makeClean
]

{ #category : #libraries }
DocLibrary class >> addNewLibraryNamed: aString [ 

	| newLibrary |
	
	newLibrary := self new.
	newLibrary name: aString.
	self libraries at: aString put: newLibrary.
	^ newLibrary 
]

{ #category : #libraries }
DocLibrary class >> clearLibraries [
 
	<script>
	
	^ Libraries := Dictionary new
]

{ #category : #libraries }
DocLibrary class >> libraries [ 

	^ Libraries ifNil: [ Libraries := Dictionary new ]
]

{ #category : #loading }
DocLibrary class >> loadFrom: aDocLibraryReposotoroy [

	| libs |
	
	libs := aDocLibraryReposotoroy libraries. 
	
	libs do: [ :each | 
		self addLibrary: each ].
	
	libs do: [ :each | each makeClean ].
]

{ #category : #loading }
DocLibrary class >> loadFromRepositories [

	self repositories do: [ :aRepository | 
		self loadFrom: aRepository  ]
]

{ #category : #'instance creation' }
DocLibrary class >> named: aString [ 

	^ self libraries at: aString
]

{ #category : #private }
DocLibrary class >> repositories [ 

	^ (Pragma allNamed: #documentationRepository) collect: [ :pragma | 
		pragma methodClass instanceSide perform: pragma methodSelector ]

]

{ #category : #visiting }
DocLibrary >> acceptVisitor: aVisitor [ 

	aVisitor visitLibrary: self
]

{ #category : #adding }
DocLibrary >> addNewBook [

	| newBook |
	
	self makeDirty.
	newBook := DocBook new. 
	newBook library: self.
	newBook parent: self.
	books add: newBook.
	self aspectChanged: #books.
	^ newBook
]

{ #category : #accessing }
DocLibrary >> books [

	^ books
]

{ #category : #accessing }
DocLibrary >> books: anObject [
	books := anObject
]

{ #category : #accessing }
DocLibrary >> chapterOfKey: aKey [ 

	books do: [ :each |
		(each chapterOfKey: aKey)
			ifNotNil: [ :result | ^ result ] ].
		
	^ nil 
]

{ #category : #removing }
DocLibrary >> deleteBook: aBook [ 

	books remove: aBook.
	self makeDirty.
	self aspectChanged: #books.


]

{ #category : #accessing }
DocLibrary >> dirty [ 

	^ dirty ifNil: [ dirty := false ]
]

{ #category : #'serialization support' }
DocLibrary >> fixParentReferencesUsing: aDictionary [

	self books do: [ :each | 
		each fixParentReferencesUsing: aDictionary  ]
]

{ #category : #initialization }
DocLibrary >> initialize [ 

	super initialize.
	
	books := OrderedCollection new.
]

{ #category : #accessing }
DocLibrary >> key [ 

	^ nil
]

{ #category : #dirty }
DocLibrary >> makeClean [ 

	dirty := false
]

{ #category : #dirty }
DocLibrary >> makeDirty [ 

	dirty := true
]

{ #category : #accessing }
DocLibrary >> name [

	^ name
]

{ #category : #accessing }
DocLibrary >> name: anObject [

	name := anObject.
	self makeDirty.

]

{ #category : #accessing }
DocLibrary >> repository [ 

	^ repository
]

{ #category : #accessing }
DocLibrary >> repository: anObject [

	repository := anObject
]
