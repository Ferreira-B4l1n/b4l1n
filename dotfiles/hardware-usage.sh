#!/bin/bash

awk_functions='function ceil(valor){ 
		return (valor==int(valor)) ? int(valor) : int(valor)+1
	}
	function valify(valor){
		return (valor>=1) ? 0.9999 : valor
	}
	function get_bar_number(ratio){
		return int(valify(ceil(10 * ratio)/10.1)*10)
	}'
out=`free | awk " ${awk_functions}
	FNR>1 { print get_bar_number(\\$3/\\$2); }"`
cpu_out=`grep 'cpu ' /proc/stat | awk "${awk_functions} {usage=(\\$2+\\$4)/(\\$2+\\$4+\\$5)} END {print get_bar_number(usage)}"`

function colorize(){
	echo "<span color='$2'>$1</span>";
}

function get_word(){
	echo $1 | awk "{ print \$$2 }"
};
function symbolize(){
	echo "<span font='SexyFont'>$1</span>"
}
out1="MEM: `symbolize $(get_word "$out" 1)`"
out2="SWP: `symbolize $(get_word "$out" 2)`"
out3="CPU: `symbolize $cpu_out`"
echo `colorize "$out1" \#00ffff` `colorize "$out2" \#ff00ff` `colorize "$out3" \#ffff00`