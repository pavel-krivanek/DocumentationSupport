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
DocBook >> addCSS: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock [
	aDictionnary at: #header,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #header) add: (aBlock value: value) ].
	aDictionnary at: #text,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #text) add: (aBlock value: value) ].
	aDictionnary at: #bold,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #bold) add: (aBlock value: value) ].
	aDictionnary at: #italic,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #italic) add: (aBlock value: value) ].
	aDictionnary at: #strike,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #strike) add: (aBlock value: value) ].
	aDictionnary at: #monospace,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #monospace) add: (aBlock value: value) ].
	aDictionnary at: #link,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #link) add: (aBlock value: value) ].
	aDictionnary at: #code,aSymbol ifPresent: [ :value | (aCSSDictionnary at: #code) add: (aBlock value: value) ].
]

{ #category : #'css-API' }
DocBook >> addCSSBackGroundColor: aDictionnary in: aCSSDictionnary [ 
	self addCSSWithOpacity: aDictionnary 
		  in: aCSSDictionnary 
		  type: #BackgroundColor
		  attribute: [ :colorString :float | self backgroundColorClass new color: ((Color fromString: colorString) alpha: float) ]
]

{ #category : #'css-API' }
DocBook >> addCSSColor: aDictionnary in: aCSSDictionnary [
	self addCSSWithOpacity: aDictionnary 
		  in: aCSSDictionnary 
		  type: #Color 
		  attribute: [ :colorString :float | self textColorClass new color: ((Color fromString: colorString) alpha: float) ]
]

{ #category : #'css-API' }
DocBook >> addCSSPoliceSize: aDictionnary in: aCSSDictionnary [
	aDictionnary at: #headerSize ifPresent: [ :value | aCSSDictionnary at: #headerSize put: (self generateHeaderSize: value) ].
	aDictionnary at: #textSize ifPresent: [ :value | aCSSDictionnary at: #textSize put: value asInteger ].
	aDictionnary at: #boldSize ifPresent: [ :value | aCSSDictionnary at: #boldSize put: value asInteger ].
	aDictionnary at: #italicSize ifPresent: [ :value | aCSSDictionnary at: #italicSize put: value asInteger ].
	aDictionnary at: #strikeSize ifPresent: [ :value | aCSSDictionnary at: #strikeSize put: value asInteger ].
	aDictionnary at: #monospaceSize ifPresent: [ :value | aCSSDictionnary at: #monospaceSize put: value asInteger ].
	aDictionnary at: #linkSize ifPresent: [ :value | aCSSDictionnary at: #linkSize put: value asInteger ].
	aDictionnary at: #codeSize ifPresent: [ :value | aCSSDictionnary at: #codeSize put: value asInteger ].
]

{ #category : #'css-API' }
DocBook >> addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock [
	aDictionnary at: #header,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #header ].
	aDictionnary at: #text,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #text ].
	aDictionnary at: #bold,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #bold ].
	aDictionnary at: #italic,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #italic ].
	aDictionnary at: #strike,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #strike ].
	aDictionnary at: #monospace,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #monospace ].
	aDictionnary at: #link,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #link ].
	aDictionnary at: #code,aSymbol ifPresent: [ :value | self addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: value eltType: #code ].
]

{ #category : #'css-API' }
DocBook >> addCSSWithOpacity: aDictionnary in: aCSSDictionnary type: aSymbol attribute: aBlock firstValue: aFirstvalue eltType: aSymbolElt [
	aDictionnary at: aSymbolElt,aSymbol,#Opacity 
		ifPresent: [ :value | (aCSSDictionnary at: aSymbolElt) add: (aBlock value: aFirstvalue value: (Float readFrom:  value)) ]
		ifAbsent: [ (aCSSDictionnary at: aSymbolElt) add: (aBlock value: aFirstvalue value: 1) ]
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

{ #category : #'css-API' }
DocBook >> backgroundColorClass [
	^ TextBackgroundColor
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
		at: #textSize put: 10;
		at: #boldSize put: 10;
		at: #italicSize put: 10;
		at: #strikeSize put: 10;
		at: #monospaceSize put: 10;
		at: #linkSize put: 10;
		at: #codeSize put: 10;
		yourself
]

{ #category : #'css-API' }
DocBook >> createEmptyCSS: aDefaultPoliceSize [
	^ Dictionary new at: #header put: OrderedCollection new;
		at: #text put: OrderedCollection new;
		at: #bold put: OrderedCollection new;
		at: #italic put: OrderedCollection new;
		at: #strike put: OrderedCollection new;
		at: #monospace put: OrderedCollection new;
		at: #link put: OrderedCollection new;
		at: #code put: OrderedCollection new;
		
		at: #headerSize put: OrderedCollection new;
		at: #textSize put: aDefaultPoliceSize;
		at: #boldSize put: aDefaultPoliceSize;
		at: #italicSize put: aDefaultPoliceSize;
		at: #strikeSize put: aDefaultPoliceSize;
		at: #monospaceSize put: aDefaultPoliceSize;
		at: #linkSize put: aDefaultPoliceSize;
		at: #codeSize put: aDefaultPoliceSize;
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
	css := self createEmptyCSS: 10.
	self addCSSColor: aDictionary in: css;
	addCSSBackGroundColor: aDictionary in: css;
	addCSSPoliceSize: aDictionary in: css.
	DocBook at: key put: css. 
]

{ #category : #'css-API' }
DocBook >> generateHeaderSize: aStringOfInteger [
	| headerSizeCollection |
	headerSizeCollection := OrderedCollection new.
	(aStringOfInteger findTokens: ' ') do: [ :intergerString | 
		headerSizeCollection add: (TextFontReference toFont: (LogicalFont familyName: 'Source Sans Pro' pointSize: intergerString asInteger)) ].
	^ headerSizeCollection
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

{ #category : #'css-API' }
DocBook >> textColorClass [
	^ TextColor
]

{ #category : #'css-API' }
DocBook >> textFontReference: aPoliceName size: aSize [
	^ (TextFontReference
				toFont:
					(LogicalFont 
						familyName: 'Source Sans Pro'
						pointSize: 24))
]
