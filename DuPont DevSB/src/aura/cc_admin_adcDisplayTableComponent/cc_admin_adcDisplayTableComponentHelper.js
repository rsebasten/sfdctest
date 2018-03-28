({
    getPriceListItem : function(component, helper) {
      var priceListItemId = component.get("v.recordId");

      this.ccrzAction(component, 'c.getPriceListAttributes', {"priceListItemId" : priceListItemId}, function(data) {
          component.set("v.jsonDelimiter", data.jsonKeys.delimiter);
          component.set("v.jsonApmap", data.jsonKeys.apmap);
          component.set("v.jsonType", data.jsonKeys.type);
          component.set("v.jsonPrice", data.jsonKeys.price);

          var primaryAttribute = null;
          var secondaryAttribute = null;
          var tertiaryAttribute = null
          var primaryAttributeOptions = [];
          var secondaryAttributeOptions = [];
          var tertiaryAttributeOptions = [];
          var priAttrOptsLookup = [];
          var secAttrOptsLookup = [];
          var terAttrOptsLookup = [];
          var attributeCount = Object.getOwnPropertyNames(data.attributeData.attributeList).length;
          // this one has to be synchronous because we need to reference this data later
          for(var i = 0; i < attributeCount; i++) {
              var currentAttribute = data.attributeData.attributeList[Object.getOwnPropertyNames(data.attributeData.attributeList)[i]];
              // check for the main three
              if(currentAttribute.sfid == data.primaryAttr) {
                  primaryAttribute = {name: currentAttribute.sfdcName, ID: currentAttribute.attributeID};
              }
              if(currentAttribute.sfid == data.secondaryAttr) {
                  secondaryAttribute = {name: currentAttribute.sfdcName, ID: currentAttribute.attributeID};
              }
              if(currentAttribute.sfid == data.tertiaryAttr) {
                  tertiaryAttribute = {name: currentAttribute.sfdcName, ID: currentAttribute.attributeID};
              }
              // check for a list, these should be returned already sorted by sequence
              if(currentAttribute.parentAttribute == data.primaryAttr) {
                  primaryAttributeOptions.push({name: currentAttribute.sfdcName, ID: currentAttribute.attributeID});
                  priAttrOptsLookup[currentAttribute.attributeID] = currentAttribute.sfdcName;
              }
              if(currentAttribute.parentAttribute == data.secondaryAttr) {
                  secondaryAttributeOptions.push({name: currentAttribute.sfdcName, ID: currentAttribute.attributeID});
                  secAttrOptsLookup[currentAttribute.attributeID] = currentAttribute.sfdcName;
              }
              if(currentAttribute.parentAttribute == data.tertiaryAttr) {
                  tertiaryAttributeOptions.push({name: currentAttribute.sfdcName, ID: currentAttribute.attributeID});
                  terAttrOptsLookup[currentAttribute.attributeID] = currentAttribute.sfdcName;
              }
          };
          component.set("v.primaryAttribute", primaryAttribute);
          component.set("v.primaryAttributeOptions", primaryAttributeOptions);
          component.set("v.secondaryAttribute", secondaryAttribute);
          component.set("v.secondaryAttributeOptions", secondaryAttributeOptions);
          component.set("v.tertiaryAttribute", tertiaryAttribute);
          component.set("v.tertiaryAttributeOptions", tertiaryAttributeOptions);

          var attributeList = [];
          if(data.hasOwnProperty('pricingBlob')) {
              var pricingObj = JSON.parse(data.pricingBlob);

              Object.getOwnPropertyNames(pricingObj[data.jsonKeys.apmap]).forEach(function(pVal, pIdx, pArr) {
                  var primaryAttributeName = pVal.substr(0, pVal.indexOf(data.jsonKeys.delimiter));
                  var primaryAttributeValueID = pVal.substr(pVal.indexOf(data.jsonKeys.delimiter) + 1);
                  var primaryAttributeValueName = (priAttrOptsLookup[primaryAttributeValueID] == null ? primaryAttributeValueID : priAttrOptsLookup[primaryAttributeValueID]);
                  if(pricingObj[data.jsonKeys.apmap][pVal].hasOwnProperty(data.jsonKeys.apmap)) {
                      Object.getOwnPropertyNames(pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.apmap]).forEach(function(sVal, sIdx, sArr) {
                          var secondaryAttributeID = sVal.substr(0, sVal.indexOf(data.jsonKeys.delimiter));
                          var secondaryAttributeValueID = sVal.substr(sVal.indexOf(data.jsonKeys.delimiter) + 1);
                          var secondaryAttributeValueName = (secAttrOptsLookup[secondaryAttributeValueID] == null ? secondaryAttributeValueID : secAttrOptsLookup[secondaryAttributeValueID]);
                          if(pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.apmap][sVal].hasOwnProperty(data.jsonKeys.apmap)) {
                              Object.getOwnPropertyNames(pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.apmap][sVal][data.jsonKeys.apmap]).forEach(function(tVal, tIdx, tArr) {
                                  var tertiaryAttributeID = tVal.substr(0, tVal.indexOf(data.jsonKeys.delimiter));
                                  var tertiaryAttributeValueID = tVal.substr(tVal.indexOf(data.jsonKeys.delimiter) + 1);;
                                  var tertiaryAttributeValueName = (terAttrOptsLookup[tertiaryAttributeValueID] == null ? tertiaryAttributeValueID : terAttrOptsLookup[tertiaryAttributeValueID]);
                                  var price = pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.apmap][sVal][data.jsonKeys.apmap][tVal][data.jsonKeys.price];

                                  attributeList.push({primary: {name: primaryAttributeValueName, ID: primaryAttributeValueID}, secondary: {name: secondaryAttributeValueName, ID: secondaryAttributeValueID}, tertiary: {name: tertiaryAttributeValueName, ID: tertiaryAttributeValueID}, price: price});
                              });
                          } else {
                              // only two attributes

                              var price = pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.apmap][sVal][data.jsonKeys.price];
                              attributeList.push({primary: {name: primaryAttributeValueName, ID: primaryAttributeValueID}, secondary: {name: secondaryAttributeValueName, ID: secondaryAttributeValueID}, price: price});
                          }
                      });
                  } else {
                      // only one attribute
                      var price = pricingObj[data.jsonKeys.apmap][pVal][data.jsonKeys.price];
                      attributeList.push({primary: {name: primaryAttributeValueName, ID: primaryAttributeValueID}, price: price});
                  }
              });
          }

          component.set("v.currentAttributes", attributeList);

          $A.util.addClass(component.find("stencilTable"), 'slds-hide');
          if(primaryAttribute) {
            $A.util.removeClass(component.find("attributeTable"), 'slds-hide');
          } else {
            $A.util.removeClass(component.find("noAttributeMessage"), 'slds-hide');
          }
      });
    },

    getLookupList: function(attributeList) {
        var lookupList = [];
        for(var i = 0; i < attributeList.length; i++) {
            lookupList[attributeList[i].ID] = attributeList[i].name;
        }
        return lookupList;
    },

    clearInputs: function(component, helper) {
        var primaryEl = component.find("primarySelect").set("v.value", null);
        var secondaryEl = component.find("secondarySelect");
        if(secondaryEl) {
            secondaryEl.set("v.value", null);
        }
        var tertiaryEl = component.find("tertiarySelect");
        if(tertiaryEl) {
            tertiaryEl.set("v.value", null);
        }
        var priceEl = component.find("price").set("v.value", "0");

    },

    saveToObject: function(component, helper) {
        // Note: it fails without this line here. I think trying to initialize an Apex controller function from within a promise causes some kind of issue.
        var actionLoad = component.get("c.saveAttributePricing");

        helper.transformIn(component).then(
            $A.getCallback(function(result) {
                var attributeString = JSON.stringify(result);
                var pliId = component.get("v.recordId");
                helper.ccrzAction(component, 'c.saveAttributePricing', {"pliID" : pliId, "attributePricing" : attributeString}, function(data) {
                    // do nothing
                });
            })
        );
	  },
    transformIn: function(component) {
        return new Promise($A.getCallback(function(resolve, reject) {
            var jsonDelimiter = component.get("v.jsonDelimiter");
            var jsonApmap = component.get("v.jsonApmap");
            var jsonType = component.get("v.jsonType");
            var jsonPrice = component.get("v.jsonPrice");

            var primaryAttributeType = component.get("v.primaryAttribute");
            var secondaryAttributeType = component.get("v.secondaryAttribute");
            var tertiaryAttributeType = component.get("v.tertiaryAttribute");

            var currentAttributes = component.get("v.currentAttributes").slice();

            // Sort by primary, then secondary, then tertiary.
            var attributeSorter = function(a, b) {
                if(a.primary.ID < b.primary.ID) {
                    return -1;
                }
                if(a.primary.ID > b.primary.ID) {
                    return 1;
                }
                if(a.primary.ID == b.primary.ID) {
                    if(a.secondary.ID && b.secondary.ID) {
                        if(a.secondary.ID < b.secondary.ID) {
                            return -1;
                        }
                        if(a.secondary.ID > b.secondary.ID) {
                            return 1;
                        }
                        if(a.secondary.ID == b.secondary.ID) {
                            if(a.tertiary.ID && b.tertiary.ID) {
                                if(a.tertiary.ID < b.tertiary.ID) {
                                    return -1;
                                }
                                if(a.tertiary.ID > b.tertiary.ID) {
                                    return 1;
                                }
                            }
                        }
                    }
                }
                return 0;
            }
            currentAttributes.sort(attributeSorter);

            var transformedObject = {};
            transformedObject[jsonType] = "sparseAbsolute";
            transformedObject[jsonApmap] = {};

            var currentPrimaryID = null;
            var currentPrimaryObject = null;
            var currentSecondaryID = null;
            var currentSecondaryObject = null;
            for(var i = 0; i < currentAttributes.length; i++) {
                var price = currentAttributes[i].price;
                var primaryTitle = primaryAttributeType.ID + jsonDelimiter + currentAttributes[i].primary.ID;
                if(secondaryAttributeType != null) {
                    var secondaryTitle = secondaryAttributeType.ID + jsonDelimiter + currentAttributes[i].secondary.ID;
                    if (!transformedObject[jsonApmap].hasOwnProperty(primaryTitle)) {
                        transformedObject[jsonApmap][primaryTitle] = {};
                        transformedObject[jsonApmap][primaryTitle][jsonApmap] = {};
                    }
                    if(tertiaryAttributeType) {
                        if(!transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle]) {
                            transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle] = {};
                            transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle][jsonApmap] = {};
                        }
                        var tertiaryTitle = tertiaryAttributeType.ID + jsonDelimiter + currentAttributes[i].tertiary.ID;
                        transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle][jsonApmap][tertiaryTitle] = {};
                        transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle][jsonApmap][tertiaryTitle][jsonPrice] = price;
                    } else {
                        transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle] = {};
                        transformedObject[jsonApmap][primaryTitle][jsonApmap][secondaryTitle][jsonPrice] = price;
                    }
                } else {
                    transformedObject[jsonApmap][primaryTitle] = {};
                    transformedObject[jsonApmap][primaryTitle][jsonPrice] = price;
                }
            }

            resolve(transformedObject);
        }));
    },

    checkIfRowExists: function(component, helper, rowData) {
        var currentAttributes = component.get("v.currentAttributes");

        for(var i = 0; i < currentAttributes.length; i++) {
            if(currentAttributes[i].primary.ID == rowData.primary.ID &&
               (!currentAttributes[i].hasOwnProperty('secondary') || currentAttributes[i].secondary.ID == rowData.secondary.ID) &&
               (!currentAttributes[i].hasOwnProperty('tertiary') || currentAttributes[i].tertiary.ID == rowData.tertiary.ID)) {
                return true;
            }
        }
        return false;
    },

    setRowToViewMode: function(component, event, helper) {
        var button = event.getSource ? event.getSource().getElement() : event.target;

        var priceDisplay = button.parentElement.parentElement.getElementsByClassName('priceDisplay')[0];
        var priceEdit = button.parentElement.parentElement.getElementsByClassName('priceEditWrapper')[0];
        var editRow = button.parentElement.parentElement.getElementsByClassName('editRow')[0];
        var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];

        priceDisplay.classList.remove('slds-hide');
        priceEdit.classList.add('slds-hide');
        editRow.classList.add('slds-hide');
        buttonRow.classList.remove('slds-hide');
    },

    setRowToEditMode: function(component, event, helper) {
        var button = event.getSource ? event.getSource().getElement() : event.target;

        var priceDisplay = button.parentElement.parentElement.getElementsByClassName('priceDisplay')[0];
        var priceEdit = button.parentElement.parentElement.getElementsByClassName('priceEditWrapper')[0];
        var editRow = button.parentElement.parentElement.getElementsByClassName('editRow')[0];
        var buttonRow = button.parentElement.parentElement.getElementsByClassName('buttonRow')[0];

        priceDisplay.classList.add('slds-hide');
        priceEdit.classList.remove('slds-hide');
        editRow.classList.remove('slds-hide');
        buttonRow.classList.add('slds-hide');
    },

    ccrzAction: function(component, actionName, params, success, error, final) {
  		var action = component.get(actionName);
  		action.setParams(params);
  		var helper = this;

  		action.setCallback(this, function(response) {
  			var state = response.getState();
  			if (component.isValid() && state === "SUCCESS") {
  				if (success) {
  					var data = response.getReturnValue();
  					success(data);
  				}
  			} else if (state === "ERROR") {
  				var errors = response.getError();
  				var message = "Unknown error";
  				if (errors) {
  					if (errors[0] && errors[0].message) {
  						message = errors[0].message;
  					} else if (errors[0] && errors[0].pageErrors[0] && errors[0].pageErrors[0].message) {
  						message = errors[0].pageErrors[0].message;
  					} else if (errors[0] && errors[0].fieldErrors) {
  						for (var prop in errors[0].fieldErrors) {
  							if (errors[0].fieldErrors[prop][0].message) {
  								console.message += errors[0].fieldErrors[prop][0].message + ' ';
  							}
  						}
  					}
  				}
  				if (error) {
  					error(errors, message);
  				}
  			}
  			if (final) {
  				final(response);
  			}
  		});
  		$A.enqueueAction(action);
  	}
})