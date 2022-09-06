/*html*/

/*入力内容を出力領域と送信用hiddenへセットする*/
var update_output_html_area = function(){
  var text = editor0.getValue();
  $("#html").val(text);
  $('#output_area').html(text);
};

/* 入力エリア内でキーを押すと、値をセットする */
$(document).on('keyup', '#editor0 .ace_text-input',function(){ update_output_html_area() });

var set_html = function(editor){
  window.editor0 = editor;
  $('#output_area').html(editor0.getValue());
  editor0.$blockScrolling = Infinity;
};
/*htmlここまで*/

/*js*/
var js_input_to_hidden = function(){ $("#js").val(editor1.getValue()) };

var update_output_js_area = function(){ $('#output_area_js').html("<script>" + editor1.getValue() + "</script>") };

/* reflect when keyup */
$(document).on("keyup", "#editor1 .ace_text-input", function(){ js_input_to_hidden() });

$(document).on("click", "#submit_js", function(){ update_output_js_area() });

var set_js = function(editor){
  window.editor1 = editor;
  update_output_js_area();
  editor1.$blockScrolling = Infinity;
};
/*jsここまで*/

/*css*/
var update_output_css_area = function(){  
  var text = editor2.getValue();
  $("#css").val(text);
  $('#output_area_css').html("<style>\n" + text + "</style>");
};

/* reflect when keyup */
$(document).on('keyup', '#editor2 .ace_text-input',function(){ update_output_css_area() });

var set_css = function(editor){
  window.editor2 = editor;
  update_output_css_area();
  editor2.$blockScrolling = Infinity;
};
/*cssここまで*/

/*yaml*/
var update_output_yaml_area = function(){ $("#yaml").val(editor3.getValue()) };

/* reflect when keyup */
$(document).on('keyup', '#editor3 .ace_text-input',function(){ update_output_yaml_area() });

var set_yaml = function(editor){
  window.editor3 = editor;
  update_output_yaml_area();
  editor3.$blockScrolling = Infinity;
};
/*yamlここまで*/

document.onkeydown = 
  function (e) {
    if (event.ctrlKey ){
      if (event.keyCode == 83){
        $("#save").click();
        event.keyCode = 0;
        return false;
      }
    }
  }

document.onkeypress = 
  function (e) {
    if (e != null){
      if ((e.ctrlKey || e.metaKey) && e.which == 115){
        $("#save").click();
        return false;
      }
    }
  }