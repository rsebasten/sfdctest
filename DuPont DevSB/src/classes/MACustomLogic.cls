/*******************************************************************************
CopyrightÂ© 2016 DuPont. All rights reserved.
Author: Matt Peoples 
Email: mpeoples@mapanything.com
Description: Customization for Map Anything Batches
********************************************************************************/
/*
 * Modification log
 * ==================================================================================================
 * ver                         Date                  Author                              Modification                        TimeStamp
 * ---                         ----                  --------------                      ------------                        ---------------  
 * 1.0                       2016-12-21              Saurabh Agrawal                   Modified the Class for removing hard color coded values    SA20162112
*/

public class MACustomLogic {
    
    public static list<string> HexColorsList = new list<string> {
                                         '#7fffd4', '#9370d8', '#008000', '#ff0000', '#9acd32', '#ff00ff', '#ff8c00', '#dc143c', '#00ffff', '#3cb371', '#c71585', '#191970', '#ffa500', '#2e8b57', '#40e0d0', '#808000', '#8b4513', '#008080', '#ff6347', '#ffff00', 
                                         '#48d1cc', '#8b0000', '#008b8b', '#8a2be2', '#f0ffff', '#00ffff', '#8fbc8f', '#4b0082', '#e6e6fa', '#cd5c5c', '#e0ffff', '#f08080', '#add8e6', '#add8e6', '#20b2aa', '#ffa07a', '#7cfc00', '#ffffe0', '#32cd32', '#cd853f',
                                         '#ee82ee', '#8b008b', '#da70d6', '#ff4500', '#eee8aa', '#afeeee', '#87ceeb', '#800080', '#ff7f50', '#ffe4c4', '#f0fff0', '#e9967a', '#9400d3', '#b22222', '#ff1493', '#00bfff', '#ff69b4', '#00ff00', '#800000', '#d2b48c',
                                         '#66cdaa', '#f5fffa', '#ffe4e1', '#d87093', '#98fb98', '#fa8072', '#a0522d', '#00ff7f', '#4682b4', '#4169e1', '#adff2f', '#00ced1', '#a52a2a', '#9932cc', '#483d8b', '#1e90ff', '#00fa9a', '#ffe4b5', '#000080', '#6b8e23', 
                                         '#d2691e', '#7fff00', '#006400', '#556b2f', '#deb887', '#ffc0cb', '#b0e0e6', '#bc8f8f', '#7b68ee', '#ba55d3', '#f4a460', '#dda0dd', '#ffb6c1', '#87cefa', '#778899', '#b0c4de', '#90ee90', '#228b22', '#ff00ff', '#d8bfd8',
                                         '#00008b', '#b8860b', '#f0f8ff', '#0000ff', '#daa520', '#ffd700', '#0000cd'};   
    
