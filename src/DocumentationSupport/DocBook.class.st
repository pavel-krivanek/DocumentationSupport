"
A collection of chapters. Books cannot be nested.
"
Class {
	#name : #DocBook,
	#superclass : #DocModelWithKey,
	#instVars : [
		'chapters'
	],
	#classInstVars : [
		'cssDictionnary'
	],
	#category : #'DocumentationSupport-Model'
}

{ #category : #accessing }
DocBook class >> at: aKey [
	cssDictionnary ifNil: [ ^ nil ].
	cssDictionnary at: aKey ifPresent: [ :value | ^ value ]
]

{ #category : #accessing }
DocBook class >> at: aKey put: aCSSDictionnary [
	cssDictionnary ifNil: [ cssDictionnary := Dictionary new ].
	cssDictionnary at: aKey put: aCSSDictionnary
]

{ #category : #'drag and drop' }
DocBook >> acceptChapter: aChapter [ 

	aChapter library = self library ifFalse: [ ^ self ].

	(self hasSubchapter: aChapter) ifTrue: [ 
		aChapter parent: self.
		library aspectChanged: #chapters.
		^ self ].
	
	"from antother book"
	aChapter withAllSubchapters do: [ :each |
		self takeChapter: each ].
	
	aChapter parent: self.
	
	library aspectChanged: #chapters.

]

{ #category : #visiting }
DocBook >> acceptVisitor: aVisitor [ 

	aVisitor visitBook: self
]

{ #category : #'css-API' }
DocBook >> addCSSColor: aDictionnary in: aCSSDictionnary [ 
	aDictionnary at: #headerColor ifPresent: [ :value | (aCSSDictionnary at: #header) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #textColor ifPresent: [ :value | (aCSSDictionnary at: #text) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #boldColor ifPresent: [ :value | (aCSSDictionnary at: #bold) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #italicColor ifPresent: [ :value | (aCSSDictionnary at: #italic) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #strikeColor ifPresent: [ :value | (aCSSDictionnary at: #strike) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #monospaceColor ifPresent: [ :value | (aCSSDictionnary at: #monospace) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #linkColor ifPresent: [ :value | (aCSSDictionnary at: #link) add: (TextColor new color: (Color fromString: value)) ].
	aDictionnary at: #codeColor ifPresent: [ :value | (aCSSDictionnary at: #code) add: (TextColor new color: (Color fromString: value)) ].
]

{ #category : #adding }
DocBook >> addChapter: aChapter [ 

	self makeDirty.
	aChapter parent: self.
	chapters add: aChapter.
	^ aChapter

]

{ #category : #adding }
DocBook >> addNewChapter [

	| newChapter |
	
	newChapter := self addNewChapterWithoutNotification.
	library aspectChanged: #chapters.
	DocChapter addDictionaryOfChapters: newChapter.
	^ newChapter
]

{ #category : #adding }
DocBook >> addNewChapterWithoutNotification [

	| newChapter |
	
	newChapter := DocChapter new.
	newChapter library: self library.
	self addChapter: newChapter.
	^ newChapter
]

{ #category : #accessing }
DocBook >> book [ 

	^ self
]

{ #category : #accessing }
DocBook >> chapterOfKey: aKey [ 

	^ chapters detect: [ :each | each key = aKey ] ifNone: [ nil ].
]

{ #category : #accessing }
DocBook >> chapters [ 

	^ chapters
]

{ #category : #accessing }
DocBook >> chapters: anObject [

	chapters := anObject
]

{ #category : #accessing }
DocBook >> children [ 

	^ self sortedChapters: (chapters select: [ :each | each parent = self ])
]

{ #category : #'css-API' }
DocBook >> createEmptyCSS [
	^ Dictionary new at: #header put: OrderedCollection new;
		at: #text put: OrderedCollection new;
		at: #bold put: OrderedCollection new;
		at: #italic put: OrderedCollection new;
		at: #strike put: OrderedCollection new;
		at: #monospace put: OrderedCollection new;
		at: #link put: OrderedCollection new;
		at: #code put: OrderedCollection new;
		at: #headerSize put: OrderedCollection new;
		yourself
]

{ #category : #removing }
DocBook >> delete [ 

	self chapters do: [ :chapter | chapter ifNotNil: [ self deleteChapter: chapter ] ].
	self library deleteBook: self.
	self makeDirty.
	library aspectChanged: #chapters.


]

{ #category : #removing }
DocBook >> deleteChapter: aChapter [ 

	aChapter subchapters do: [ :each | 
		self deleteChapter: each ].

	chapters remove: aChapter.
	chapters do: [ :each | 
		each chapterRemoved: aChapter ].
	DocChapter removeDictionaryOfChapters: aChapter.
	library aspectChanged: #chapters.

	

]

{ #category : #'serialization support' }
DocBook >> fixParentReferencesUsing: aDictionary [

	self chapters do: [ :each |
		each fixParentReferencesUsing: aDictionary ].

	parent ifNil: [ ^ self ].
	parent isParentReference ifFalse: [ ^ self ].
	
	parent := parent key 
		ifNil: [ nil ]
		ifNotNil: [ aDictionary at: parent key ]
]

{ #category : #'css-API' }
DocBook >> generateCSS: aDictionary [
	| css |
	css := self createEmptyCSS.
	self addCSSColor: aDictionary in: css.
	DocBook at: key put: css. 
]

{ #category : #accessing }
DocBook >> hasSubchapter: aChapter [

	^ chapters includes: aChapter
]

{ #category : #initialization }
DocBook >> initialize [ 

	super initialize.
	
	chapters := OrderedCollection new.
]

{ #category : #accessing }
DocBook >> readMetadataFrom: aDictionary [
	super readMetadataFrom: aDictionary.
	self generateCSS: aDictionary.
	
	
	
]

{ #category : #accessing }
DocBook >> setLibrary: aLibrary [ 

	super setLibrary: aLibrary.
	chapters do: [ :each | each setLibrary: aLibrary ].
]

{ #category : #adding }
DocBook >> takeChapter: aChapter [ 

	"change ownership"

	aChapter book chapters remove: aChapter.
	self chapters add: aChapter 
]
