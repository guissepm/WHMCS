function validateapicredentialpage(obj)
{
    var req = false;
    $("#frmAPI input[type=text]").each(function(){
       if($(this).val()=='')
       {
		   req = true;
       }
    });

    if(req==true)
    {
        alert('Please complete all the fields!');
        return false;
    }
}
