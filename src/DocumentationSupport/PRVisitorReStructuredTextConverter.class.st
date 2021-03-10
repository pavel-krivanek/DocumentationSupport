"
I am a visitor of `PRObject`s to convert them in a reStructuredText representation.
"
Class {
	#name : #PRVisitorReStructuredTextConverter,
	#superclass : #PRVisitorAbstract,
	#instVars : [
		'writeStream',
		'selectors',
		'indentationLevel'
	],
	#category : #DocumentationSupport
}

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> indent: aString [

	^ ('  ' repeat: indentationLevel) , aString
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> initialize [

	super initialize.
	indentationLevel := 0.
	selectors := OrderedCollection withAll: #( forClassInclusionInDoc )
]

{ #category : #exporting }
PRVisitorReStructuredTextConverter >> metaExportInFileReference: aFileReference [

	^ MetaSTExporter new
		  selectors: selectors asArray;
		  exportInFileReference: aFileReference
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> recursiveStringOfPRObject: anObject [

	^ String streamContents: [ :aStream | "By copying we have a persistent `indentationLevel` but we share `selectors`, therefore
		 there is no need to explicit append them to have a final whole sequence of selectors."
		  self copy
			  writeStream: aStream;
			  visitAll: anObject children ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitAnnotatedParagraph: anObject [

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. note::');
			crlf;
			crlf.

		self withIndentation: [ 
			| aString |
			aString := self recursiveStringOfPRObject: anObject.
			self writeLinesOfString: aString ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitBoldFormat: anObject [

	| aString |
	aString := self recursiveStringOfPRObject: anObject.

	writeStream
		nextPutAll: '**';
		nextPutAll: (' ' join: (aString trim splitOn: Character cr));
		nextPutAll: '**'
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitClass: aClass ofMonospaceFormat: anObject [

	(aClass name includes: Character space)
		ifTrue: [ self writeStringInMonospace: aClass name ]
		ifFalse: [ 
			self withReSTEnv: [ 
				writeStream
					nextPutAll: (self indent: '.. pharo:autoclass:: ');
					nextPutAll: aClass name ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitClass: aClass selector: aSelector ofMonospaceFormat: anObject [

	| className |
	className := aClass name copyReplaceAll: ' ' with: '_'.

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. pharo:autocompiledmethod:: ');
			nextPutAll: className;
			nextPutAll: '>>#';
			nextPutAll: aSelector ].

	selectors add: aSelector
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitCodeblock: anObject [

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. code:: ');
			nextPutAll:
				(anObject parameters at: #language ifAbsent: [ 'smalltalk' ]);
			crlf;
			crlf.

		self withIndentation: [ 
			anObject text lines do: [ :each | 
				writeStream
					nextPutAll: (self indent: each);
					crlf ] ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitCommentedLine: anObject [

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. ');
			crlf.

		self withIndentation: [ 
			anObject text lines do: [ :each | 
				writeStream
					nextPutAll: (self indent: each);
					crlf ] ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitExternalLink: anObject [

	| scheme |
	scheme := anObject reference scheme.
	scheme = #ref
		ifTrue: [ self visitRefExternalLink: anObject ]
		ifFalse: [ 
			((Array with: #http with: #https) includes: scheme)
				ifTrue: [ self visitHtmlExternalLink: anObject ]
				ifFalse: [ 
					scheme = #include ifFalse: [ 
						self error:
							('a link with scheme {1} isn''t handled.' format: { scheme }) ] ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitFigure: anObject [

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. figure:: ');
			nextPutAll: anObject reference asString;
			crlf.

		self withIndentation: [ 
			| aString |
			aString := self recursiveStringOfPRObject: anObject.
			writeStream
				nextPutAll: (self indent: ':alt: ');
				nextPutAll: aString ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitHeader: anObject [

	| aString sub |
	aString := self recursiveStringOfPRObject: anObject.

	sub := #( = - #'^' '"' + )
		       at: anObject level
		       ifAbsent: [ $' asSymbol ].

	self withReSTEnv: [ "Headers should not be indented."
		writeStream
			nextPutAll: '.. _';
			nextPutAll: (aString copyReplaceAll: ' ' with: '-');
			nextPutAll: ':';
			crlf;
			crlf;
			nextPutAll: aString;
			crlf;
			nextPutAll: (sub asString repeat: aString size) ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitHorizontalRule: anObject [

	self withReSTEnv: [ 
		writeStream
			nextPutAll: (self indent: '.. raw:: html');
			crlf;
			crlf.

		self withIndentation: [ 
			writeStream nextPutAll: (self indent: '  <hr>') ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitHtmlExternalLink: anObject [

	| aString |
	aString := self recursiveStringOfPRObject: anObject.

	writeStream
		nextPutAll: '`';
		nextPutAll: aString;
		nextPutAll: ' <';
		nextPutAll: anObject reference asString;
		nextPutAll: '>`_'
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitItalicFormat: anObject [

	| aString |
	aString := self recursiveStringOfPRObject: anObject.

	writeStream
		nextPutAll: '*';
		nextPutAll: (' ' join: (aString trim splitOn: Character cr));
		nextPutAll: '* '
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitMonospaceFormat: anObject [

	| aString |
	aString := self recursiveStringOfPRObject: anObject.

	(Smalltalk classNamed: aString)
		ifNil: [ 
			| pair |
			pair := aString splitOn: '>>#'.
			pair size = 2
				ifTrue: [ 
					| aClass aSelector |
					aClass := Smalltalk classNamed: pair first.
					aSelector := Symbol findInternedSelector: pair second.
					(aClass isNotNil and: [ aSelector isNotNil ])
						ifTrue: [ 
							self
								visitClass: aClass
								selector: aSelector
								ofMonospaceFormat: anObject ]
						ifFalse: [ self writeStringInMonospace: aString ] ]
				ifFalse: [ self writeStringInMonospace: aString ] ]
		ifNotNil: [ :aClass | 
		self visitClass: aClass ofMonospaceFormat: anObject ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitOrderedList: anObject [

	self withReSTEnv: [ 
		anObject children withIndexDo: [ :each :index | 
			| aString |
			aString := self recursiveStringOfPRObject: each.

			writeStream
				nextPutAll: (self indent: index asString);
				nextPutAll: '.';
				crlf.

			self withIndentation: [ 
				aString linesDo: [ :aLine | 
					writeStream
						nextPutAll: (self indent: aLine);
						crlf ] ] ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitParagraph: anObject [

	self withReSTEnv: [ super visitParagraph: anObject ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitPreformatted: anObject [

	self withReSTEnv: [ 
		self withIndentation: [ 
			| aString |
			aString := self recursiveStringOfPRObject: anObject.
			self writeLinesOfString: aString ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitRefExternalLink: anObject [

	| aString |
	aString := self recursiveStringOfPRObject: anObject.

	writeStream
		nextPutAll: ':ref:`';
		nextPutAll: aString;
		nextPutAll: ' <';
		nextPutAll: anObject reference host;
		nextPutAll: '>`'
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitText: anObject [

	writeStream nextPutAll:
		(' ' join: (anObject text splitOn: Character cr))
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> visitUnorderedList: anObject [

	self withReSTEnv: [ 
		anObject children do: [ :each | 
			| aString |
			aString := self recursiveStringOfPRObject: each.

			writeStream
				nextPutAll: (self indent: '* ');
				crlf.

			self withIndentation: [ 
				aString linesDo: [ :aLine | 
					writeStream
						nextPutAll: (self indent: aLine);
						crlf ] ] ] ]
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> withIndentation: aBlock [

	indentationLevel := indentationLevel + 1.
	aBlock value.
	indentationLevel := indentationLevel - 1
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> withReSTEnv: aBlock [

	writeStream
		crlf;
		crlf.

	aBlock value.

	writeStream
		crlf;
		crlf
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> writeLinesOfString: aString [

	aString linesDo: [ :each | 
		writeStream
			nextPutAll: (self indent: '| ' , each);
			crlf ]
]

{ #category : #accessing }
PRVisitorReStructuredTextConverter >> writeStream: anObject [

	writeStream := anObject
]

{ #category : #'visiting-document' }
PRVisitorReStructuredTextConverter >> writeStringInMonospace: aString [

	writeStream
		nextPutAll: '``';
		nextPutAll: aString;
		nextPutAll: '``'
]
