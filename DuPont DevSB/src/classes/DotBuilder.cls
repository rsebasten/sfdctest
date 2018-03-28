public class DotBuilder {

	public static SET<string> excludeFields = new SET<string>{ 'RecordTypeId','ConnectionSentId','ConnectionReceivedId','CreatedById','CreatedDate','CurrencyIsoCode','IsDeleted','LastModifiedDate','LastModifiedById','LastActivityDate' };
	public boolean showAllFields		{get; set;}
	public enum RelationGroup 				{ CHILD, PARENT, BOTH }
	public string sobjectType				{get; set;}
	public integer degree 					{get; set;}
	public boolean showPolymorphics			{get; set;}

	public DotData data					{get; private set;}

	//constructor
	public DotBuilder() {
		degree=2;
		showPolymorphics=true;
		showAllFields=true;
	}

	public void refreshData() {
		system.debug('refreshData: '+sobjectType);
		data = new DotData();
		data.allFields=showAllFields;
		data.add(sobjectType);
	}
	
	public string toDot() { return toDot(true); }
	public string toDot(boolean purdy) {
		string rtn='';
		system.debug('data-------------------->'+data);
		if (data!=null) 
		  rtn = data.toDot(purdy); 
		return rtn;
		
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////////////////	
	public class DotData {
		public boolean allFields {set; get;}
		public MAP<string,Relationship> relationSet = new MAP<string,Relationship>();
		public PortSet portSet = new PortSet();
							
		//add the relation of a sobject
		public void add(string sobjectType) {add(sobjectType,RelationGroup.BOTH);}
		public void add(string sobjectType, RelationGroup grp) {
			MetaData__c metaObj;
			try {
				if (allFields) {
					metaObj = [
						Select Id, Name,
							( Select name, ReferenceTo__c,  RelationShipName__c, ChildRelationShipName__c, CascadeDelete__c 
								from Children__r where Type__c='Field'),
							( Select name, parent__r.name, RelationShipName__c, ChildRelationShipName__c, CascadeDelete__c from ReferenceFrom__r)
					 	from Metadata__c 
						where recordType.DeveloperName='SObject' and Name=:sobjectType][0];
				}
				else {
					metaObj = [
						Select Id, Name,
							( Select name, ReferenceTo__c,  RelationShipName__c, ChildRelationShipName__c, CascadeDelete__c 
								from Children__r  Where Type__c='Field' AND subtype__c='REFERENCE'),
							( Select name, parent__r.name, RelationShipName__c, ChildRelationShipName__c, CascadeDelete__c 
							from ReferenceFrom__r)
					 	from Metadata__c 
						where recordType.DeveloperName='SObject' and Name=:sobjectType][0];					
				}		
			}
			catch (exception ex){}
		
			if (metaObj!=null) {
			
				//add the child relationships
				//childRelations+=sobjectType+':'+fieldName+':w -> '+sotype+':Id:e;';
				if (grp==RelationGroup.CHILD || grp==RelationGroup.BOTH) {
					Port pPort = portSet.add(metaObj.Name, 'Id');
					for (metadata__c cr : metaObj.ReferenceFrom__r) {
						Port cPort = portSet.add(cr.parent__r.name, cr.name);
						string relId = pPort.id+':'+cPort.id;
						if  (!relationSet.containsKey(relId))
							relationSet.put(relId,new Relationship(pPort, cPort, cr.CascadeDelete__c));
					}
				}
			
				if (grp==RelationGroup.PARENT || grp==RelationGroup.BOTH) {
					for (metadata__c pr : metaObj.Children__r) {
						if (!excludeFields.contains(pr.name)) {
							if (pr.ReferenceTo__c!=null) {
								if (pr.ReferenceTo__c=='polymorphic') {
									portSet.add(metaObj.Name,'∞← '+pr.name);
								}
								else {
									Port pPort = portSet.add(pr.ReferenceTo__c,'Id');
									Port cPort = portSet.add(metaObj.Name,pr.name);
									string relId = pPort.id+':'+cPort.id;
									if  (!relationSet.containsKey(relId))
										relationSet.put(relId,new Relationship(pPort, cPort, pr.CascadeDelete__c));
								}
							}
							else {
								//non-relational field
								portSet.add(metaObj.Name,pr.name);
							}
						}
					}
				}
			}
		} //add

		public string toDot(boolean purdy) {
			string rtn='';
			rtn='digraph "erd1" {';
			rtn+='graph[rankdir="RL" size="1200" ranksep="0.46" label="'+String.valueOf(DateTime.Now())+'" labeljust="l"];';
			rtn+=(purdy)?'node[shape="plaintext"];':'node[shape="record"];';
			rtn+='edge[arrowhead=normal arrowtail=crow];';
			string rdot='';
			for (string r : relationSet.Keyset())
				rdot+=relationSet.get(r).toDot();
			rtn+=rdot+portSet.toDot(purdy)+'}'; 
			return rtn;			
		}
		

	}//class: Relations
		
		
	////////////////////////////////////////////////////////////////////////////////////////			
	public class Relationship {
		public Port  parentPort			{get; set;}
		public Port  childPort			{get; set;}
		public string parentLabel		{get; set;}	
		public string childLabel		{get; set;}
		public boolean isMaster			{get; set;}
		Relationship(Port parent, Port child) { this(parent,child,false); }
		Relationship(Port parent, Port child, boolean master) {
			this.parentPort = parent;
			this.childPort 	= child;
			this.isMaster 	= master;
		}
		public string toDot() {
			string arrStyle=(isMaster)? '[arrowtail=crowodot]' : '';
			return childPort.dotName+':w->'+parentPort.dotName+':e'+arrStyle+';';
		}
		
	}
	////////////////////////////////////////////////////////////////////////////////////////		
	public class Port {
		public string id 	{get; private set;}
		public string node  {get; set;}		
		public string port  {get; set;}
		public Port(string sobjName,string fldName, string pid) {
			this.node	=sobjName;
			this.port	=fldName;
			this.id		=(pid!=null && port!='Id')?pid:this.port; //Id Port=Id then used the term 'Id' as the port Id
		}
		public string fullName {get{return node+'.'+port;}}
		public string dotName  {get{return node+':'+id;}}
	}

	////////////////////////////////////////////////////////////////////////////////////////	
	public class PortSet {
		private integer pidCnt=0;
		public Map<string,MAP<string,Port>> ports = new Map<string,MAP<string,Port>>();  //<MAP<sobjName(nodes),MAP<fldName,Port>>
		//private MAP<string,string> index = new MAP<string,string>();//can be used for shortening the portname in dot
		
		//like SET no dups
		public Port add(string sobjName,string fldName) {
			Port port=getPort(sobjName,fldName);
			if ( port==null ) {
				//create port and add to PortSet
				string pid='p'+pidCnt++;
				port=new Port(sobjName,fldName,pid);
				if (! ports.containsKey(port.node))
					ports.put(port.node, new MAP<string,Port>());
				ports.get(port.node).put(fldName,port);
				return port;
			}
			return port;
		}
		public port getPort(string sobjName,string fldName) {
			Port rtn;
			try { rtn=ports.get(sobjName).get(fldName); } catch(exception ex){}
			return rtn;
		}

		public string toDot(boolean purdy) {
			string rtn='';
			if (purdy) {
			for (string n: ports.keySet())
				rtn+=createNode(n);				
			}
			else {
				for (string n: ports.keySet())
					rtn+=createSimpleNode(n);
				}
			return rtn;
		}
		
		string createNode(string nodeName) {
				
				LIST<string> flds = orderFields(nodeName);
				boolean hasId=true; // (flds.size()>0 && flds[0]=='Id');
				
				String node='"'+nodeName+'" [label=<';
				node+='<TABLE>';
				node+='<TR><TD BGCOLOR="#9bcad9">'+nodeName+'</TD></TR>';
				node+=(hasId) ? '<TR><TD PORT="Id" BGCOLOR="#d5e2ea" ALIGN="LEFT">Id</TD></TR>':'';
				for (string f : flds) {
					node+='<TR><TD PORT="'+ports.get(nodeName).get(f).id+'" ALIGN="LEFT">'+f+'</TD></TR>';
				}
				node+='</TABLE>>];';
				return node;	
			}
	
		//nodename [label="<f0> one|<f1> two"]; 
		string createSimpleNode(string nodeName) {

				LIST<string> flds = orderFields(nodeName);
				String node=nodeName+' [label="';
				node+='<Id> '+nodeName+'|';
				for (string f : flds)
					node+='<'+ports.get(nodeName).get(f).id+'> '+f+'|';
				node=node.substring(0,node.length()-1)+'"]; ';
				return node;
		}

	
		private LIST<string> orderFields(string nodeName) {
			//order the fields (Id on TOP then alpha)
			LIST<string> flds = new LIST<string>();
			boolean hasId = false;
			if (ports.get(nodeName).containsKey('Id')) {
				hasId = true;
				ports.get(nodeName).remove('Id');
			}
			flds.addAll(ports.get(nodeName).keySet());
			flds.sort();
			//if (hasId) flds.add(0,'Id');
			return flds;
		}
	
	
	} //class: PortSet
	
////////////////////////////////////////////////////////////////////////////////////////

public static testMethod void testDotBuilder() {


	DotBuilder dBuilder=new DotBuilder();
	dBuilder.showAllFields=true;
	dBuilder.sobjectType = 'Metadata__c';
	dBuilder.refreshData();
	system.debug(dBuilder.toDot());
	
	}
	

}