    public static void MACreateShapeLayersByContactBatchable_Execute(List<Contact> scope)
    {
        string shapeLayerFolderId = '';

        for (sma__MAFolder__c Sfolder : [SELECT Id, Name FROM sma__MAFolder__c WHERE Name = 'By Contact' AND sma__ParentFolder__r.Name = 'State'])
        {
            shapeLayerFolderId = Sfolder.Id;
        }
        
        if (shapeLayerFolderId != '')
        {
            Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('BI-NA Opportunity Owner 2').getRecordTypeId();
            
            list<string> recordIds = new list<string>();
            
            for (Contact con : scope)
            {
                recordIds.add(con.Id);
            }
            
            map<string, list<Geography_Mapping__c>> ContactGeoMappingMap = new map<string, list<Geography_Mapping__c>>();
            
            for (Geography_Mapping__c geomap : [SELECT Id, Name, Account__c, Contact__c, Geography__r.Name, Geography__c, Owning_Organization__c, User__C, Geography__r.Code__C, Geography__r.Level__c, Geography__r.Level_Name__c, Geography__r.Numeric_Code__c, Geography__r.Code2__c 
                                                FROM Geography_Mapping__c WHERE Contact__c IN :recordIds AND RecordTypeId = :GeoMappingRecordTypeId AND Owning_Organization__c='BI-Surf'])
            {
                if (ContactGeoMappingMap.containsKey(geomap.Contact__c))
                {
                    list<Geography_Mapping__c> TempGeoMappingList = ContactGeoMappingMap.get(geomap.Contact__c);
                    TempGeoMappingList.add(geomap);
                    ContactGeoMappingMap.put(geomap.Contact__c, TempGeoMappingList);
                }
                else
                {
                    list<Geography_Mapping__c> TempGeoMappingList = new list<Geography_Mapping__c>();
                    TempGeoMappingList.add(geomap);
                    ContactGeoMappingMap.put(geomap.Contact__c, TempGeoMappingList);                    
                }
            }            
            
            list<sma__MATerritory__c> MATerritoriesToInsertList = new list<sma__MATerritory__c>();
            map<string, string> MATerritoryGeometryMap = new map<string, string>();
            
            
            for (Contact con : scope)
            {
                Set<String> states = new Set<String>();
                Set<String> provinces = new Set<String>();
                
                string geometry = '';
                
                if (ContactGeoMappingMap.containsKey(con.Id))
                {
                    for (Geography_Mapping__c geomap : ContactGeoMappingMap.get(con.Id))
                    {
                        if (geomap.Geography__r.Level__c == 4 && geomap.Geography__r.Level_Name__c == 'State')
                        {
                            states.add(string.valueOf(geomap.Geography__r.Numeric_Code__c));
                        }
                        if (geomap.Geography__r.Level__c == 4 && geomap.Geography__r.Level_Name__c == 'Province')
                        {
                            provinces.add(string.valueOf(geomap.Geography__r.Code2__c));
                        }                        
                    }
                    
                    string randomColor = '';
                    //SA20162112 Start
                   /*
                    if (HexColorsList.size() == 0)
                    {
                        HexColorsList = new list<string> {
                                                 '#7fffd4', '#9370d8', '#008000', '#ff0000', '#9acd32', '#ff00ff', '#ff8c00', '#dc143c', '#00ffff', '#3cb371', '#c71585', '#191970', '#ffa500', '#2e8b57', '#40e0d0', '#808000', '#8b4513', '#008080', '#ff6347', '#ffff00', 
                                                 '#48d1cc', '#8b0000', '#008b8b', '#8a2be2', '#f0ffff', '#00ffff', '#8fbc8f', '#4b0082', '#e6e6fa', '#cd5c5c', '#e0ffff', '#f08080', '#add8e6', '#add8e6', '#20b2aa', '#ffa07a', '#7cfc00', '#ffffe0', '#32cd32', '#cd853f',
                                                 '#ee82ee', '#8b008b', '#da70d6', '#ff4500', '#eee8aa', '#afeeee', '#87ceeb', '#800080', '#ff7f50', '#ffe4c4', '#f0fff0', '#e9967a', '#9400d3', '#b22222', '#ff1493', '#00bfff', '#ff69b4', '#00ff00', '#800000', '#d2b48c',
                                                 '#66cdaa', '#f5fffa', '#ffe4e1', '#d87093', '#98fb98', '#fa8072', '#a0522d', '#00ff7f', '#4682b4', '#4169e1', '#adff2f', '#00ced1', '#a52a2a', '#9932cc', '#483d8b', '#1e90ff', '#00fa9a', '#ffe4b5', '#000080', '#6b8e23', 
                                                 '#d2691e', '#7fff00', '#006400', '#556b2f', '#deb887', '#ffc0cb', '#b0e0e6', '#bc8f8f', '#7b68ee', '#ba55d3', '#f4a460', '#dda0dd', '#ffb6c1', '#87cefa', '#778899', '#b0c4de', '#90ee90', '#228b22', '#ff00ff', '#d8bfd8',
                                                 '#00008b', '#b8860b', '#f0f8ff', '#0000ff', '#daa520', '#ffd700', '#0000cd'};                   
                    }
                    */
                    //SA20162112 End
                    
                    randomColor = HexColorsList[integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1)))];
                    HexColorsList.remove(integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1))));
                    
                    if (states.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = con.Name + ' - USA';
                        terr.Contact__c = con.Id;
                        terr.Auto_Created__c = true;
                        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'USA',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => con.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                                
                            }
                        };
                        
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);
                        
                        string geoUSA = '{';
    
                        geoUSA += '"1":[';
                        
                        for (string Numcode : states)
                        { 
                            if (Numcode.length() == 1)
                            {
                                Numcode = '0' + Numcode;
                            }
                            
                            geoUSA += '"USA-' + Numcode + '",';
                        }
                        
                        geoUSA = geoUSA.removeEnd(',');
                        geoUSA += ']';
                        geoUSA += '}';
                        
                        MATerritoryGeometryMap.put(terr.Name, geoUSA);
                    }
                    
                    if (provinces.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = con.Name + ' - CAN';
                        terr.Contact__c = con.Id;
                        terr.Auto_Created__c = true;
        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'CAN',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => con.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                                
                            }
                        };
                        
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);
                        
                        string geoCan = '{';
                        
                        Map<String, String> canState = new Map<String, String>{
                            'PE'=>'CAN-11',
                            'NU'=>'CAN-62',
                            'BC'=>'CAN-59',
                            'YT'=>'CAN-60',
                            'NS'=>'CAN-12',
                            'ON'=>'CAN-35',
                            'NT'=>'CAN-61',
                            'NB'=>'CAN-13',
                            'SK'=>'CAN-47',
                            'AB'=>'CAN-48',
                            'NF'=>'CAN-10',
                            'NL'=>'CAN-10',
                            'MB'=>'CAN-46',
                            'QC'=>'CAN-24'
                        };
    
    
                        geoCan += '"1":[';
                        
                        for (string Numcode : provinces)
                        {
                            string newNumcode = canState.get(Numcode);
                            geoCan += '"' + newNumcode + '",';
                        }
                        
                        geoCan = geoCan.remove('"null",');
                        geoCan = geoCan.removeEnd(',');
                        geoCan += ']';
                        geoCan += '}';
                        
                        MATerritoryGeometryMap.put(terr.Name, geoCan);
                    }                    
                }
            }
            
            list<string> savedTerritoryIds = new list<string>();
            
            Database.SaveResult [] srList = Database.insert(MATerritoriesToInsertList, false);
            
            for (Database.SaveResult sr : srList)
            {
                if (sr.isSuccess())
                {
                    savedTerritoryIds.add(sr.getId());
                }
            }
            
            list<sma__MATerritory__c> SavedTerritories = new list<sma__MATerritory__c>();
            
            for (sma__MATerritory__c terr : [SELECT Id, Name, Contact__c FROM sma__MATerritory__c WHERE Id IN :savedTerritoryIds])
            {
                SavedTerritories.add(terr);
            }
            
            
            list<sma__MATerritoryGeometry__c> TerritoryGeometriesToInsert = new list<sma__MATerritoryGeometry__c>();
                        
            for (Contact con : scope)
            {
                for (sma__MATerritory__c terr : SavedTerritories)
                {
                    if (terr.Contact__c == con.Id)
                    {
                        if (MATerritoryGeometryMap.containsKey(terr.Name))
                        {
                            sma__MATerritoryGeometry__c geo = new sma__MATerritoryGeometry__c();
                            geo.sma__Geometry__c = MATerritoryGeometryMap.get(terr.Name);
                            geo.sma__Territory__c = terr.Id;
                            geo.Name = terr.Name + '-geometry';
                            TerritoryGeometriesToInsert.add(geo);                            
                        }
                    }
                }
            }
            
            insert TerritoryGeometriesToInsert;
        }
    }
    
    
    public static void MACreateShapeLayersByUserBatchable_Execute(List<User> scope)
    {
        string shapeLayerFolderId = '';

        for (sma__MAFolder__c Sfolder : [SELECT Id, Name FROM sma__MAFolder__c WHERE Name = 'By User' AND sma__ParentFolder__r.Name = 'County'])
        {
            shapeLayerFolderId = Sfolder.Id;
        }
        
        if (shapeLayerFolderId != '')
        {
            Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('MHC Surfaces').getRecordTypeId();
            
            list<string> recordIds = new list<string>();
            
            for (User u : scope)
            {
                recordIds.add(u.Id);
            }            
            
            map<string, list<Geography_Mapping__c>> UserGeoMappingMap = new map<string, list<Geography_Mapping__c>>();
            
            for (Geography_Mapping__c geomap : [SELECT Id, Name, Account__c, Contact__c, Geography__r.Name, Geography__c, Owning_Organization__c, User__C, Geography__r.Code__c, Geography__r.Level__c, Geography__r.Level_Name__c, Geography__r.Numeric_Code__c, Geography__r.Code2__c 
                                                FROM Geography_Mapping__c WHERE User__c IN :recordIds AND RecordTypeId =: GeoMappingRecordTypeId])
            {
                if (UserGeoMappingMap.containsKey(geomap.User__c))
                {
                    list<Geography_Mapping__c> TempGeoMappingList = UserGeoMappingMap.get(geomap.User__c);
                    TempGeoMappingList.add(geomap);
                    UserGeoMappingMap.put(geomap.User__c, TempGeoMappingList);
                }
                else
                {
                    list<Geography_Mapping__c> TempGeoMappingList = new list<Geography_Mapping__c>();
                    TempGeoMappingList.add(geomap);
                    UserGeoMappingMap.put(geomap.User__c, TempGeoMappingList);                    
                }
            }            
            
            list<sma__MATerritory__c> MATerritoriesToInsertList = new list<sma__MATerritory__c>();
            map<string, string> MATerritoryGeometryMap = new map<string, string>();
            
            for (User u : scope)
            {
                Set<String> usaCounties = new Set<String>();
                Set<String> canCounties = new Set<String>();
                
                string geometry = '';
                
                if (UserGeoMappingMap.containsKey(u.Id))
                {
                    for (Geography_Mapping__c geomap : UserGeoMappingMap.get(u.Id))
                    {
                        if (geomap.Geography__r.Level__c == 5 && geomap.Geography__r.Level_Name__c == 'County')
                        {
                            String geoCode = geomap.Geography__r.Code__c;
                            
                            if (geoCode.contains('-'))
                            {
                                string canCode1 = geoCode.substring(0,2);
                                string canCode2 = geoCode.substring(5,7);
                                canCounties.add(canCode1 + '0' + canCode2);
                            }
                            else
                            {
                                usaCounties.add(geomap.Geography__r.Code2__c);
                            }
                        }                     
                    }

                    string randomColor = '';
        
                    //SA20162112 Start
                    /*    
                    if (HexColorsList.size() == 0)
                    {
                        HexColorsList = new list<string> {
                                                 '#7fffd4', '#9370d8', '#008000', '#ff0000', '#9acd32', '#ff00ff', '#ff8c00', '#dc143c', '#00ffff', '#3cb371', '#c71585', '#191970', '#ffa500', '#2e8b57', '#40e0d0', '#808000', '#8b4513', '#008080', '#ff6347', '#ffff00', 
                                                 '#48d1cc', '#8b0000', '#008b8b', '#8a2be2', '#f0ffff', '#00ffff', '#8fbc8f', '#4b0082', '#e6e6fa', '#cd5c5c', '#e0ffff', '#f08080', '#add8e6', '#add8e6', '#20b2aa', '#ffa07a', '#7cfc00', '#ffffe0', '#32cd32', '#cd853f',
                                                 '#ee82ee', '#8b008b', '#da70d6', '#ff4500', '#eee8aa', '#afeeee', '#87ceeb', '#800080', '#ff7f50', '#ffe4c4', '#f0fff0', '#e9967a', '#9400d3', '#b22222', '#ff1493', '#00bfff', '#ff69b4', '#00ff00', '#800000', '#d2b48c',
                                                 '#66cdaa', '#f5fffa', '#ffe4e1', '#d87093', '#98fb98', '#fa8072', '#a0522d', '#00ff7f', '#4682b4', '#4169e1', '#adff2f', '#00ced1', '#a52a2a', '#9932cc', '#483d8b', '#1e90ff', '#00fa9a', '#ffe4b5', '#000080', '#6b8e23', 
                                                 '#d2691e', '#7fff00', '#006400', '#556b2f', '#deb887', '#ffc0cb', '#b0e0e6', '#bc8f8f', '#7b68ee', '#ba55d3', '#f4a460', '#dda0dd', '#ffb6c1', '#87cefa', '#778899', '#b0c4de', '#90ee90', '#228b22', '#ff00ff', '#d8bfd8',
                                                 '#00008b', '#b8860b', '#f0f8ff', '#0000ff', '#daa520', '#ffd700', '#0000cd'};                    
                    }
                    */
                    //SA20162112 End
                    
                    randomColor = HexColorsList[integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1)))];
                    HexColorsList.remove(integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1))));    

                    if (usaCounties.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = u.Name + ' - ' + u.User_Account__c + ' - USA';
                        terr.sma__User__c = u.Id;
                        terr.Auto_Created__c = true;
                        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'USA',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => u.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                            }
                        };
                    
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);
                        
                        string geoUSA = '{';
                        geoUSA += '"2":[';
                        
                        for (String subcode : usaCounties) 
                        {
                            if (subcode.length() == 4){subcode = '0' + subcode;}
                            geoUSA += '"USA-2-' + subcode +'",';
                        }
                        
                        geoUSA = geoUSA.removeEnd(',');
                        geoUSA += ']';
                        geoUSA += '}';                        
                        
                        MATerritoryGeometryMap.put(terr.Name, geoUSA);
                    }

                    if(canCounties.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = u.Name + ' - ' + u.User_Account__c + ' - CAN';
                        terr.sma__User__c = u.Id;
                        terr.Auto_Created__c = true;
        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'CAN',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => u.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                            }
                        };
                    
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);

                        string geoCan = '{';
                        geoCan += '"2":[';
                        
                        for (String subcode : canCounties) 
                        {
                            geoCan += '"CAN-' + subcode +'",';
                        }
                        
                        geoCan = geoCan.removeEnd(',');
                        geoCan += ']';
                        geoCan += '}';
                        
                        MATerritoryGeometryMap.put(terr.Name, geoCan);
                    }                    
                }
            }            
            
            list<string> savedTerritoryIds = new list<string>();
            
            Database.SaveResult [] srList = Database.insert(MATerritoriesToInsertList, false);
            
            for (Database.SaveResult sr : srList)
            {
                if (sr.isSuccess())
                {
                    savedTerritoryIds.add(sr.getId());
                }
            }
            
            list<sma__MATerritory__c> SavedTerritories = new list<sma__MATerritory__c>();
            
            for (sma__MATerritory__c terr : [SELECT Id, Name, sma__User__c FROM sma__MATerritory__c WHERE Id IN :savedTerritoryIds])
            {
                SavedTerritories.add(terr);
            }
            
            
            list<sma__MATerritoryGeometry__c> TerritoryGeometriesToInsert = new list<sma__MATerritoryGeometry__c>();
                        
            for (User u : scope)
            {
                for (sma__MATerritory__c terr : SavedTerritories)
                {
                    if (terr.sma__User__c == u.Id)
                    {
                        if (MATerritoryGeometryMap.containsKey(terr.Name))
                        {
                            sma__MATerritoryGeometry__c geo = new sma__MATerritoryGeometry__c();
                            geo.sma__Geometry__c = MATerritoryGeometryMap.get(terr.Name);
                            geo.sma__Territory__c = terr.Id;
                            geo.Name = terr.Name + '-geometry';
                            TerritoryGeometriesToInsert.add(geo);                            
                        }
                    }
                }
            }
                
            insert TerritoryGeometriesToInsert;            
        }
    }
    
    
    public static void MACreateShapeLayersByAccountBatchable_Execute(List<Account> scope)
    {
        string shapeLayerFolderId = '';

        for (sma__MAFolder__c Sfolder : [SELECT Id, Name FROM sma__MAFolder__c WHERE Name = 'By Account' AND sma__ParentFolder__r.Name = 'County'])
        {
            shapeLayerFolderId = Sfolder.Id;
        }
        
        if (shapeLayerFolderId != '')
        {
            Id GeoMappingRecordTypeId = Schema.SObjectType.Geography_Mapping__c.getRecordTypeInfosByName().get('MHC Surfaces').getRecordTypeId();
            
            list<string> recordIds = new list<string>();
            
            for (Account acc : scope)
            {
                recordIds.add(acc.Id);
            }            
            
            map<string, list<Geography_Mapping__c>> AccountGeoMappingMap = new map<string, list<Geography_Mapping__c>>();
            
            for (Geography_Mapping__c geomap : [SELECT Id, Name, Account__c, Contact__c, Geography__r.Name, Geography__c, Owning_Organization__c, User__C, Geography__r.Code__c, Geography__r.Level__c, Geography__r.Level_Name__c, Geography__r.Numeric_Code__c, Geography__r.Code2__c 
                                                FROM Geography_Mapping__c WHERE Account__c IN :recordIds AND RecordTypeId =: GeoMappingRecordTypeId])
            {
                if (AccountGeoMappingMap.containsKey(geomap.Account__c))
                {
                    list<Geography_Mapping__c> TempGeoMappingList = AccountGeoMappingMap.get(geomap.Account__c);
                    TempGeoMappingList.add(geomap);
                    AccountGeoMappingMap.put(geomap.Account__c, TempGeoMappingList);
                }
                else
                {
                    list<Geography_Mapping__c> TempGeoMappingList = new list<Geography_Mapping__c>();
                    TempGeoMappingList.add(geomap);
                    AccountGeoMappingMap.put(geomap.Account__c, TempGeoMappingList);                    
                }
            }         

            list<sma__MATerritory__c> MATerritoriesToInsertList = new list<sma__MATerritory__c>();
            map<string, string> MATerritoryGeometryMap = new map<string, string>();
            
            for (Account acc : scope)
            {
                Set<String> usaCounties = new Set<String>();
                Set<String> canCounties = new Set<String>();
                
                string geometry = '';
                
                if (AccountGeoMappingMap.containsKey(acc.Id))
                {
                    for (Geography_Mapping__c geomap : AccountGeoMappingMap.get(acc.Id))
                    {
                        if (geomap.Geography__r.Level__c == 5 && geomap.Geography__r.Level_Name__c == 'County')
                        {
                            String geoCode = geomap.Geography__r.Code__c;
                            
                            if (geoCode.contains('-'))
                            {
                                string canCode1 = geoCode.substring(0,2);
                                string canCode2 = geoCode.substring(5,7);
                                canCounties.add(canCode1 + '0' + canCode2);
                            }
                            else
                            {
                                usaCounties.add(geomap.Geography__r.Code2__c);
                            }
                        }                     
                    }

                    string randomColor = '';
                    
                    //SA20162112 Start
                    /*
                    if (HexColorsList.size() == 0)
                    {
                        HexColorsList = new list<string> {
                                                 '#7fffd4', '#9370d8', '#008000', '#ff0000', '#9acd32', '#ff00ff', '#ff8c00', '#dc143c', '#00ffff', '#3cb371', '#c71585', '#191970', '#ffa500', '#2e8b57', '#40e0d0', '#808000', '#8b4513', '#008080', '#ff6347', '#ffff00', 
                                                 '#48d1cc', '#8b0000', '#008b8b', '#8a2be2', '#f0ffff', '#00ffff', '#8fbc8f', '#4b0082', '#e6e6fa', '#cd5c5c', '#e0ffff', '#f08080', '#add8e6', '#add8e6', '#20b2aa', '#ffa07a', '#7cfc00', '#ffffe0', '#32cd32', '#cd853f',
                                                 '#ee82ee', '#8b008b', '#da70d6', '#ff4500', '#eee8aa', '#afeeee', '#87ceeb', '#800080', '#ff7f50', '#ffe4c4', '#f0fff0', '#e9967a', '#9400d3', '#b22222', '#ff1493', '#00bfff', '#ff69b4', '#00ff00', '#800000', '#d2b48c',
                                                 '#66cdaa', '#f5fffa', '#ffe4e1', '#d87093', '#98fb98', '#fa8072', '#a0522d', '#00ff7f', '#4682b4', '#4169e1', '#adff2f', '#00ced1', '#a52a2a', '#9932cc', '#483d8b', '#1e90ff', '#00fa9a', '#ffe4b5', '#000080', '#6b8e23', 
                                                 '#d2691e', '#7fff00', '#006400', '#556b2f', '#deb887', '#ffc0cb', '#b0e0e6', '#bc8f8f', '#7b68ee', '#ba55d3', '#f4a460', '#dda0dd', '#ffb6c1', '#87cefa', '#778899', '#b0c4de', '#90ee90', '#228b22', '#ff00ff', '#d8bfd8',
                                                 '#00008b', '#b8860b', '#f0f8ff', '#0000ff', '#daa520', '#ffd700', '#0000cd'};                    
                    }
                    */
                    //SA20162112 End
                    
                    randomColor = HexColorsList[integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1)))];
                    HexColorsList.remove(integer.valueof(Math.floor(Math.random() * (HexColorsList.size()-1))));    

                    if (usaCounties.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = acc.Name + ' - USA';
                        terr.Account__c = acc.Id;
                        terr.Auto_Created__c = true;
                        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'USA',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => acc.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                            }
                        };
                    
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);
                        
                        string geoUSA = '{';
                        geoUSA += '"2":[';
                        
                        for (String subcode : usaCounties) 
                        {
                            if (subcode.length() == 4){subcode = '0' + subcode;}
                            geoUSA += '"USA-2-' + subcode +'",';
                        }
                        
                        geoUSA = geoUSA.removeEnd(',');
                        geoUSA += ']';
                        geoUSA += '}';                        
                        
                        MATerritoryGeometryMap.put(terr.Name, geoUSA);
                    }

                    if(canCounties.size() > 0)
                    {
                        sma__MATerritory__c terr = new sma__MATerritory__c();
                        terr.sma__Folder__c = shapeLayerFolderId;
                        terr.Name = acc.Name + ' - CAN';
                        terr.Account__c = acc.Id;
                        terr.Auto_Created__c = true;
        
                        map<string,object> ShapeLayerOptions = new map<string,object> {
                            'country' => 'CAN',
                            'advancedOptions' => new map<string,object> {
                                'calculateTerritoryAggregates' => false,
                                'dissolveGeometry' => true
                            },
                            'colorOptions' => new map<string,object> {
                                'fillColor' => randomColor,
                                'borderColor' => randomColor,
                                'fillOpacity' => '0.5',
                                'labelEnabled' => true,
                                'labelOverride' => acc.Name,
                                'labelJustification' => 'center',
                                'labelFontSize' => '9px',
                                'labelFontColor' => '#FFFFFF',
                                'labelBGColor' => '#000000',
                                'labelBGOpacity' => '0.3'
                            }
                        };
                    
                        terr.sma__Options__c = JSON.serialize(ShapeLayerOptions);
                        MATerritoriesToInsertList.add(terr);

                        string geoCan = '{';
                        geoCan += '"2":[';
                        
                        for (String subcode : canCounties) 
                        {
                            geoCan += '"CAN-' + subcode +'",';
                        }
                        
                        geoCan = geoCan.removeEnd(',');
                        geoCan += ']';
                        geoCan += '}';
                        
                        MATerritoryGeometryMap.put(terr.Name, geoCan);
                    }                    
                }                
                
            }

            list<string> savedTerritoryIds = new list<string>();
            
            Database.SaveResult [] srList = Database.insert(MATerritoriesToInsertList, false);
            
            for (Database.SaveResult sr : srList)
            {
                if (sr.isSuccess())
                {
                    savedTerritoryIds.add(sr.getId());
                }
            }
            
            list<sma__MATerritory__c> SavedTerritories = new list<sma__MATerritory__c>();
            
            for (sma__MATerritory__c terr : [SELECT Id, Name, Account__c FROM sma__MATerritory__c WHERE Id IN :savedTerritoryIds])
            {
                SavedTerritories.add(terr);
            }
            
            
            list<sma__MATerritoryGeometry__c> TerritoryGeometriesToInsert = new list<sma__MATerritoryGeometry__c>();
                        
            for (Account acc : scope)
            {
                for (sma__MATerritory__c terr : SavedTerritories)
                {
                    if (terr.Account__c == acc.Id)
                    {
                        if (MATerritoryGeometryMap.containsKey(terr.Name))
                        {
                            sma__MATerritoryGeometry__c geo = new sma__MATerritoryGeometry__c();
                            geo.sma__Geometry__c = MATerritoryGeometryMap.get(terr.Name);
                            geo.sma__Territory__c = terr.Id;
                            geo.Name = terr.Name + '-geometry';
                            TerritoryGeometriesToInsert.add(geo);                            
                        }
                    }
                }
            }
                
            insert TerritoryGeometriesToInsert;
        }
    }
    
    
    
    public static string RandomHexColor()
    {
        
        //SA20162112 Start
        
        Set<string> colorSet = new Set<string>();
        List<string> colorList = new List<string>();
        colorSet = MA_Color_Code__c.getall().Keyset();
        colorList.addAll(colorSet);
        
        
        /*
        colorList.add('#ae4ad2');
        colorList.add('#128340');
        colorList.add('#b68cab');
        colorList.add('#6ac73a');
        colorList.add('#7b847b');
        colorList.add('#bb0529');
        colorList.add('#1af92a');
        colorList.add('#0f1654');
        colorList.add('#32226e');
        colorList.add('#e776a6');
        colorList.add('#acd1b1');
        colorList.add('#b30d19');
        colorList.add('#0e4770');
        colorList.add('#8773ff');
        colorList.add('#6dc39b');
        colorList.add('#274b98');
        colorList.add('#4e53c6');
        colorList.add('#b8d271');
        colorList.add('#94c6fa');
        colorList.add('#14ed8c');
        colorList.add('#777dbd');
        colorList.add('#5d5e52');
        colorList.add('#add991');
        colorList.add('#d074ce');
        colorList.add('#6153e1');
        colorList.add('#731b8a');
        colorList.add('#39d69b');
        colorList.add('#592dc4');
        colorList.add('#7b9f7a');
        colorList.add('#eefbb0');
        colorList.add('#d2c2ad');
        colorList.add('#33aafe');
        colorList.add('#d416f0');
        colorList.add('#4d1fd6');
        colorList.add('#3d7385');
        colorList.add('#69e6ea');
        colorList.add('#8f23e2');
        colorList.add('#6c71ea');
        colorList.add('#814617');
        colorList.add('#4f616d');
        colorList.add('#c2e1bf');
        colorList.add('#b1f915');
        colorList.add('#a3680b');
        colorList.add('#00d2a6');
        colorList.add('#7c947b');
        colorList.add('#9cce5e');
        colorList.add('#069354');
        colorList.add('#558069');
        colorList.add('#1be49b');
        colorList.add('#e847dc');
        colorList.add('#dadf64');
        colorList.add('#dd66d4');
        colorList.add('#4b88b1');
        colorList.add('#6f5f6b');
        colorList.add('#8a6ca9');
        colorList.add('#9c13ab');
        colorList.add('#d2944c');
        colorList.add('#6f3d5c');
        colorList.add('#81ae3e');
        colorList.add('#35fbe0');
        colorList.add('#dd0ce5');
        colorList.add('#3fb525');
        colorList.add('#6e4386');
        colorList.add('#fdda8f');
        colorList.add('#3ca163');
        colorList.add('#f8f806');
        colorList.add('#b9eea3');
        colorList.add('#5f2bf2');
        colorList.add('#2c72a5');
        colorList.add('#99d3a3');
        colorList.add('#b1a49a');
        colorList.add('#405b1a');
        colorList.add('#d3671d');
        colorList.add('#c91dd1');
        colorList.add('#e9ba5b');
        colorList.add('#feb6f3');
        colorList.add('#94f06b');
        colorList.add('#5bd551');
        colorList.add('#c17e5c');
        colorList.add('#ee0aaf');
        colorList.add('#032e47');
        colorList.add('#a7fa1c');
        colorList.add('#d44dba');
        colorList.add('#8df2dd');
        colorList.add('#394b49');
        colorList.add('#591b97');
        colorList.add('#c7f7d0');
        colorList.add('#f67095');
        colorList.add('#f3249c');
        colorList.add('#be537b');
        colorList.add('#0a0242');
        colorList.add('#8b9837');
        colorList.add('#4e994c');
        colorList.add('#45a86a');
        colorList.add('#4c72ae');
        colorList.add('#5339e9');
        colorList.add('#adf1fd');
        colorList.add('#759d23');
        colorList.add('#bdb140');
        colorList.add('#8ad4c4');
        colorList.add('#c82b56');
        colorList.add('#9f1e58');
        colorList.add('#233a35');
        colorList.add('#ec3550');
        colorList.add('#c9369f');
        colorList.add('#e41ff9');
        colorList.add('#61c5a5');
        colorList.add('#20b61d');
        colorList.add('#fd15cb');
        colorList.add('#e3f8d4');
        colorList.add('#7e82fb');
        colorList.add('#3c9c8e');
        colorList.add('#b7bbdb');
        colorList.add('#6c2569');
        colorList.add('#7112a3');
        colorList.add('#506714');
        colorList.add('#4d8744');
        colorList.add('#d6d7c0');
        colorList.add('#1364ca');
        colorList.add('#671f52');
        colorList.add('#84fbb4');
        colorList.add('#07105f');
        colorList.add('#150339');
        colorList.add('#de50cf');
        colorList.add('#dcdf52');
        colorList.add('#013417');
        colorList.add('#832031');
        colorList.add('#1d7e03');
        colorList.add('#1111df');
        colorList.add('#c8850c');
        colorList.add('#bc6f50');
        colorList.add('#a184c1');
        colorList.add('#b43735');
        colorList.add('#2525a1');
        colorList.add('#f114de');
        colorList.add('#6b0d8e');
        colorList.add('#ffe55c');
        colorList.add('#32b0f3');
        colorList.add('#9e5568');
        colorList.add('#2ef601');
        colorList.add('#639824');
        colorList.add('#4b1066');
        colorList.add('#5d42eb');
        colorList.add('#a6cde9');
        colorList.add('#ddcc07');
        colorList.add('#67c160');
        colorList.add('#7240fb');
        colorList.add('#aa4c1e');
        colorList.add('#6aa249');
        colorList.add('#1f87a5');
        colorList.add('#9bc822');
        colorList.add('#37fa48');
        colorList.add('#fe49e1');
        colorList.add('#f4a954');
        colorList.add('#967b57');
        colorList.add('#4fd8e8');
        colorList.add('#0e037b');
        colorList.add('#563e5c');
        colorList.add('#6d5e1d');
        colorList.add('#f374a1');
        colorList.add('#09a2e7');
        colorList.add('#53a8c7');
        colorList.add('#5e4d33');
        colorList.add('#89f5bf');
        colorList.add('#6cc8ec');
        colorList.add('#6ce1f9');
        colorList.add('#9e5d1f');
        colorList.add('#4ff8d3');
        colorList.add('#458199');
        colorList.add('#3dccb4');
        colorList.add('#d4a130');
        colorList.add('#5d8d5f');
        colorList.add('#af7317');
        colorList.add('#cd7150');
        colorList.add('#b2159a');
        colorList.add('#9d02f0');
        colorList.add('#1e831d');
        colorList.add('#acbad1');
        colorList.add('#ec6d45');
        colorList.add('#c809e9');
        colorList.add('#2e1854');
        colorList.add('#6bfe9b');
        colorList.add('#08a5ea');
        colorList.add('#149d38');
        colorList.add('#b27934');
        colorList.add('#525ceb');
        colorList.add('#ccdd70');
        colorList.add('#4051bc');
        colorList.add('#bf4459');
        colorList.add('#755e62');
        colorList.add('#63c61c');
        colorList.add('#30a215');
        colorList.add('#6c289c');
        colorList.add('#a4ba10');
        colorList.add('#6e48ae');
        colorList.add('#7a8d8d');
        colorList.add('#39c3fd');
        colorList.add('#5b4ef5');
        colorList.add('#7da083');
        colorList.add('#c9cbee');
        colorList.add('#6ed5ce');
        colorList.add('#1102a1');
        colorList.add('#f277e5');
        colorList.add('#8f602a');
        colorList.add('#cee688');
        colorList.add('#69ef2a');
        colorList.add('#2e90f0');
        colorList.add('#cbcb6d');
        colorList.add('#d7b119');
        colorList.add('#e953c8');
        colorList.add('#ef6a0e');
        colorList.add('#81c903');
        colorList.add('#dd1a5c');
        colorList.add('#c92b85');
        colorList.add('#5db0bd');
        colorList.add('#4ec3d8');
        colorList.add('#408c44');
        colorList.add('#c82ece');
        colorList.add('#2ba49f');
        colorList.add('#1a45dd');
        colorList.add('#3083a5');
        colorList.add('#7a11dd');
        colorList.add('#b6bd83');
        colorList.add('#1c1c98');
        colorList.add('#a29ea4');
        colorList.add('#8f76c7');
        colorList.add('#15ef5d');
        colorList.add('#ddf647');
        colorList.add('#3e0b66');
        colorList.add('#ae6c54');
        colorList.add('#e8d816');
        colorList.add('#c24897');
        colorList.add('#9dd113');
        colorList.add('#51f6eb');
        colorList.add('#a99f88');
        colorList.add('#d6877d');
        colorList.add('#fcd715');
        colorList.add('#b33b15');
        colorList.add('#fc16d7');
        colorList.add('#27f230');
        colorList.add('#f5a5e8');
        colorList.add('#d96531');
        colorList.add('#07d867');
        colorList.add('#0b549d');
        colorList.add('#891025');
        colorList.add('#fc4915');
        colorList.add('#c1bd55');
        colorList.add('#bacb4c');
        colorList.add('#5ca332');
        colorList.add('#60501d');
        colorList.add('#4f50e9');
        colorList.add('#808cf7');
        colorList.add('#75ba26');
        colorList.add('#ddfff3');
        colorList.add('#3ca146');
        colorList.add('#761dee');
        colorList.add('#b03925');
        colorList.add('#d72b8e');
        colorList.add('#26363d');
        colorList.add('#c1f030');
        colorList.add('#c267fc');
        colorList.add('#d202db');
        colorList.add('#ea1d6e');
        colorList.add('#6c95e4');
        colorList.add('#2b37ac');
        colorList.add('#bb0966');
        colorList.add('#9896be');
        colorList.add('#d70594');
        colorList.add('#51c2f7');
        colorList.add('#e0fc7f');
        colorList.add('#998bd8');
        colorList.add('#0347f2');
        colorList.add('#738baf');
        colorList.add('#a24a64');
        colorList.add('#4a5d07');
        colorList.add('#6447d7');
        colorList.add('#0e4ee0');
        colorList.add('#865697');
        colorList.add('#8cbb27');
        colorList.add('#110998');
        colorList.add('#ee53aa');
        colorList.add('#64b86c');
        colorList.add('#1ee676');
        colorList.add('#7011b1');
        colorList.add('#5c2f33');
        colorList.add('#917777');
        colorList.add('#ffa920');
        colorList.add('#d30d6e');
        colorList.add('#f3766e');
        colorList.add('#e6cb12');
        colorList.add('#80c656');
        colorList.add('#2a9cf3');
        colorList.add('#d4153c');
        colorList.add('#c7396f');
        colorList.add('#09934a');
        colorList.add('#6bd4d9');
        colorList.add('#d46550');
        colorList.add('#f85ef9');
        colorList.add('#8ac2fd');
        colorList.add('#66a11d');
        colorList.add('#4add8c');
        colorList.add('#dd9e4f');
        colorList.add('#64353c');
        colorList.add('#f7bf58');
        colorList.add('#fabaf3');
        colorList.add('#6a76a8');
        colorList.add('#94544f');
        colorList.add('#52a8d3');
        colorList.add('#5f1bc3');
        colorList.add('#e27726');
        colorList.add('#f90c37');
        colorList.add('#c19303');
        colorList.add('#a2ca43');
        colorList.add('#ec0345');
        colorList.add('#1bdbe6');
        colorList.add('#db19d5');
        colorList.add('#d147c1');
        colorList.add('#1f3a63');
        colorList.add('#622d7c');
        colorList.add('#371737');
        colorList.add('#f7eeb2');
        colorList.add('#2012dc');
        colorList.add('#8aef71');
        colorList.add('#8151c8');
        colorList.add('#0e8c78');
        colorList.add('#2cc96d');
        colorList.add('#72b756');
        colorList.add('#da0a70');
        colorList.add('#de8a9e');
        colorList.add('#a1b78b');
        colorList.add('#a385c5');
        colorList.add('#19fb78');
        colorList.add('#22db01');
        colorList.add('#57cd7b');
        colorList.add('#a1cc55');
        colorList.add('#cd030f');
        colorList.add('#6479c3');
        colorList.add('#11e8fc');
        colorList.add('#27b45d');
        colorList.add('#fb05a8');
        colorList.add('#c1482f');
        colorList.add('#8060d3');
        colorList.add('#7fe9f6');
        colorList.add('#c5e9b4');
        colorList.add('#c735be');
        colorList.add('#248ea9');
        colorList.add('#441415');
        colorList.add('#83cc15');
        colorList.add('#82ccc1');
        colorList.add('#c3fb33');
        colorList.add('#10e80d');
        colorList.add('#a7d9c3');
        colorList.add('#a4ca8c');
        colorList.add('#36028f');
        colorList.add('#4ed812');
        colorList.add('#679bb9');
        colorList.add('#5fb4ca');
        colorList.add('#cd37aa');
        colorList.add('#bbf322');
        colorList.add('#02f4b0');
        colorList.add('#3e1e4b');
        colorList.add('#7deea0');
        colorList.add('#b9e7b0');
        colorList.add('#611d63');
        colorList.add('#160b61');
        colorList.add('#0bd963');
        colorList.add('#83bec1');
        colorList.add('#242c84');
        colorList.add('#eb386b');
        colorList.add('#08ed4f');
        colorList.add('#2ea0a8');
        colorList.add('#098052');
        colorList.add('#ea2f72');
        colorList.add('#54b04d');
        colorList.add('#35a9a2');
        colorList.add('#cc42bc');
        colorList.add('#0d07da');
        colorList.add('#ac1a68');
        colorList.add('#877fde');
        colorList.add('#17adfb');
        colorList.add('#0117fe');
        colorList.add('#2b4147');
        colorList.add('#abdfc5');
        colorList.add('#98583e');
        colorList.add('#ded46a');
        colorList.add('#6ef7a3');
        colorList.add('#464d86');
        colorList.add('#dba8ea');
        colorList.add('#0528eb');
        colorList.add('#ecf888');
        colorList.add('#681b47');
        colorList.add('#c66c00');
        colorList.add('#d2fa16');
        colorList.add('#11a5aa');
        colorList.add('#2f1515');
        colorList.add('#f3fd75');
        colorList.add('#a54d48');
        colorList.add('#d805cf');
        colorList.add('#528273');
        colorList.add('#017bf5');
        colorList.add('#b867fa');
        colorList.add('#a857b3');
        colorList.add('#5973b6');
        colorList.add('#68becc');
        colorList.add('#96f00f');
        colorList.add('#693112');
        colorList.add('#f635e2');
        colorList.add('#505091');
        colorList.add('#c6464f');
        colorList.add('#dc6fea');
        colorList.add('#c24fc9');
        colorList.add('#eae39a');
        colorList.add('#68afd5');
        colorList.add('#fd2978');
        colorList.add('#889403');
        colorList.add('#1448e6');
        colorList.add('#202640');
        colorList.add('#4593c6');
        colorList.add('#eea278');
        colorList.add('#1bb6ee');
        colorList.add('#68b6d5');
        colorList.add('#18cd99');
        colorList.add('#880b46');
        colorList.add('#674632');
        colorList.add('#e6a735');
        colorList.add('#d87fe7');
        colorList.add('#8e8b52');
        colorList.add('#2f9221');
        colorList.add('#8f1843');
        colorList.add('#7cebaf');
        colorList.add('#5ea880');
        colorList.add('#599fbe');
        colorList.add('#658627');
        colorList.add('#cb81d9');
        colorList.add('#8b774c');
        colorList.add('#ce86b6');
        colorList.add('#8fffab');
        colorList.add('#4607c9');
        colorList.add('#25690e');
        colorList.add('#a7aa10');
        colorList.add('#6c8bb7');
        colorList.add('#220c50');
        colorList.add('#1385af');
        colorList.add('#e6bddc');
        colorList.add('#3e1542');
        colorList.add('#fece34');
        colorList.add('#5fb883');
        colorList.add('#b4b617');
        colorList.add('#79871c');
        colorList.add('#ed1973');
        colorList.add('#abd771');
        colorList.add('#6c4fd1');
        colorList.add('#e08961');
        colorList.add('#a072d1');
        colorList.add('#5a2fc5');
        colorList.add('#c65e14');
        colorList.add('#f55c86');
        colorList.add('#28d131');
        colorList.add('#51d00f');
        colorList.add('#0efaba');
        colorList.add('#7cdef2');
        colorList.add('#b40070');
        colorList.add('#e93b8d');
        colorList.add('#f9ac84');
        colorList.add('#28c3af');
        colorList.add('#5ee87e');
        colorList.add('#ac0ee3');
        colorList.add('#240099');
        colorList.add('#0c84ac');
        colorList.add('#4302b9');
        colorList.add('#906616');
        colorList.add('#9bdbff');
        colorList.add('#6e441d');
        colorList.add('#534e8f');
        colorList.add('#2559bf');
        colorList.add('#0e5705');
        colorList.add('#7d7bf1');
        colorList.add('#a3adbc');
        colorList.add('#be16e0');
        colorList.add('#e3cf1a');
        colorList.add('#ad9ac3');
        colorList.add('#faf228');
        colorList.add('#42ab15');
        colorList.add('#2ce793');
        colorList.add('#cabb2a');
        colorList.add('#9e9934');
        colorList.add('#b60a7c');
        colorList.add('#5fde35');
        colorList.add('#208eb3');
        colorList.add('#1121c7');
        colorList.add('#96593e');
        colorList.add('#0c4c4a');
        colorList.add('#80debc');
        colorList.add('#65480f');
        colorList.add('#f6ea89');
        colorList.add('#aac2c9');
        colorList.add('#e34868');
        colorList.add('#18a7cf');
        colorList.add('#93e30d');
        colorList.add('#8237a0');
        colorList.add('#564794');
        colorList.add('#9a88a5');
        colorList.add('#411921');
        colorList.add('#47af88');
        colorList.add('#d55643');
        colorList.add('#dec257');
        colorList.add('#103b15');
        colorList.add('#b12c84');
        colorList.add('#b338b8');
        colorList.add('#01b04f');
        colorList.add('#1ff8da');
        colorList.add('#39b33c');
        colorList.add('#d7d005');
        colorList.add('#a67277');
        colorList.add('#7606ba');
        colorList.add('#a2487d');
        colorList.add('#009ac0');
        colorList.add('#b5af1b');
        colorList.add('#aef7c0');
        colorList.add('#f63b17');
        colorList.add('#fd1cc4');
        colorList.add('#c44dd2');
        colorList.add('#b8a7ec');
        colorList.add('#3df5e4');
        colorList.add('#d981b9');
        colorList.add('#3c15ca');
        colorList.add('#e6f165');
        colorList.add('#d545ab');
        colorList.add('#1e2069');
        colorList.add('#6fb71d');
        colorList.add('#722287');
        colorList.add('#9e091e');
        colorList.add('#e62877');
        colorList.add('#53866e');
        colorList.add('#e6ae63');
        colorList.add('#40f13b');
        colorList.add('#6ec2ea');
        colorList.add('#ca9284');
        colorList.add('#abfbe0');
        colorList.add('#4dca31');
        colorList.add('#515ef6');
        colorList.add('#9ed2e2');
        colorList.add('#c0d0ae');
        colorList.add('#ed57be');
        colorList.add('#4e1896');
        colorList.add('#eac7e4');
        colorList.add('#7dda62');
        colorList.add('#c66db1');
        colorList.add('#fce8ea');
        colorList.add('#b74400');
        colorList.add('#2960a9');
        colorList.add('#721cbd');
        colorList.add('#1eb8b3');
        colorList.add('#b6b02b');
        colorList.add('#666dbc');
        colorList.add('#dc9bb5');
        colorList.add('#81bf08');
        colorList.add('#72f70c');
        colorList.add('#e330a6');
        colorList.add('#e54242');
        colorList.add('#69dfc0');
        colorList.add('#e166d9');
        colorList.add('#6efcf8');
        colorList.add('#376b96');
        colorList.add('#46cd20');
        colorList.add('#abfee4');
        colorList.add('#b3814f');
        colorList.add('#8729ba');
        colorList.add('#eadc39');
        colorList.add('#5dfed4');
        colorList.add('#15440d');
        colorList.add('#0e5344');
        colorList.add('#124296');
        colorList.add('#3bd175');
        colorList.add('#e1944b');
        colorList.add('#671549');
        colorList.add('#6dc5d0');
        colorList.add('#531329');
        colorList.add('#9ffc8a');
        colorList.add('#2eb2f4');
        colorList.add('#69d1e7');
        colorList.add('#aed676');
        colorList.add('#33181e');
        colorList.add('#f42e0e');
        colorList.add('#879bf7');
        colorList.add('#9ca8f5');
        colorList.add('#38f632');
        colorList.add('#ae9af3');
        colorList.add('#9c62c3');
        colorList.add('#f549e0');
        colorList.add('#98e556');
        colorList.add('#354e0d');
        colorList.add('#f7c15b');
        colorList.add('#482730');
        colorList.add('#828601');
        colorList.add('#80b2a1');
        colorList.add('#2a26a8');
        colorList.add('#5d8f12');
        colorList.add('#271826');
        colorList.add('#86e3c4');
        colorList.add('#45d8bb');
        colorList.add('#2e2dee');
        colorList.add('#8915ba');
        colorList.add('#fab460');
        colorList.add('#37ddf2');
        colorList.add('#c5de92');
        colorList.add('#4db14d');
        colorList.add('#4b4b3b');
        colorList.add('#7413f3');
        colorList.add('#6da4b4');
        colorList.add('#b28470');
        colorList.add('#f5ba11');
        colorList.add('#394f29');
        colorList.add('#8dc9c6');
        colorList.add('#c36120');
        colorList.add('#18c9af');
        colorList.add('#5eb547');
        colorList.add('#c52497');
        colorList.add('#53b4e6');
        colorList.add('#722e93');
        colorList.add('#1319ad');
        colorList.add('#6fa476');
        colorList.add('#d1da5e');
        colorList.add('#ae5cc3');
        colorList.add('#b2c517');
        colorList.add('#b6aa48');
        colorList.add('#6318ec');
        colorList.add('#590070');
        colorList.add('#f9dbc3');
        colorList.add('#1517df');
        colorList.add('#0e8882');
        colorList.add('#10a471');
        colorList.add('#9b6dbf');
        colorList.add('#19f339');
        colorList.add('#231b74');
        colorList.add('#fb44c7');
        colorList.add('#fda9ff');
        colorList.add('#698926');
        colorList.add('#d14dc3');
        colorList.add('#869ac7');
        colorList.add('#dc97b5');
        colorList.add('#56554b');
        colorList.add('#cf1574');
        colorList.add('#a4e7c6');
        colorList.add('#5ab6e2');
        colorList.add('#709498');
        colorList.add('#4cff35');
        colorList.add('#5db15a');
        colorList.add('#7dfe63');
        colorList.add('#18af62');
        colorList.add('#b597b8');
        colorList.add('#565d72');
        colorList.add('#b92447');
        colorList.add('#dccab1');
        colorList.add('#92d2b0');
        colorList.add('#aa02d2');
        colorList.add('#d1b02e');
        colorList.add('#ead661');
        colorList.add('#b9b91d');
        colorList.add('#4ff937');
        colorList.add('#820c70');
        colorList.add('#fcb46d');
        colorList.add('#1f6815');
        colorList.add('#dd3344');
        colorList.add('#764fe8');
        colorList.add('#567d75');
        colorList.add('#84ec9a');
        colorList.add('#6e2050');
        colorList.add('#d16572');
        colorList.add('#230c3f');
        colorList.add('#3f9a2a');
        colorList.add('#a65647');
        colorList.add('#91ef4b');
        colorList.add('#820125');
        colorList.add('#571bad');
        colorList.add('#3b3e26');
        colorList.add('#71e4d1');
        colorList.add('#32e52a');
        colorList.add('#9f4428');
        colorList.add('#e6f339');
        colorList.add('#6833cb');
        colorList.add('#0d6cb6');
        colorList.add('#3decc6');
        colorList.add('#bc948d');
        colorList.add('#8d16e8');
        colorList.add('#2c26ab');
        colorList.add('#d1e7f3');
        colorList.add('#3641f0');
        colorList.add('#869ddd');
        colorList.add('#427f43');
        colorList.add('#b90b99');
        colorList.add('#39a75a');
        colorList.add('#db6248');
        colorList.add('#6c9ce6');
        colorList.add('#74c1f1');
        colorList.add('#5fc7c6');
        colorList.add('#ce8382');
        colorList.add('#71f697');
        colorList.add('#67423f');
        colorList.add('#48bd35');
        colorList.add('#930e8e');
        colorList.add('#b235cd');
        colorList.add('#436e51');
        colorList.add('#a9befd');
        colorList.add('#57e4a0');
        colorList.add('#a04ba6');
        colorList.add('#2473ab');
        colorList.add('#f7a6ce');
        colorList.add('#8fc2cd');
        colorList.add('#a9aee4');
        colorList.add('#ecec76');
        colorList.add('#0c55ec');
        colorList.add('#c95c68');
        colorList.add('#d92178');
        colorList.add('#364721');
        colorList.add('#5200bb');
        colorList.add('#b551a2');
        colorList.add('#561b95');
        colorList.add('#14714c');
        colorList.add('#bea9b0');
        colorList.add('#51d134');
        colorList.add('#98a458');
        colorList.add('#7fe59b');
        colorList.add('#c535aa');
        colorList.add('#1bb5a5');
        colorList.add('#0132fb');
        colorList.add('#1f7705');
        colorList.add('#df4b1b');
        colorList.add('#f174b9');
        colorList.add('#dcdf1e');
        colorList.add('#ffe2b2');
        colorList.add('#c26a58');
        colorList.add('#173147');
        colorList.add('#a7130e');
        colorList.add('#4ae40b');
        colorList.add('#3930d1');
        colorList.add('#d26b0e');
        colorList.add('#a6e371');
        colorList.add('#aa61ac');
        colorList.add('#4a81e1');
        colorList.add('#808dfe');
        colorList.add('#64f7bc');
        colorList.add('#d58675');
        colorList.add('#a3e219');
        colorList.add('#7fa055');
        colorList.add('#a4e2f6');
        colorList.add('#653858');
        colorList.add('#a6503e');
        colorList.add('#2fbe3e');
        colorList.add('#184303');
        colorList.add('#7d9af9');
        colorList.add('#9d73fa');
        colorList.add('#4fa279');
        colorList.add('#03359f');
        colorList.add('#8dad77');
        colorList.add('#8d5289');
        colorList.add('#9ad93c');
        colorList.add('#d4dee6');
        colorList.add('#166e69');
        colorList.add('#a7cb25');
        colorList.add('#c531a5');
        colorList.add('#d9d687');
        colorList.add('#00a7e2');
        colorList.add('#319a98');
        colorList.add('#7b0ba6');
        colorList.add('#8a2de5');
        colorList.add('#6c940f');
        colorList.add('#912c32');
        colorList.add('#25d187');
        colorList.add('#a84539');
        colorList.add('#ba16f9');
        colorList.add('#cdc8af');
        colorList.add('#46bb54');
        colorList.add('#7efd8e');
        colorList.add('#2f64e8');
        colorList.add('#37acf9');
        colorList.add('#02c700');
        colorList.add('#9175bb');
        colorList.add('#e80ead');
        colorList.add('#5952c6');
        colorList.add('#370c24');
        colorList.add('#153b31');
        colorList.add('#c45aa0');
        colorList.add('#c5cfdb');
        colorList.add('#6e415f');
        colorList.add('#b64dbb');
        colorList.add('#7f6f90');
        colorList.add('#25b299');
        colorList.add('#161d16');
        colorList.add('#3e0df1');
        colorList.add('#3ab971');
        colorList.add('#eaaeba');
        colorList.add('#cdd607');
        colorList.add('#832014');
        colorList.add('#1efea3');
        colorList.add('#b9dd48');
        colorList.add('#6afec2');
        colorList.add('#b4cf13');
        colorList.add('#ac914e');
        colorList.add('#e4a815');
        colorList.add('#5ccda5');
        colorList.add('#043b82');
        colorList.add('#2e4820');
        colorList.add('#3fd2ec');
        colorList.add('#6125f0');
        colorList.add('#6385cd');
        colorList.add('#16d9aa');
        colorList.add('#069549');
        colorList.add('#ff5067');
        colorList.add('#f7b4bb');
        colorList.add('#891562');
        colorList.add('#bffb17');
        colorList.add('#fcaf30');
        colorList.add('#98f1bd');
        colorList.add('#379151');
        colorList.add('#18c079');
        colorList.add('#c84b13');
        colorList.add('#e3f0e6');
        colorList.add('#d1b896');
        colorList.add('#e92ce2');
        colorList.add('#e9b8bb');
        colorList.add('#632b42');
        colorList.add('#aa8d4e');
        colorList.add('#64ff1f');
        colorList.add('#ba53dc');
        colorList.add('#6e5e28');
        colorList.add('#86d524');
        colorList.add('#92d1e0');
        colorList.add('#7804b6');
        colorList.add('#f8f972');
        colorList.add('#37a0fe');
        colorList.add('#122bcd');
        colorList.add('#7cc205');
        colorList.add('#aa6b30');
        colorList.add('#95c58a');
        colorList.add('#7c7989');
        colorList.add('#da3c52');
        colorList.add('#47b0f0');
        colorList.add('#2d6497');
        colorList.add('#0bd323');
        colorList.add('#24c7db');
        colorList.add('#fe800a');
        colorList.add('#da4435');
        colorList.add('#eeacfc');
        colorList.add('#c30b4f');
        colorList.add('#0568f4');
        colorList.add('#0387bd');
        colorList.add('#5a43b4');
        colorList.add('#0dedfc');
        colorList.add('#06dae5');
        colorList.add('#3a6205');
        colorList.add('#6220cb');
        colorList.add('#0e2df7');
        colorList.add('#cea54a');
        colorList.add('#6c3c1d');
        colorList.add('#5a4f7d');
        colorList.add('#371fad');
        colorList.add('#ff091f');
        colorList.add('#1de4ac');
        colorList.add('#060e36');
        colorList.add('#b2da59');
        colorList.add('#91404f');
        colorList.add('#66488a');
        colorList.add('#8aed26');
        colorList.add('#085cc2');
        colorList.add('#9b046f');
        colorList.add('#6b54a8');
        colorList.add('#fed869');
        colorList.add('#b5cbc6');
        colorList.add('#61c852');
        colorList.add('#a2f2b1');
        colorList.add('#b815db');
        colorList.add('#7e71d6');
        colorList.add('#b06acc');
        colorList.add('#512a5d');
        colorList.add('#338999');
        colorList.add('#c155d5');
        colorList.add('#7d655b');
        colorList.add('#176501');
        colorList.add('#3c9fe3');
        colorList.add('#7dfa5e');
        colorList.add('#2d45f7');
        colorList.add('#72da82');
        colorList.add('#9d26ff');
        colorList.add('#89a6b1');
        colorList.add('#81108b');
        colorList.add('#fd5d91');
        colorList.add('#fda634');
        colorList.add('#5cc910');
        colorList.add('#848705');
        colorList.add('#69ec49');
        colorList.add('#34c63b');
        colorList.add('#5f4cad');
        colorList.add('#4d5622');
        colorList.add('#21ae0c');
        colorList.add('#e85070');
        colorList.add('#f4a6ba');
        colorList.add('#b64c53');
        colorList.add('#d6faf9');
        colorList.add('#2282c8');
        colorList.add('#9349d6');
        colorList.add('#e1081d');
        colorList.add('#35b60a');
        colorList.add('#6693d8');
        colorList.add('#d37ac6');
        colorList.add('#8c2432');
        colorList.add('#db8a7a');
        colorList.add('#26a1de');
        colorList.add('#00ec84');
        colorList.add('#8f19c0');
        colorList.add('#e028c9');
        colorList.add('#5c0c9c');
        colorList.add('#82fba0');
        colorList.add('#fdfd8a');
        colorList.add('#ba4f26');
        colorList.add('#57b978');
        colorList.add('#93df53');
        colorList.add('#0b1de2');
        colorList.add('#2da9ea');
        colorList.add('#3b4535');
        colorList.add('#b7dcb3');
        colorList.add('#30ebdc');
        colorList.add('#3ef513');
        colorList.add('#549026');
        colorList.add('#180a2c');
        colorList.add('#b6748b');
        colorList.add('#5519b0');
        colorList.add('#a310d2');
        colorList.add('#273341');
        colorList.add('#3f71a7');
        colorList.add('#9392d1');
        colorList.add('#d5506e');
        colorList.add('#661880');
        colorList.add('#b0a13b');
        colorList.add('#12c3ff');
        colorList.add('#13b7a9');
        colorList.add('#fc763c');
        colorList.add('#f65afc');
        colorList.add('#935b21');
        colorList.add('#cc526a');
        colorList.add('#4f6453');
        colorList.add('#4d4f03');
        colorList.add('#ee5161');
        colorList.add('#4ad5bb');
        colorList.add('#2c7acf');
        colorList.add('#8ae803');
        colorList.add('#b2c2bd');
        colorList.add('#eb4db6');
        colorList.add('#52c512');
        colorList.add('#ff78d8');
        colorList.add('#98056e');
        colorList.add('#4dc468');
        colorList.add('#bc24d2');
        colorList.add('#1fd0e0');
        colorList.add('#f4f067');
        colorList.add('#06a0ee');
        colorList.add('#b64f68');
        colorList.add('#4c6903');
        colorList.add('#a1ee44');
        colorList.add('#2a12db');
        colorList.add('#471ed6');
        colorList.add('#ebf146');
        colorList.add('#c09474');
        colorList.add('#2342ee');
        colorList.add('#5f466e');
        colorList.add('#2b710b');
        colorList.add('#451e54');
        colorList.add('#0d2918');
        colorList.add('#1180e5');
        colorList.add('#e8317c');
        colorList.add('#7f80a1');
        colorList.add('#8ba257');
        colorList.add('#e612c3');
        colorList.add('#e72e29');
        colorList.add('#12407d');
        colorList.add('#86e389');
        colorList.add('#6ae4ee');
        colorList.add('#63f87e');
        colorList.add('#90e185');
        colorList.add('#e9a434');
        colorList.add('#875e23');
        colorList.add('#f53dd0');
        colorList.add('#ec628c');
        colorList.add('#6cb1cd');
        colorList.add('#9dbafe');
        colorList.add('#220947');
        colorList.add('#3a7174');
        colorList.add('#caf008');
        colorList.add('#f66c3c');
        colorList.add('#ac857f');
        colorList.add('#884350');
        colorList.add('#806f11');
        colorList.add('#5da6ac');
        colorList.add('#15e011');
        colorList.add('#3dbc3c');
        colorList.add('#dc2da1');
        colorList.add('#df180c');
        colorList.add('#a268a5');
        colorList.add('#06762a');
        colorList.add('#34a5a6');
        */
        //SA20162112 End

        
        return colorList[integer.valueof(Math.floor(Math.random() * colorList.size()))];
    }
    

    /******************************************************
    * Method Name :  DisplayLimitInformation
    * Description :  display limits information, used for debugging
    * Return Type :  void
    * Parameters :  none
    *******************************************************/
    public static void DisplayLimitInformation()
    {
        system.debug( 'CPU Time:' + Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime() );
        system.debug( 'DML Rows:' + Limits.getDMLRows() + ' / ' + Limits.getLimitDMLRows() );
        system.debug( 'DML Statements:' + Limits.getDMLStatements() + ' / ' + Limits.getLimitDMLStatements() );
        system.debug( 'Heap Size:' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize() );
        system.debug( 'Queries:' + Limits.getQueries() + ' / ' + Limits.getLimitQueries() );
        system.debug( 'Queries Rows:' + Limits.getQueryRows() + ' / ' + Limits.getLimitQueryRows());
    }
    
    /******************************************************
    * Method Name :  CountryTwoCodeToThreeCode
    * Description :  convert two character country iso codes to three chracter codes
    * Return Type :  string
    * Parameters :  string CountryTwoCode
    *******************************************************/
    public static string CountryTwoCodeToThreeCode(string CountryTwoCode)
    {
        
        //make upper case
        CountryTwoCode = CountryTwoCode.toUpperCase();
        CountryTwoCode = CountryTwoCode.trim();
        Map<String, String> countryMap= New Map<String, String>{
            
            'AF'=>'AFG',    'AX'=>'ALA',    'AL'=>'ALB',    'DZ'=>'DZA',    'AS'=>'ASM',    'AD'=>'AND',    'AO'=>'AGO',    'AI'=>'AIA',    'AQ'=>'ATA',    'AG'=>'ATG',    'AR'=>'ARG',    'AM'=>'ARM',    'AW'=>'ABW',    
            'AU'=>'AUS',    'AT'=>'AUT',    'AZ'=>'AZE',    'BS'=>'BHS',    'BH'=>'BHR',    'BD'=>'BGD',    'BB'=>'BRB',    'BY'=>'BLR',    'BE'=>'BEL',    'BZ'=>'BLZ',    'BJ'=>'BEN',    'BM'=>'BMU',    'BT'=>'BTN',
            'BO'=>'BOL',    'BA'=>'BIH',    'BW'=>'BWA',    'BV'=>'BVT',    'BR'=>'BRA',    'IO'=>'IOT',    'VG'=>'VGB',    'BN'=>'BRN',    'BG'=>'BGR',    'BF'=>'BFA',    'BI'=>'BDI',    'KH'=>'KHM',    'CM'=>'CMR',
            'CA'=>'CAN',    'CV'=>'CPV',    'KY'=>'CYM',    'CF'=>'CAF',    'TD'=>'TCD',    'CL'=>'CHL',    'CN'=>'CHN',    'CX'=>'CXR',    'CC'=>'CCK',    'CO'=>'COL',    'KM'=>'COM',    'CG'=>'COG',    'CD'=>'COD',
            'CK'=>'COK',    'CR'=>'CRI',    'HR'=>'HRV',    'CU'=>'CUB',    'CY'=>'CYP',    'CZ'=>'CZE',    'CI'=>'CIV',    'DK'=>'DNK',    'DJ'=>'DJI',    'DM'=>'DMA',    'DO'=>'DOM',    'EC'=>'ECU',    'EG'=>'EGY',
            'SV'=>'SLV',    'GQ'=>'GNQ',    'ER'=>'ERI',    'EE'=>'EST',    'ET'=>'ETH',    'FK'=>'FLK',    'FO'=>'FRO',    'FJ'=>'FJI',    'FI'=>'FIN',    'FR'=>'FRA',    'GF'=>'GUF',    'PF'=>'PYF',    'TF'=>'ATF',
            'GA'=>'GAB',    'GM'=>'GMB',    'GE'=>'GEO',    'DE'=>'DEU',    'GH'=>'GHA',    'GI'=>'GIB',    'GR'=>'GRC',    'GL'=>'GRL',    'GD'=>'GRD',    'GP'=>'GLP',    'GU'=>'GUM',    'GT'=>'GTM',    'GG'=>'GGY',
            'GN'=>'GIN',    'GW'=>'GNB',    'GY'=>'GUY',    'HT'=>'HTI',    'HM'=>'HMD',    'VA'=>'VAT',    'HN'=>'HND',    'HK'=>'HKG',    'HU'=>'HUN',    'IS'=>'ISL',    'IN'=>'IND',    'ID'=>'IDN',    'IR'=>'IRN',
            'IQ'=>'IRQ',    'IE'=>'IRL',    'IM'=>'IMN',    'IL'=>'ISR',    'IT'=>'ITA',    'JM'=>'JAM',    'JP'=>'JPN',    'JE'=>'JEY',    'JO'=>'JOR',    'KZ'=>'KAZ',    'KE'=>'KEN',    'KI'=>'KIR',    'KP'=>'PRK',
            'KR'=>'KOR',    'KW'=>'KWT',    'KG'=>'KGZ',    'LA'=>'LAO',    'LV'=>'LVA',    'LB'=>'LBN',    'LS'=>'LSO',    'LR'=>'LBR',    'LY'=>'LBY',    'LI'=>'LIE',    'LT'=>'LTU',    'LU'=>'LUX',    'MO'=>'MAC',
            'MK'=>'MKD',    'MG'=>'MDG',    'MW'=>'MWI',    'MY'=>'MYS',    'MV'=>'MDV',    'ML'=>'MLI',    'MT'=>'MLT',    'MH'=>'MHL',    'MQ'=>'MTQ',    'MR'=>'MRT',    'MU'=>'MUS',    'YT'=>'MYT',    'MX'=>'MEX',
            'FM'=>'FSM',    'MD'=>'MDA',    'MC'=>'MCO',    'MN'=>'MNG',    'ME'=>'MNE',    'MS'=>'MSR',    'MA'=>'MAR',    'MZ'=>'MOZ',    'MM'=>'MMR',    'NA'=>'NAM',    'NR'=>'NRU',    'NP'=>'NPL',    'NL'=>'NLD',
            'AN'=>'ANT',    'NC'=>'NCL',    'NZ'=>'NZL',    'NI'=>'NIC',    'NE'=>'NER',    'NG'=>'NGA',    'NU'=>'NIU',    'NF'=>'NFK',    'MP'=>'MNP',    'NO'=>'NOR',    'OM'=>'OMN',    'PK'=>'PAK',    'PW'=>'PLW',
            'PS'=>'PSE',    'PA'=>'PAN',    'PG'=>'PNG',    'PY'=>'PRY',    'PE'=>'PER',    'PH'=>'PHL',    'PN'=>'PCN',    'PL'=>'POL',    'PT'=>'PRT',    'PR'=>'PRI',    'QA'=>'QAT',    'RO'=>'ROU',    'RU'=>'RUS',
            'RW'=>'RWA',    'RE'=>'REU',    'SH'=>'SHN',    'KN'=>'KNA',    'LC'=>'LCA',    'PM'=>'SPM',    'VC'=>'VCT',    'BL'=>'BLM',    'MF'=>'MAF',    'WS'=>'WSM',    'SM'=>'SMR',    'ST'=>'STP',    'SA'=>'SAU',
            'SN'=>'SEN',    'RS'=>'SRB',    'SC'=>'SYC',    'SL'=>'SLE',    'SG'=>'SGP',    'SK'=>'SVK',    'SI'=>'SVN',    'SB'=>'SLB',    'SO'=>'SOM',    'ZA'=>'ZAF',    'GS'=>'SGS',    'SS'=>'SSD',    'ES'=>'ESP',
            'LK'=>'LKA',    'SD'=>'SDN',    'SR'=>'SUR',    'SJ'=>'SJM',    'SZ'=>'SWZ',    'SE'=>'SWE',    'CH'=>'CHE',    'SY'=>'SYR',    'TW'=>'TWN',    'TJ'=>'TJK',    'TZ'=>'TZA',    'TH'=>'THA',    'TL'=>'TLS',
            'TG'=>'TGO',    'TK'=>'TKL',    'TO'=>'TON',    'TT'=>'TTO',    'TN'=>'TUN',    'TR'=>'TUR',    'TM'=>'TKM',    'TC'=>'TCA',    'TV'=>'TUV',    'UG'=>'UGA',    'UA'=>'UKR',    'AE'=>'ARE',    'GB'=>'GBR',    
            'UM'=>'UMI',    'US'=>'USA',    'UY'=>'URY',    'UZ'=>'UZB',    'VU'=>'VUT',    'VE'=>'VEN',    'VN'=>'VNM',    'VI'=>'VIR',    'WF'=>'WLF',    'EH'=>'ESH',    'YE'=>'YEM',    'ZM'=>'ZMB',    'ZW'=>'ZWE'
            
        };
        
        String countryCode;
        if (countryMap.containsKey(CountryTwoCode)){
            countryCode = countryMap.get(CountryTwoCode);
        }
        
        else{
        countryCode = 'Unkown - ' + CountryTwoCode;
        }
        
        return countryCode;
        
        
    }
    
    
}