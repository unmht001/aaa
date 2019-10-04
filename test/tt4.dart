


main(List<String> args) {
 var a="fasd asdfaf<br>    <br><br>\t<br>fasdfas"; 

a=a.replaceAll("<br>", "\n");
a=a.replaceAll("\t", "    ");
var b= a.split("\n");
  print(b);
  b.removeWhere((x)=>x==" "*x.length || x.isEmpty );

 print(b);
}

