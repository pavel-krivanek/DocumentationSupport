Extension { #name : #DocBook }

{ #category : #'*DocumentationSupport-reStructured' }
DocBook >> classesAndCompiledMethodsOverChapter: aDocChapter bidirectionalDictionary: aDictionary [

	| builder tree visitor behaviours |
	builder := MicroDownParser builder.
	builder text: aDocChapter source.
	tree := MicroDownParser new parse: builder contents.
	visitor := PRVisitorClassOrMethodInChapterMapping new
		           visit: tree asPillar;
		           yourself.

	behaviours := visitor classes , visitor compiledMethods.

	aDictionary at: aDocChapter put: behaviours.

	behaviours do: [ :aClassOrCompiledMethod | 
		| aCollection |
		aCollection := aDictionary
			               at: aClassOrCompiledMethod
			               ifAbsentPut: [ OrderedCollection new ].

		aCollection add: aDocChapter ].

	aDocChapter children do: [ :each | 
		self
			classesAndCompiledMethodsOverChapter: each
			bidirectionalDictionary: aDictionary ]
]

{ #category : #'*DocumentationSupport-reStructured' }
DocBook >> classesAndCompiledMethodsOverChaptersBidirectionalDictionary [

	| aDictionary |
	aDictionary := Dictionary new.

	chapters do: [ :aChapter | 
		self
			classesAndCompiledMethodsOverChapter: aChapter
			bidirectionalDictionary: aDictionary ].

	^ aDictionary
]
