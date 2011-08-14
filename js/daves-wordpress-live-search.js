/**
 * Copyright (c) 2009 Dave Ross <dave@csixty4.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **/
 
///////////////////////
// LiveSearch
///////////////////////

function LiveSearch() {
	var resultsElement = '';
	var searchBoxes = '';
}

LiveSearch.activeRequests = new Array();

/**
 * Initialization for the live search plugin.
 * Sets up the key handler and creates the search results list.
 */
LiveSearch.init = function() {
	
	jQuery("body").append('<ul class="search_results"></ul>');
	this.resultsElement = jQuery('ul').filter('.search_results');
	this.resultsElement.hide();
	
	// Add the keypress handler
	// Using keyup because keypress doesn't recognize the backspace key
	// and that's kind of important.
	LiveSearch.searchBoxes = jQuery("input").filter("[name='s']");
	LiveSearch.searchBoxes.keyup(LiveSearch.handleKeypress);

	if(!LiveSearch.searchBoxes.outerHeight) {
		alert(DavesWordPressLiveSearchConfig.outdatedJQuery);
	}
	
	// Prevent browsers from doing autocomplete on the search field
	LiveSearch.searchBoxes.parents('form').attr('autocomplete', 'off');
	
	// Hide the search results when the search box loses focus
	jQuery("html").click(LiveSearch.hideResults);
	LiveSearch.searchBoxes.add(this.resultsElement).click(function(e) { e.stopPropagation(); });

	jQuery(window).resize(function() {
		var wasVisible = LiveSearch.resultsElement.is(':visible');
		LiveSearch.positionResults(this); 
		// Resizing the window was making the results visible again
		if(!wasVisible) {
			LiveSearch.resultsElement.hide(); 
		}
	});	
}

LiveSearch.positionResults = function() {
	
	// Look for the search box. Exit if there isn't one.
	if(LiveSearch.searchBoxes.size() === 0) {
		return false;
	}
		
	// Position the ul right under the search box	
	var searchBoxPosition = LiveSearch.searchBoxes.offset();
	searchBoxPosition.left += DavesWordPressLiveSearchConfig.xOffset;
	this.resultsElement.css('left', searchBoxPosition.left);
	this.resultsElement.css('display', 'block');
	
    switch(DavesWordPressLiveSearchConfig.resultsDirection)
    {
    	case 'up':
    		var topOffset = searchBoxPosition.top - this.resultsElement.height();
    		break;
    	case 'down':
    	default:
    		var topOffset = searchBoxPosition.top + LiveSearch.searchBoxes.outerHeight();
    }
	
	this.resultsElement.css('top', topOffset + 'px');
};

/**
 * Process the search results that came back from the AJAX call
 */
LiveSearch.handleAJAXResults = function(e) {

    LiveSearch.activeRequests.pop();

    if(e) {
        resultsSearchTerm = e.searchTerms;
        if(resultsSearchTerm != LiveSearch.searchBoxes.val()) {

                if(LiveSearch.activeRequests.length == 0) {
                        LiveSearch.removeIndicator();
                }

                return;
        }

        var resultsShownFor = jQuery("ul").filter(".search_results").children("input[name=query]").val();
        if(resultsShownFor != "" && resultsSearchTerm == resultsShownFor)
        {
                if(LiveSearch.activeRequests.length == 0) {
                        LiveSearch.removeIndicator();
                }

                return;
        }

        var searchResultsList = jQuery("ul").filter(".search_results");
        searchResultsList.empty();
        searchResultsList.append('<input type="hidden" name="query" value="' + resultsSearchTerm + '" />');

        if(e.results.length == 0) {
                // Hide the search results, no results to show
                LiveSearch.hideResults();
        }
        else {
                for(var postIndex = 0; postIndex < e.results.length; postIndex++) {
                        var searchResult = e.results[postIndex];
                        if(searchResult.post_title !== undefined) {



                                var renderedResult = '';

                                // Thumbnails
                                if(DavesWordPressLiveSearchConfig.showThumbs && searchResult.attachment_thumbnail) {
                                        var liClass = "post_with_thumb";
                                }
                                else {
                                        var liClass = "";
                                }

                                renderedResult += '<li class="' + liClass + '">';

                                // Render thumbnail
                                if(DavesWordPressLiveSearchConfig.showThumbs && searchResult.attachment_thumbnail) {
                                        renderedResult += '<img src="' + searchResult.attachment_thumbnail + '" class="post_thumb" />';
                                }

                                renderedResult += '<a href="' + searchResult.permalink + '">' + searchResult.post_title + '</a>';

                                if(searchResult.post_price != undefined) { renderedResult += '<p class="price">' + searchResult.post_price + '</p>'; }
                                
                                if(DavesWordPressLiveSearchConfig.showExcerpt && searchResult.post_excerpt) {
                                        renderedResult += '<p class="excerpt clearfix">' + searchResult.post_excerpt + '</p>';
                                }

                                if(e.displayPostMeta) {
                                        renderedResult += '<p class="meta clearfix" id="daves-wordpress-live-search_author">Posted by ' + searchResult.post_author_nicename + '</p><p id="daves-wordpress-live-search_date" class="meta clearfix">' + searchResult.post_date + '</p>';
                                }
                                renderedResult += '<div class="clearfix"></div></li>';
                                searchResultsList.append(renderedResult);
                        }
                }

				if(searchResult.show_more != undefined && searchResult.show_more && DavesWordPressLiveSearchConfig.showMoreResultsLink) {
	                // "more" link
	                searchResultsList.append('<div class="clearfix search_footer"><a href="' + DavesWordPressLiveSearchConfig.blogURL + '/?s=' + resultsSearchTerm + '">' + DavesWordPressLiveSearchConfig.viewMoreText + '</a></div>');
				}

                // Show the search results
                LiveSearch.showResults();

        }

        if(LiveSearch.activeRequests.length == 0) {
                LiveSearch.removeIndicator();
        }
    }
};

