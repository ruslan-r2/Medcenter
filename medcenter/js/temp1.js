/*
$("#TextInsert").click(function(){
    var _text = $("#TextSelect").val();
    $("#OutPut").append(" " + _text );
    $("#OutPut").focus();
    console.log(_text);
});
*/
$("#TextInsert").click(function(){
    var _text = $("#TextSelect").val();
    $('#OutPut').val($('#OutPut').val()+_text); 
});