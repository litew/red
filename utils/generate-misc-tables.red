Red [
	Title:   "Red runtime lexer"
	Author:  "Nenad Rakocevic"
	File: 	 %generate-misc-tables.red
	Tabs:	 4
	Rights:  "Copyright (C) 2014-2018 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]


gen-bitarray: function [list][
	append/dup out: make binary! 32 null 32

	foreach c list [
		pos: (to-integer c) / 8 + 1
		bit: 1 << ((to-integer c) // 8)
		out/:pos: out/:pos or bit
	]
	?? out
]

bin-classes: [
	C_BIN_SKIP										;-- 0
	C_BIN_BLANK										;-- 1
	C_BIN_LINE										;-- 2
	C_BIN_HEXA										;-- 3
	C_BIN_COMMENT									;-- 4
]

gen-bin16-table: function [][
	out: make binary! 256
	blank: charset "^-^M "
	hexa:  charset [#"A" - #"F" #"a" - #"f" #"0" - #"9"]
	
	repeat i 256 [
		c: to-char i - 1
		append out to-char case [
			find blank c [1]
			c = #"^/"    [2]
			find hexa c  [3]
			c = #";"	 [4]
			'else		 [0]
		]
	]
	print "--gen-bin16-table-- (lexer/bin16-classes)"
	probe out
]

gen-hexa-table: function [][
	out: make binary! 256
	digit: charset [#"0" - #"9"]
	upper: charset [#"A" - #"F"]
	lower: charset [#"a" - #"f"]
	
	repeat i 256 [
		c: to-char i - 1
		append out to-char case [
			find digit c [c - #"0"]
			find upper c [c - #"A" + 10]
			find lower c [c - #"a" + 10]
			'else		 [0]
		]
	]
	print "--gen-hexa-table-- (lexer/hexa-table)"
	probe out
]

gen-bitarray probe "BDELNPTbdelnpt"
gen-bitarray probe {/-~^^{}"}
gen-bin16-table
gen-hexa-table