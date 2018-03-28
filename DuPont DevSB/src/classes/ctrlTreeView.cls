public class ctrlTreeView {

public string   selectedValue               {get; set;}  
public INode top							{get; set;}
public boolean showTop                      {get; set;}
public string JS_OnSelect                   {get; set;}
public string JS_OnHover                    {get; set;}
//public MAP<string,Node> topMap                {get; set;}

public string   selectedparentId            {get; set;}
public boolean  dynamic                     {get; set;}  //cyclic pull


 public ctrlTreeView() {
    showTop=true;
	dynamic=false;
 }
 
public string NodeAsLI {
    GET { 
        string rtn='';
		if (top!=null) {
			rtn+='<UL class="treeview">';
	        if (showTop) {
	            top.setexpanded(true);
	            rtn+=getNodeAsLI(top);
	        }
	        else {
	            for (INode c : top.getChildren()) {
	                rtn+=getNodeAsLI(c);    
	            }
	        }
			rtn+='</UL>';
		}
        system.debug('NodeAsLI:'+rtn);
        return rtn; 
    }
}

// jQuery.treeview Notes.
//If first node after expandable div is an ancor <A> then the node text is treated as a select 
//and will not toggle collapse/expand,  (ie.you can do both (select and toogle) by packing in <span>

private string getNodeAsLI(INode node) {
			string rtn='';
			string liClass='';
			LIST<INode> ns = node.getChildren();
			
			string title=(node.getTitle()!=null) ? 'title="'+node.getTitle()+'"' : '';
			if (dynamic && ns.size()==0 && node.getchildrenLoaded()!=true )
				liClass='class="closed unloaded"';
			else if (node.getexpanded())
				liClass='class="open"';
    
            rtn+='<LI '+liClass+' id="'+node.getid()+'" '+title+'>'; //'<div class="'+hitareaClass+'"></div>';
            
            if (node.getselectable()) 
            	rtn+='<span class="selectable '+node.getnodeType()+'">'+node.getlabel()+'</span>'; 
            else
            	rtn+='<span class="unselectable '+node.getnodeType()+'">'+node.getlabel()+'</span>'; 
            
            if (ns!=null && ns.size()>0) {
                rtn+='<UL>';
	            for (INode c : ns) {
	                    rtn+=getNodeAsLI(c);
	            }
            	rtn+='</UL>';
            }else if (dynamic && ( node.getchildrenLoaded()==null || (!node.getchildrenLoaded())))
				rtn+='<UL style="display: none;"></UL>'; //force a [+] if dynamic and children have yet been determined
				
            rtn+='</LI>';
            return rtn;
}

}