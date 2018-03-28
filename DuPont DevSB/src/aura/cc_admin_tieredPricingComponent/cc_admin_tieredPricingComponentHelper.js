({
	calculateMaxValues: function (tiers, component) {
		if (tiers) {
			for (var i = 0; i < tiers.length; i++) {
				tiers[i].max = "Max";
				if (!isNaN(parseFloat(tiers[i].q)) && isFinite(tiers[i].q)) {
					if (i > 0) {
						tiers[i - 1].max = tiers[i].q - 1;
					} else {
						$A.util.removeClass(component.find("baseMaxTo"), 'slds-hide');
						component.set("v.baseMax", tiers[i].q - 1);
					}
				} else {
					//tiers[i].max = "Invalid Quantity";
					if (i > 0) {
						tiers[i - 1].max = "Invalid Quantity";
					} else {
						$A.util.addClass(component.find("baseMaxTo"), 'slds-hide');
						component.set("v.baseMax", "Create Minimum Quantity");
					}
				}
			}
		}
		return tiers;
	},

	calculateUnitPrices: function (tiers, tierType, basePrice, helper) {
		if (tiers) {
			for (var i = 0; i < tiers.length; i++) {
				if (tierType === 'tAbsDisc') {
					tiers[i].unitPrice = (parseFloat(basePrice) + parseFloat(tiers[i].p)).toFixed(2);
				}
				if (tierType === 'tPercDisc') {
					tiers[i].unitPrice = helper.roundTo((1 + (tiers[i].p / 100)) * basePrice, 2);
				}
			}
		}
		return tiers;
	},

	ccrzAction: function (component, actionName, params, success, error, final) {
		var action = component.get(actionName);
		action.setParams(params);
		var helper = this;

		action.setCallback(this, function (response) {
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
	},

	changeType: function (component, event, helper, loadedType) {
		// Resetting firstRenderComplete will make the table blink (or possibly stall slightly) while this is going on
		// It's the only way to get around the issue where items inside of <aura:iteration/>s don't invlalidate
		component.set("v.firstRenderComplete", false);
		$A.util.removeClass(component.find("stencilTable"), 'slds-hide');
		var newType = loadedType ? loadedType : event.getSource().get("v.value");
		if (typeof newType === 'undefined' || newType === "none") {
			component.set("v.selectedType", "null");
		} else {
			$A.util.removeClass(component.find('valueTypeSelect'), 'slds-has-error');
			component.set("v.selectedType", newType);
		}

		if (component.get("v.firstRenderComplete")) {
			helper.updatePriceInput(component, helper);
		}

		if (event === null) {
			// this is only called manually on initialization
			var selectBox = component.find("valueTypeSelect");
			if (selectBox) {
				selectBox.set("v.value", newType);
			}
		}

		// update tiers
		helper.updateRows(component, helper, newType);

		switch (newType) {
			case "tAbsPrice":
				component.set("v.amountHeaderText", "Amount");
				component.set("v.typeDisplayText", "Absolute Price");
				break;
			case "tAbsDisc":
				component.set("v.amountHeaderText", "Amount");
				component.set("v.typeDisplayText", "Price Adjustment");
				break;
			case "tPercDisc":
				component.set("v.amountHeaderText", "Percentage");
				component.set("v.typeDisplayText", "Percent Adjustment");
				break;
			case "none":
			default:
				component.set("v.amountHeaderText", "Amount");
				component.set("v.typeDisplayText", "Select Above");
				break;
		}

		setTimeout(
			$A.getCallback(function () {
				$A.util.addClass(component.find("stencilTable"), 'slds-hide');
				component.set("v.firstRenderComplete", true);
				helper.updatePriceInput(component, helper);
			}), 100
		);

	},

	clearRows: function (component, event, helper) {
		component.set("v.currentTiers", null);
		$A.util.addClass(component.find("tableWrapper"), 'slds-hide');
		$A.util.removeClass(component.find("noTiersMessage"), 'slds-hide');
		helper.showMessage(component, "Rows cleared. Click save to commit.");
	},

	createRow: function (component, event, helper) {
		var currentTiers = component.get("v.currentTiers");
		var quantityKey = component.get("v.jsonQuantity");
		var priceKey = component.get("v.jsonPrice");

		var newRow = {max: "", unitPrice: ""};
		newRow[quantityKey] = "";
		newRow[priceKey] = "";

		if (currentTiers && currentTiers.length > 0) {
			currentTiers.push(newRow);
		} else {
			currentTiers = [newRow];
		}

		var basePrice = component.get("v.basePrice");
		var tierType = component.get("v.selectedType");

		currentTiers = helper.calculateUnitPrices(helper.calculateMaxValues(helper.sortRows(currentTiers), component), tierType, basePrice, helper);

		component.set("v.currentTiers", currentTiers);
		$A.util.removeClass(component.find("tableWrapper"), 'slds-hide');
		$A.util.addClass(component.find("noTiersMessage"), 'slds-hide');

		// wait for rendering to finish
		setTimeout(
			$A.getCallback(function () {
				helper.updatePriceInput(component, helper);
				var scrollArea = component.find('scrollArea').getElement();
				scrollArea.scrollTop = scrollArea.scrollHeight;
			}), 0);
	},

	deleteRow: function (component, index) {
		var currentTiers = component.get("v.currentTiers");
		currentTiers.splice(index, 1);
		component.set("v.currentTiers", currentTiers);

	},

	getPriceListItem: function (component, helper) {
		var priceListItemId = component.get("v.recordId");

		this.ccrzAction(component, 'c.getTieredPricing', {"priceListItemId": priceListItemId}, function (data) {
			component.set("v.jsonTiersKey", data.jsonKeys.tiersKey);
			component.set("v.jsonQuantity", data.jsonKeys.quantity);
			component.set("v.jsonType", data.jsonKeys.tierType);
			component.set("v.jsonPrice", data.jsonKeys.price);
			component.set("v.itemType", data.itemType);

			var basePrice = data.basePrice;
			component.set("v.basePrice", basePrice);

			if (data.hasOwnProperty('pricingBlob')) {
				var pricingObj = JSON.parse(data.pricingBlob);
				var tierType = pricingObj[data.jsonKeys.tierType];
				var tiers = helper.transformToUI(pricingObj[data.jsonKeys.tiersKey], tierType);

				component.set("v.currentTiers", tiers);

				// this will set the type and do the calculations for the tiers
				helper.changeType(component, null, helper, tierType);

				$A.util.removeClass(component.find("tableWrapper"), 'slds-hide');
			}
			else {
				$A.util.removeClass(component.find("noTiersMessage"), 'slds-hide');
			}

			$A.util.addClass(component.find("stencilTable"), 'slds-hide');

		});
	},

	/* Round to Even (Gaussian rounding) doesn't exist in native JS */
	roundTo: function(n, digits) {
		digits = digits || 0;

		var multiplier = Math.pow(10, digits);
		var integerVersion = +(digits ? n * multiplier : n).toFixed(11); // keep enough digits for now
		var floorInteger = Math.floor(integerVersion);
		var roundingDecimals = integerVersion - floorInteger;
		var jsFloatErrorAllowance = 1e-8;
		var roundedInteger = (roundingDecimals > 0.5 - jsFloatErrorAllowance && roundingDecimals < 0.5 + jsFloatErrorAllowance) ? ((floorInteger % 2 === 0) ? floorInteger : floorInteger + 1) : Math.round(integerVersion);

		return (digits ? roundedInteger / multiplier : roundedInteger).toFixed(digits);
	},

	saveToRecord: function (component, event, helper, successMessage, failMessage, checkValidity) {
		if (!checkValidity || helper.validateRows(component, event, helper)) {

			helper.updateItemType(component, event, helper);

			var priceListItemId = component.get("v.recordId");
			var pricingBlob = null;
			var tiers = component.get("v.currentTiers");
			if (tiers && tiers.length > 0) {
				var transformObj = helper.transformToPLI(component, event, helper);
				pricingBlob = JSON.stringify(transformObj, function(key, value) {
					if(Number.isNaN(Number.parseFloat(value))) {
						return value;
					} else {
						return Number.parseFloat(value);
					}
				});
			}
			var itemType = component.get("v.itemType");

			this.ccrzAction(component, 'c.saveTieredPricing', {
				"pliID": priceListItemId,
				"tieredPricing": pricingBlob,
				"itemType": itemType
			}, function (data) {
				// should probably check for errors here, but we're not bubbling any up
				helper.showMessage(component, successMessage);
			});
		} else {
			helper.showMessage(component, failMessage);
		}
	},

	showMessage: function (component, message) {
		component.set("v.toastMessage", message);
		$A.util.removeClass(component.find("notificationContainer"), 'notificationHide');
		setTimeout(
			$A.getCallback(function () {
				$A.util.addClass(component.find("notificationContainer"), 'notificationHide');
			}), 3000);
	},

	sortComponents: function (tiers) {
		if (tiers && tiers.length > 0) {
			tiers.sort(function (a, b) {
				// sort blanks to the bottom
				if (a.get("v.value") === "" && b.get("v.value") !== "") {
					return 1;
				}
				if (a.get("v.value") !== "" && b.get("v.value") === "") {
					return -1;
				}
				return a.get("v.value") - b.get("v.value");
			})
		}
		return tiers;
	},

	sortRows: function (tiers) {
		if (tiers && tiers.length > 0) {
			tiers.sort(function (a, b) {
				// sort blanks to the bottom
				if (a.q === "" && b.q !== "") {
					return 1;
				}
				if (a.q !== "" && b.q === "") {
					return -1;
				}
				return a.q - b.q;
			})
		}
		return tiers;
	},

	transformToPLI: function (component, event, helper) {
		var jsonTiersKey = component.get("v.jsonTiersKey");
		var jsonTiersTypeKey = component.get("v.jsonType");
		var selectedType = component.get("v.selectedType");
		var currentTiers = component.get("v.currentTiers");

		var transformedTiers = [];

		if (currentTiers && currentTiers.length) {
			for (var i = 0; i < currentTiers.length; i++) {
				var item = {
					q: currentTiers[i].q,
					p: currentTiers[i].p
				};
				if(selectedType === 'tPercDisc') {
					item.p = helper.roundTo(1 + (currentTiers[i].p / 100), 2);
				}
				transformedTiers.push(item);
			}
		}

		var transformedObject = {};
		transformedObject[jsonTiersKey] = transformedTiers;
		transformedObject[jsonTiersTypeKey] = selectedType;

		return transformedObject;
	},

	transformToUI: function(tiers, type) {
		if(type === 'tPercDisc') {
			for (var i = 0; i < tiers.length; i++) {
				tiers[i].p = parseFloat(((tiers[i].p - 1) * 100).toPrecision(11)); // fix JS rounding errors
			}
		}
		return tiers;
	},

	updateItemType: function (component, event, helper) {
		var itemType = component.get("v.itemType");
		// coerce undefined into null
		if (typeof itemType === 'undefined') {
			itemType = null;
		}
		var currentTiers = component.get("v.currentTiers");
		if (currentTiers && currentTiers.length > 0) {
			if (itemType === null || itemType.indexOf('tiered') === -1) {
				if (itemType && itemType.length > 0) {
					itemType += ',';
				} else {
					// coerce to a string
					itemType = '';
				}
				itemType += 'tiered';
			}
		} else {
			// retain null if we're not changing anything
			if (itemType !== null && itemType.indexOf('tiered') >= 0) {
				itemType = itemType.replace(/,*tiered/, '');
			}
		}
		component.set("v.itemType", itemType);
	},

	updatePriceInput: function (component, helper) {
		var priceInput = component.find("priceInput");
		var newType = component.get("v.selectedType");
		if (typeof priceInput !== 'undefined' && priceInput) {
			// if there's only one row, we'll get a single element, otherwise we'll get an array
			// we can't test for type, since both are technically proxies, so we just have to see if
			// it has a length, which will be "undefined" on a single element
			if (priceInput.length) {
				for (var i = 0; i < priceInput.length; i++) {
					if (newType === "tPercDisc") {
						priceInput[i].set("v.formatter", "");
						priceInput[i].set("v.step", "any");
					} else {
						priceInput[i].set("v.formatter", "currency");
						priceInput[i].set("v.step", "0.01");
					}
				}
			} else {
				if (newType === "tPercDisc") {
					priceInput.set("v.formatter", "");
					priceInput.set("v.step", "any");
				} else {
					priceInput.set("v.formatter", "currency");
					priceInput.set("v.step", "0.01");
				}
			}
		}
	},

	updateRows: function (component, helper, newTierType) {
		var tiers = component.get("v.currentTiers");
		var basePrice = component.get("v.basePrice");
		var tierType = newTierType ? newTierType : component.get("v.selectedType");
		if (tiers && tiers.length) {
			tiers = helper.calculateUnitPrices(helper.calculateMaxValues(helper.sortRows(tiers), component), tierType, basePrice, helper);
		}
		component.set("v.currentTiers", tiers);
	},

	validateRows: function (component, event, helper) {
		var currentTiers = component.get("v.currentTiers");
		var tierType = component.get("v.selectedType");
		var isValid = true;

		if (currentTiers && currentTiers.length > 0) {
			// loop through all inputs to force their validation messages
			// We also need to sort this manually, since "find" doesn't necessarily give it to us in order
			var quantityComponents = helper.sortComponents(component.find('quantity'));
			if (quantityComponents.length) {
				isValid = quantityComponents.reduce(function (validSoFar, inputCmp, currentIndex, array) {
					inputCmp.showHelpMessageIfInvalid();
					// duplicate detection disabled since there's no easy way to set a custom error on a
					// lightning:input and duplicate detection isn't in the acceptance criteria
					/* if (currentIndex > 0) {
						if (inputCmp.get('v.value') !== "" && inputCmp.get('v.value') === array[currentIndex - 1].get('v.value')) {
							// We have to set the error manually.
							$A.util.addClass(inputCmp, 'slds-has-error');
							$A.util.addClass(array[currentIndex - 1], 'slds-has-error');
							return false;
						}
					} */
					return validSoFar && inputCmp.get('v.validity').valid;
				}, true);
			} else {
				quantityComponents.showHelpMessageIfInvalid();
				isValid = isValid && quantityComponents.get('v.validity').valid;
			}
			var priceInputCmps = helper.sortComponents(component.find('priceInput'));
			if (quantityComponents.length) {
				// logical and with isValid AFTER the reduce or else reduce won't run
				isValid = priceInputCmps.reduce(function (validSoFar, inputCmp) {
					inputCmp.showHelpMessageIfInvalid();
					return validSoFar && inputCmp.get('v.validity').valid;
				}, true) && isValid;
			} else {
				priceInputCmps.showHelpMessageIfInvalid();
				isValid = isValid && priceInputCmps.get('v.validity').valid;
			}

			// check the data we're actually saving for validity, just in case
			for (var i = 0; i < currentTiers.length; i++) {
				if (currentTiers[i].p === "" || currentTiers[i].q === "") {
					isValid = false;
				}
			}
		}

		if(!tierType || tierType === "null" || tierType === "none") {
			$A.util.addClass(component.find('valueTypeSelect'), 'slds-has-error');
			isValid = false;
		}

		return isValid;
	}

})