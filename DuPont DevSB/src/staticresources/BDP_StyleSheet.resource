.vfHelpText a            {position:relative;}
.vfHelpText a span       {display: none;}
.vfHelpText a:hover span {display: block;
                                  position:absolute;
                                  top:1.5em;
                                  padding:2px 5px;
                                  left:-60px; width:auto;
                                  z-index:100;
                                  border:1px solid orange;
                                  background-color:#FEFDB9;
                                  color:black; 
                                 }

input[type="checkbox"] {
    display:none;
}
input[type="checkbox"] + label span {
    display:inline-block;
    width:16px;
    height:19px;
    margin:-1px 4px 0 0;
    vertical-align:middle;
    background:url(https://one-dupont.my.salesforce.com/servlet/servlet.FileDownload?file=01513000003K0F7) left 0px top no-repeat;
    cursor:pointer;
}
input[type="checkbox"]:checked + label span {
    width:19px;
    height:19px;
    background:url(https://one-dupont.my.salesforce.com/servlet/servlet.FileDownload?file=01513000003K0F7) -15px top no-repeat;
}