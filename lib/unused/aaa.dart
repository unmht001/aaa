{
	// Place your snippets for dart here. Each snippet is defined under a snippet name and has a prefix, body and 
	// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the 
	// same ids are connected.
	// Example:
	// "Print to console": {
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }
	"data_state_function_widget1": {
		"prefix": "clsp1",
		"body": [
			"${5| ,static |}${6|default type, |} get $1 =>${2|data,state|}[\"$1\"]??($2[\"$1\"]=${3|default value, ,null|});",
			"$5set $1($6 v){",
			"    $2[\"$1\"]=v;",
			"    $4(v);}",
			"$5get ${4:$1AfterSetter}=>fn[\"$4\"]??([x]){};",
			"$5set $4(Function v)=>fn[\"$4\"]=v;",
		],
		"description": "data_state_function_widget"
	},
	"data_state_function_widget2": {
		"prefix": "clsp2",
		"body": [
			"${5| ,static |}${6|default type, |} get $1 =>${2|data,state|}[\"$1\"]??($2[\"$1\"]=${3|default value, ,null|});",
			"$5set $1($6 v)=>$2[\"$1\"]=v;",
		],
		"description": "data_state_function_widget"
	},
	"factory": {
		"prefix": "fct",
		"body": [
			"class ${1:App}  {",
			"    //$1 define --------------------",
			"    $1._internal();",
			"    static $1 _instance;",			
			"    static $1 _getInstance() => _instance ?? (_instance = $1._internal());",
			"    factory $1() => _getInstance();",
			"    static $1 get instance=>_getInstance();",
			"    //$1 define over ----------------",
			"}"
		],
		"description": "factory"
	}
}