/**
 * Keypress handler. Sets up a 0 sec. timeout which then
 * kicks off the actual query.s
 */
LiveSearch.handleKeypress = function(e) {
	var delayTime = 0;
	var term = LiveSearch.searchBoxes.val();
	setTimeout( function() { LiveSearch.runQuery(term); }, delayTime);
};

/**
 * Do the AJAX request for search results, or hide the search results
 * if the search box is empty.
 */
LiveSearch.runQuery = function(terms) {
	
	var srch=LiveSearch.searchBoxes.val();
	if(srch === "" || srch.length < DavesWordPressLiveSearchConfig.minCharsToSearch) {
		// Nothing entered. Hide the autocomplete.
		LiveSearch.hideResults();
		LiveSearch.removeIndicator();
	}
	else {
		// Do an autocomplete lookup
		LiveSearch.displayIndicator();
		
		// Clear out the old requests in the queue
		while(LiveSearch.activeRequests.length > 0)
		{
			var req = LiveSearch.activeRequests.pop();
			req.abort();
		}
		// do AJAX query
		//var currentSearch = jQuery("input[name='s']").val();
		var currentSearch = terms;
		var parameters = {s: currentSearch};
                var searchSource = jQuery("input").filter("[name='search_source']").val();
                if(searchSource != undefined) {
                    parameters.search_source = searchSource;
                }
        
        // For wp_ajax
		parameters.action = "dwls_search";
		
		var ajaxURL = DavesWordPressLiveSearchConfig.blogURL + "/wp-admin/admin-ajax.php";
		var req = jQuery.get( ajaxURL, parameters, LiveSearch.handleAJAXResults, "json");
		
		// Add this request to the queue
		LiveSearch.activeRequests.push(req);
	}
};

LiveSearch.hideResults = function() {
	switch(DavesWordPressLiveSearchConfig.resultsDirection)
	{
		case 'up':
			jQuery("ul").filter(".search_results:visible").fadeOut();
			return;
		case 'down':
		default:
			jQuery("ul").filter(".search_results:visible").slideUp();
			return;
	}
};

LiveSearch.showResults = function() {

	this.positionResults();
	
	switch(DavesWordPressLiveSearchConfig.resultsDirection)
	{
		case 'up':
			jQuery("ul").filter(".search_results:hidden").fadeIn();
			return;
		case 'down':
		default:
			jQuery("ul").filter(".search_results:hidden").slideDown();	
			return;
	}
};

/**
 * Display the "spinning wheel" AJAX activity indicator
 */
LiveSearch.displayIndicator = function() {
	
	if(jQuery("#search_results_activity_indicator").size() === 0) {

		jQuery("body").append('<img id="search_results_activity_indicator" src="' + DavesWordPressLiveSearchConfig.indicatorURL + '" />');

		var searchBoxPosition = LiveSearch.searchBoxes.offset();

		jQuery("#search_results_activity_indicator").css('position', 'absolute');
		
		var indicatorY = (searchBoxPosition.top + ((LiveSearch.searchBoxes.outerHeight() - LiveSearch.searchBoxes.innerHeight()) / 2) + 'px');
		
		jQuery("#search_results_activity_indicator").css('top', indicatorY);

		var indicatorX = (searchBoxPosition.left + LiveSearch.searchBoxes.outerWidth() - DavesWordPressLiveSearchConfig.indicatorWidth - 2) + 'px';
						
		jQuery("#search_results_activity_indicator").css('left', indicatorX);
	}
};

/**
 * Hide the "spinning wheel" AJAX activity indicator
 */
LiveSearch.removeIndicator = function() {
	jQuery("#search_results_activity_indicator").remove();
};

/////////////
// Utilities
/////////////
LiveSearch.util = {};

/**
 * Returns the filename component of the path.
 * Used here to help find this script's <script> tag
 * @see http://phpjs.org/functions/basename
 * @see http://www.experts-exchange.com/Programming/Languages/Scripting/JavaScript/Q_24662495.html
 * @return string
 */
LiveSearch.util.basename = function(path, suffix) {
    // Returns the filename component of the path  
    // 
    // version: 909.322
    // discuss at: http://phpjs.org/functions/basename
    // +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Ash Searle (http://hexmen.com/blog/)
    // +   improved by: Lincoln Ramsay
    // +   improved by: djmix
    // *     example 1: basename('/www/site/home.htm', '.htm');
    // *     returns 1: 'home'
    var b = path.replace(/^.*[\/\\]/g, '');
    
    if (typeof(suffix) == 'string' && b.substr(b.length-suffix.length) == suffix) {
        b = b.substr(0, b.length-suffix.length);
    }
    
    return b;
}

///////////////////
// Initialization
///////////////////

jQuery(function() {
	LiveSearch.init();
});
