/**
 * jquery.numberformatter_sfdc - jQuery Formatting/Parsing Numbers using SFDC locale formats
 * Written by Thomas Snyder (tom@3ddd.com) Date: Apr 11 2011 @version 1.0.0
 *
 * this is a modifed version of the jquery.numberformatter
 * written by Michael Abernethy  Date: 1/26/08 @version 1.1.0
 * Dual licensed under the MIT (MIT-LICENSE.txt) and GPL (GPL-LICENSE.txt) licenses.
 *
 * This plugin can be used to format numbers as text and parse text as Numbers
 * Because we live in an international world, we cannot assume that everyone
 * uses "," to divide thousands, and "." as a decimal point.
 *
 * The format() function will take the text within any selector by calling
 * text() or val() on them, getting the String, and applying the specified format to it.
 * It will return the jQuery object
 *
 * The parse() function will take the text within any selector by calling text()
 * or val() on them, turning the String into a Number, and returning these
 * values in a Number array.
 * It WILL BREAK the jQuery chain, and return an Array of Numbers.
 *
 * The syntax for the formatting is:
 * 0 = Digit
 * # = Digit, zero shows as absent
 * . = Decimal separator
 * - = Negative sign
 * , = Grouping Separator
 * % = Percent (multiplies the number by 100)
 * For example, a format of "#,###.00" and text of 4500.20 will
 * display as "4.500,20" with a locale of "de", and "4,500.20" with a locale of "us"
 *
 *******************************************************************************************************/
  
 (function(jQuery) {
 
      function FormatData(dec, group, neg) {
        this.dec = dec;
        this.group = group;
        this.neg = neg;
      };
  	 /////////////////////////////////////////////////////////////////////////
 	function formatCodes(locale) {
 
 		// default values
 		var dec = ".";
 		var group = ",";
 		var neg = "-";
 		var typ1 = ["ar","ar_ae","ar_bh","ar_jo","ar_kw","ar_lb","ar_sa","en_au","en_bb","en_bm","en_ca","en_gb","en_gh","en_id","en_ie","en_ie_euro","en_nz","en_sg","en_us","en_za","en","es_cr","es_gt","es_hn","es_mx","es_pr","es_sv","hy_am","iw","iw_il","ja","ja_jp","kk_kz","km_kh","ko","ko_kr","ms_my","th","th_th","ur_pk","zh","zh_cn","zh_hk","zh_tw"]; 
 		var typ2 = ["bg_bg","cs","cs_cz","et_ee","fi","fi_fI","fi_fi_euro","fr","fr_ca","fr_fr","fr_fr_euro","fr_lu","fr_mc","hu","lt_lt","lv_lv","no","no_no","pl","ru","ru_ru","sk_sk","sv","sv_se"];
 		var typ3 = ["ca","ca_es","ca_es_euro","da","da_dk","de","de_at","de_at_euro","de_de","de_de_euro","de_lu","de_lu_euro","el","el_gr","es","es_ar","es_bo","es_cl","es_co","es_ec","es_es","es_es_euro","es_pe","es_py","es_uy","es_ve","fr_be","hr_hr","in","is_is","it","it_it","nl","nl_be","nl_nl","nl_sr","pt","pt_ao","pt_br","pt_pt","ro","ro_ro","sl_si","tr","uk","uk_ua","vi","vi_vn"];
 		var typ4 = ["de_ch","fr_ch","it_ch"];
 		
 		if (j$.inArray(locale,typ1)!=-1) 		{dec = "."; group = ",";}
 		else if (j$.inArray(locale,typ2)!=-1) 	{dec = ","; group = " ";}
 		else if (j$.inArray(locale,typ3)!=-1) 	{dec = ","; group = ".";}
 		else if (j$.inArray(locale,typ4)!=-1) 	{dec = "."; group = "'";}
		else 									{dec = "."; group = ",";}

         return new FormatData(dec, group, neg);
 
     };
 
 	 /////////////////////////////////////////////////////////////////////////
	 //format a number to its locale 
 	 jQuery.formatNumber = function(numToFormat, options) {
 	 
 	     var options = jQuery.extend({},jQuery.fn.format.defaults, options);
 	     var formatData = formatCodes(options.locale.toLowerCase());
 	
 	     var dec = formatData.dec;
 	     var group = formatData.group;
 	     var neg = formatData.neg;
 	     
		 var validFormat = "0#-,.";
		 
 	         // strip all the invalid characters at the beginning and the end
 	         // of the format, and we'll stick them back on at the end
 	         // make a special case for the negative sign "-" though, so 
 	         // we can have formats like -$23.32
 	         var prefix = "";
 	         var negativeInFront = false;
 	         for (var i=0; i<options.format.length; i++) {
 	            if (validFormat.indexOf(options.format.charAt(i))==-1)
 	                prefix = prefix + options.format.charAt(i);
 	            else if (i==0 && options.format.charAt(i)=='-') {
 	               negativeInFront = true;
 	               continue;
 	            }
 	            else
 	                break;
 	         }
 	         var suffix = "";
 	         for (var i=options.format.length-1; i>=0; i--) {
 	            if (validFormat.indexOf(options.format.charAt(i))==-1)
 	                suffix = options.format.charAt(i) + suffix;
 	            else
 	                break;
 	         }
 	 	
 	         options.format = options.format.substring(prefix.length);
 	         options.format = options.format.substring(0, options.format.length - suffix.length);
 	
			if ("{!$CurrentPage.parameters.debug}"=="1") alert('debug:jQuery.formatNumber() before:'+numToFormat);
 	
 			//convert to string (if needed) so we can cleanse
	        if(!numToFormat.replace) 
	        	numToFormat+=''; 
	        //parse number	
			number=jQuery.parseNumber(numToFormat,options);
			
 	        if ("{!$CurrentPage.parameters.debug}"=="1") alert('debug:jQuery.formatNumber() after:'+number);
 	
 	        // special case for percentages
 	        if (suffix == "%") number = number * 100;
 	
 	        var returnString = "";
 	        
 	        var decimalValue = number % 1;
 	        if (options.format.indexOf(".") > -1) {
 	           var decimalPortion = dec;
 	           var decimalFormat = options.format.substring(options.format.lastIndexOf(".")+1);
 	           var decimalString = new String(decimalValue.toFixed(decimalFormat.length));
 	           decimalString = decimalString.substring(decimalString.lastIndexOf(".")+1);
 	           for (var i=0; i<decimalFormat.length; i++) {
 	              if (decimalFormat.charAt(i) == '#' && decimalString.charAt(i) != '0') {
 	                 decimalPortion += decimalString.charAt(i);
 	                 break;
 	              }
 	              else if (decimalFormat.charAt(i) == "0") {
 	                 decimalPortion += decimalString.charAt(i);
 	              }
 	           }
 	           returnString += decimalPortion
 	        }
 	        else
 	           number = Math.round(number);
 	        
 	        var ones = Math.floor(number);
 	        if (number < 0) ones = Math.ceil(number);
 	
 	        var onePortion = "";
 	        if (ones == 0) {
 	           onePortion = "0";
 	        }
 	        else {
 	           // find how many digits are in the group
 	           var onesFormat = "";
				if (options.format.indexOf(".") == -1)
 	           		onesFormat = options.format;
 	           	else
 	           		 onesFormat = options.format.substring(0, options.format.indexOf("."));
 	           
 	           var oneText = new String(ones);
 	           var groupLength = 9999;
 	           if (onesFormat.lastIndexOf(",") != -1)
 	               groupLength = onesFormat.length - onesFormat.lastIndexOf(",")-1;
 	           var groupCount = 0;
 	           for (var i=oneText.length-1; i>-1; i--) {
 	             onePortion = oneText.charAt(i) + onePortion;
 	             groupCount++;
 	             if (groupCount == groupLength && i!=0) {
 	                 onePortion = group + onePortion;
 	                 groupCount = 0;
 	             }
 	           }
 	        }
 	        
 	        returnString = onePortion + returnString;
 	        
 	        // handle special case where negative is in front of the invalid characters
 	        if (number < 0 && negativeInFront && prefix.length > 0) {
 	           returnString = returnString.substring(1);
 	           prefix = neg + prefix;
 	        }
 	        returnString = prefix + returnString + suffix; 
 	        return  returnString;    
 	 };

 	 /////////////////////////////////////////////////////////////////////////
 	 
  	 jQuery.isValidNumber = function(number, options) {	
  	 	return (!isNaN(parseFloat(jQuery.parseNumber(number, options))));
  	 }
 
  	 /////////////////////////////////////////////////////////////////////////
 	//converts a local encoded number to a workable (US) equiv
 	 jQuery.parseNumber = function(text, options) {
 	 
 	     var options = jQuery.extend({},jQuery.fn.parse.defaults, options);
 	     var formatData = formatCodes(options.locale.toLowerCase());
 	     var dec = formatData.dec;
 	     var group = formatData.group;
 	     var neg = formatData.neg;
		 var valid = "1234567890.-";
 	
 	     var array = [];

		// now we need to convert it into a number
		if (group==" ") text = text.replace(/\s/g,"");  //causes issues in IE, (but only at init????)
	     else if (group==".") text = text.valueOf().replace(/\./g,"");
	     else if (group==",") text = text.valueOf().replace(/,/g,"");
	     text = new String(text.replace(dec,".").replace(neg,"-"));
	
	      var validText = "";
	      var hasPercent = false;
	      if (text.charAt(text.length-1)=="%")
	          hasPercent = true;
	      for (var i=0; i<text.length; i++)
	      {
	         if (valid.indexOf(text.charAt(i))>-1)
	            validText = validText + text.charAt(i);
	      }
	      var number = new Number(validText);
	      if (hasPercent) {
	         number = number / 100;
	         number = number.toFixed(validText.length-1);
	      }
			return number;
 	 }; 
 	 
 	 /////////////////////////////////////////////////////////////////////////
 	  	 
 	 jQuery.fn.format = function(options) {
		 return this.each(function(){
			 var text = new String(jQuery(this).text());
			 if (jQuery(this).is(":input"))
				text = new String(jQuery(this).val());
				res = jQuery.formatNumber(text, options)
			if (jQuery(this).is(":input"))
			   jQuery(this).val(res);
			else
			   jQuery(this).text(res);
		 });
	};
  	 /////////////////////////////////////////////////////////////////////////
  	 	
 	 jQuery.fn.parse = function(options) {
 	     var array = [];
 	     return this.each(function(){
 			var text;
 			try { text = new String(jQuery(this).text());} catch(err){}
			if (jQuery(this).is(":input")) text = new String(jQuery(this).val());
			array.push(jQuery.parseNumber(text, options));
 			});
 	     return array;
 	 };
 
 	 /////////////////////////////////////////////////////////////////////////
 	
 	 jQuery.fn.parse.defaults = {
 	      locale: "us"
 	 };
  	 /////////////////////////////////////////////////////////////////////////	
 	 jQuery.fn.format.defaults = {
 	      format: "#,##0.00",
 	      locale: "us"
 	 };
 	
 	
 	 })(jQuery);
  	 