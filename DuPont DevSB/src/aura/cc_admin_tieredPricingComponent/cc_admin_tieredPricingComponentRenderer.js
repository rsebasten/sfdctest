({
	afterRender: function(component, helper) {
		this.superAfterRender();
		setTimeout(
			$A.getCallback(function(){
				// We have to do this once after the initial render
				component.set("v.firstRenderComplete", true);
				helper.updatePriceInput(component, helper);
			}), 500
		);

	}
})