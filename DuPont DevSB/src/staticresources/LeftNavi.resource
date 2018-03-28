// JavaScript Document

//expand & collapse container for LeftNavigation page// 
function toggle(srcElement,loc) 
   {   

	if ( document.getElementById('repeat')!=undefined){
	document.getElementById("repeat").style.display = "none";
	}
  
    if (document.getElementById(srcElement).style.display == "none")
	  	// document.getElementById("activeTxt").style.color= '#9d964c';//for active links //
 
    {
     document.getElementById(srcElement).style.display = "";


     for(i=1;i<=6;i++)
	 {
		if(i!=loc)
		{
		 
			document.getElementById('DivOLeft' + i).style.display = "none";
		}
	 }

    } 

    
   }
   
function HideAllSubDivs()
{
	document.getElementById("repeat").style.display = "none";
	for(i=1;i<=6;i++)
	 {
		document.getElementById('DivOLeft' + i).style.display = "none";
	 }
}

function HideAllSubDivsNews()
{

	document.getElementById("repeat").style.display = "block";
	for(i=1;i<=6;i++)
	 {
		document.getElementById('DivOLeft' + i).style.display = "none";
	 }
}

// Setting scroll position//
function scrollToTop() {
scroll(0,0);
}

// Dynamic Iframe height for IE and Mozilla Firefox//
    function calcHeight()
    {

        var bname = navigator.appName;
        var currentfr = document.getElementById('_frame');
        if (bname == "Microsoft Internet Explorer") {  
			try
			{
			var the_height = currentfr.contentWindow.document.body.scrollHeight;
            document.getElementById('_frame').height = the_height+30;
			scroll(0,0);    
			}
			catch(err)
			{
			}
            
        }
        else if (currentfr.contentDocument && currentfr.contentDocument.documentElement.scrollHeight) 
        { 
            currentfr.height = 1;
            currentfr.parentNode.style.height="auto";
            currentfr.height = currentfr.contentDocument.documentElement.scrollHeight+30+'px';
			scroll(0,0);
        }

     }	
 
	 
// Print content //
 function PrintThisPage()
{


window.frames['_frame'].focus();
window.frames['_frame'].print();


} 


window.onload = writ; 
    
        function writ()
    {          
        var a = parent._frame.document.URL;    
           
        var b = a.substring(a.indexOf('/apex/')+6,a.indexOf('?'));   
        var c = a.substring(a.indexOf('/apex/DMX_Stage?core.apexpages.devmode.url=1&')+45,a.indexOf('&rec_status'));   
        var d = a.substring(a.indexOf('/apex/DMX_SMPSteps?core.apexpages.devmode.url=1&')+45,a.indexOf('&ParentStageSeqNum'));   

		
		
		
        if(  (a.indexOf('&SeqNum=1')!=-1) || (a.indexOf('ParentStageSeqNum=1')!=-1) )
        {
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "block";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }                   
        }
        
         if(  (a.indexOf('&SeqNum=2')!=-1) || (a.indexOf('ParentStageSeqNum=2')!=-1))         
        {
		
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "block";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }
			        
        }
        
        if(  (a.indexOf('&SeqNum=3')!=-1) || (a.indexOf('ParentStageSeqNum=3')!=-1)) 
        {
		
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "block";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }
			       
        }
         if(  (a.indexOf('&SeqNum=4')!=-1) || (a.indexOf('ParentStageSeqNum=4')!=-1)) 
        {
		
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "block";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }
			        
        }
        if(  (a.indexOf('&SeqNum=5')!=-1) || (a.indexOf('ParentStageSeqNum=5')!=-1)) 
        {
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "block";    }
			       
        }               

                               
        if(b == "apex/DMX_SMPOverview" ||  b == "apex/apex/DMX_Contactus" || b == "apex/apex/DMX_Curricula" || b  == "apex/apex/DMX_FAQ" || b == "apex/apex/DMX_SMPOverview"  || (a.indexOf('DMX_NewsDetail')!=-1) || (a.indexOf('DMX_Contactus')!=-1) )
        {
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "none";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }
			
             
        }  
	 if ( b=="apex/DMX_News" || b=="apex/apex/DMX_News")
		{
			if ( document.getElementById('welcome')!=undefined)
			{    document.getElementById('welcome').style.display = "block";}			
			if ( document.getElementById('DivOLeft1')!=undefined)
			{    document.getElementById('DivOLeft1').style.display = "none";  }
			if ( document.getElementById('DivOLeft2')!=undefined)
			{ 	 document.getElementById('DivOLeft2').style.display = "none";    }			
			if ( document.getElementById('DivOLeft3')!=undefined)
			{    document.getElementById('DivOLeft3').style.display = "none";    }
			if ( document.getElementById('DivOLeft4')!=undefined)
			{    document.getElementById('DivOLeft4').style.display = "none";    }
			if ( document.getElementById('DivOLeft5')!=undefined)
			{    document.getElementById('DivOLeft5').style.display = "none";    }
					
		}	 
       
        setTimeout("writ()",500);  
    }    

  


