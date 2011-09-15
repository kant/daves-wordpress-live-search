=== Plugin Name ===
Contributors: csixty4
Donate link: http://catguardians.org
Tags: search, AJAX, live search
Requires at least: 2.9
Tested up to: 3.2.1
Stable tag: 2.5

Adds "live search" functionality to your WordPress site. Uses the built-in search and jQuery.

== Description ==

Dave's WordPress Live Search adds "live search" functionality to your WordPress site. As visitors type words into your WordPress site's search box, the plugin continually queries WordPress, looking for search results that match what the user has typed so far.

The [live search](http://ajaxpatterns.org/Live_Search) technique means that most people will find the results they are looking for before they finish typing their query, and it saves them the step of having to click a submit button to get their search results.

This functionality requires Javascript, but the search box still works normally if Javascript is not available.

This plugin is compatible with the [xLanguage](http://wordpress.org/extend/plugins/xlanguage/) and [WPML](http://wpml.org/) plugins for internationalization (i18n) of search results.

This plugin also integrates with the Relevanssi plugin for improved search results.

TRANSLATORS WANTED: Since v2.3, Dave's WordPress Live Search supports multiple languages, but I need native speakers and translators to provide .po files for unsupported languages. [Email Dave if interested](mailto:dave@davidmichaelross.com).

NOTE: Dave's WordPress Live Search requires PHP 5.0 or higher.

Interested in helping with this plugin's development? The official "trunk" is always in WordPress's SVN repository, but I keep the latest code at [GitHub](https://github.com/daveross/daves-wordpress-live-search) if you want to branch send a pull request.

== Installation ==

1. Upload the `daves-wordpress-live-search` directory to your site's `/wp-content/plugins/` directory
1. Activate the plugin through the 'Plugins' menu in WordPress
1. Configure it! Go to the 'Settings' menu and pick 'Live Search'. Here, you'll find options to control the look of your search results. By default, they're pretty plain, but you can change the color scheme or even tell it to display an excerpt of each post.

== Screenshots ==

1. Demonstration of Dave's WordPress Live Search

== Frequently Asked Questions ==

Q: It's not working!
A: Check the following:
1. This plugin wont work if you password-protected your wp-admin directory. If you want to protect this directory, see http://www.nkuttler.de/post/htaccess-protect-wordpress-admin/ for instructions on locking it down while still allowing AJAX
1. Make sure no other plugin is including an earlier version of jQuery

I don't get asked a lot of questions about this plugin, so here's the "known issues":

1. There must only be one search box per page. If there is more than one search box, the plugin gets confused. This may be fixed in a future release.
1. In the HTML, your search box must be named "s". This is the name the standard search widget uses, so this is only an issue for themers who include their own search box.
1. This plugin will not work on PHP 4.x

== Wish List ==

Features I want to implement in future releases:

1. Modify the CSS directly on the admin screen (so it's not tied to a theme).
1. "No results found" message (optional)

== Changelog ==

=2.5=
* 2011-09-14 Dave Ross <dave@csixty4.com>
* WPML compatibility (thanks for the license!)
* Pruned some outdated code
* Better handling of Javascript config variables

= 2.4 =
* 2011-08-29 Dave Ross <dave@csixty4.com>
* Fix for i18n loading issue

= 2.3 =
* 2011-08-03 Dave Ross <dave@csixty4.com>
* Added a hook to keep Relevanssi integration out of the main code
* i18n for admin screens and user-facing text

= 2.2 =
* 2011-07-27 Dave Ross <dave@csixty4.com>
* Option to disable "View more results" link

= 2.1.1 =
* 2011-07-16 Dave Ross <dave@csixty4.com>
* Fix for Relevanssi issue
* Passing correct $capability string to admin_menu() - thanks lag47!
* Configurable excerpt length (for Alok)

= 2.1 =
* 2011-05-20 Dave Ross <dave@csixty4.com>
* Major code cleanup & streamlining
* Added z-index:999999 to all the default CSS files
* Removed jQuery Dimensions plugin. It's in jQuery core > 1.2.6 & recent WP releases include jQuery 1.4
* (Hopefully) fixed IE8 hang issue (jQuery Dimensions)

= 2.0.2 =
* 2011-03-09 Dave Ross <dave@csixty4.com>
* Fix for determining plugin URL when WordPress is installed in a subdirectory
* Sprinkled in static declarations where needed
* Better? fix for determining plugin URL when WP Subdomains is installed

= 2.0.1 =
* 2011-02-28 Dave Ross <dave@csixty4.com>
* Pass WP_Query a parameter telling it to only return "publish" items (no drafts) -- WP3.1 regression case?

= 2.0 =
* 2011-02-24 Dave Ross <dave@csixty4.com>
* Using wp_ajax actions now (deprecating my bootstrap on every AJAX call)
* Static Javascript (not generated) and inline configuration
* Cached search results for anonymous users
* Debug tab for advanced users. Just shows cache dump for now.
* WordPress 3.1 compatibility!

= 1.20 =
* 2011-01-10 Dave Ross <dave@csixty4.com>
* Generate a static version of the Javascript file

= 1.19 =
* 2011-01-09 Dave Ross <dave@csixty4.com>
* Fixed bug with Relevanssi and setting to display 0 (unlimited) posts
* Display an alert if another plugin is loading jQuery < 1.2.6

= 1.18 =
* 2010-12-04 Dave Ross <dave@csixty4.com>
* Search "any" content (posts, pages, custom post types)
* Better compatibility with Relevanssi plugin (worked with Mikko from that project)
* Minor jQuery performance improvements

= 1.17 =
* 2010-10-25 Dave Ross <dave@csixty4.com>
* Split options into "Settings" and "Advanced" tabs
* X Offset setting to position the results dropdown
* Include pages (as well as posts) in search results
* Raised minimum requirement to WP 2.9 (required for "Include pages" change)

= 1.16 =
* 2010-10-07 Dave Ross <dave@csixty4.com>
* Fixed "max results" functionality lost when implementing WP E-Commerce compatibility
* Compatibility w/servers that don't allow getimagesize() to use URLs
* Merged in Ron Schirmacher's code for WP E-Commerce tag & meta search
* Compatibility with WP E-Commerce when table names are used
* Fix for autocomplete suppression

= 1.15.1 =
* 2010-08-17 Dave Ross <dave@csixty4.com>
* Default hidden source option to 0 (search WP, not WP E-Commerce)

= 1.15 =
* 2010-08-12 Dave Ross <dave@csixty4.com>
* Option to not include any additional CSS file (thanks Andy Hall!)
* Support for xLanguage plugin
* Support for searching WP E-Commerce products
* Replaced clearfix that was somehow lost

= 1.14 =
* 2010-07-03 Dave Ross <dave@csixty4.com>
* z-index:9999 for cadbloke to keep search results above all other content (that doesn't already have a z-index of 9999 or higher)
* Hidden results display when resizing window http://wordpress.org/support/topic/410612

= 1.13 =
* 2010-05-02 Dave Ross <dave@csixty4.com>
* Fixed changelog formatting
* Reposition the search results popup when the window is resized
* Send AJAX results with a test/javascript content-type

= 1.12 =
* 2010-03-23 Dave Ross <dave@csixty4.com>
* Now compatible with WP-Subdomains plugin
* Format dates using WordPress date setting
* Added MIT license text to daves-wordpress-live-search.js.php and daves-wordpress-live-search-bootstrap.php files

= 1.11 =
* 2010-02-24 Dave Ross <dave@csixty4.com>
* Support for wp-config.php outside main WordPress directory (2.6+)
* Fix to make "view more results" link work on pages other than home
* Fix path to stylesheet directory
* Fix compatibility with child themes

= 1.10 =
* 2010-02-14 Dave Ross <dave@csixty4.com>
* Added option for minimum number of characters that need to be entered before triggering a search
* More graceful failure message in PHP4
* Added code to ignore E_STRICT warnings when E_STRICT enabled on PHP 5.3
* Possible fix for compatibility with Relevanssi plugin (some concern this isn't working yet)
* Fix for compatibility with child themes
* Added MIT license to DavesWordPressLiveSearch.php class

= 1.9 =
* 2009-12-02 Dave Ross <dave@csixty4.com>
* Tested compatibility with WordPress 2.3-2.9 beta 2
* Fixed stylesheet issue with WordPress 2.5.x
* Set minimum WordPress version to 2.6. Admin page doesn't appear in 2.5.
* Added support for WordPress 2.9 "post thumbnails"
* Put autocomplete="off" on the form instead of the search box (fix for Firefox issue?)
* Use "Display Name" instead of "username"
* Javascript performance improvements
* Added page exception list
* Live search no longer tries to add itself to admin pages

= 1.8 =
* 2009-10-25 Dave Ross <dave@csixty4.com>
* Added note about WP-Minify
* Tested with WordPress 2.8.5
* Moved JavaScript to an external file
* Security - nonce checking on admin screen
* Security - check "manage_options" security setting
* Notes on configuration in readme.txt

= 1.7 =
* 2009-08-27 Dave Ross <dave@csixty4.com>
* Thumbnails in the search results
* Excerpts in the search results

= 1.6 =
* 2009-08-17 Dave Ross <dave@csixty4.com>
* Implemented selectable CSS files
* Fixed a bug that broke live searches containing ' characters

= 1.5 =
* 2009-07-08 Dave Ross  <dave@csixty4.com>
* Fixed compatibility with Search Everything plugin, possibly others

= 1.4 =
* 2009-06-03 Dave Ross  <dave@csixty4.com>
* Renamed release 1.3.1 to 1.4 because WordPress.org doesn't seem to like 1.3.1. Seems like kind of a waste to do a full point release for this
* Building permalinks instead of using post guid (problem with posts imported from another blog)

= 1.3 =
* 2009-05-22  Dave Ross  <dave@csixty4.com>   
* Fixed an annoying bug where the search results div collapsed and expanded again every time an AJAX request completed
* Cancel any existing AJAX requests before sending a new one
* Check for PHP 5.x. Displays an error when you try to activate the plugin on PHP < 5   
* No longer sends the entire WP_Query object to the browser. This was a potential information disclosure issue, plus it was a lot to serialize on the server and parse in the brower
* Minor code cleanup & optimizations
     
= 1.2 =
* 2009-04-10  Dave Ross  <dave@csixty4.com>
* Code cleanup & optimizations 
* Styled the admin screen to fit in with WordPress better 
* New option: display the results above or below the search box 
* Included a note on the admin screen recommending the Google Libraries plugin
	 
= 1.1 =
* 2009-03-30  Dave Ross  <dave@csixty4.com>
* Code cleanup & optimizations
* Fixed compatibility issues with PHP < 5.2.0 and PHP < 5.1.2
* New option: limit the number of results to display
	 
= 1.0 =
* 2009-03-13  Dave Ross  <dave@csixty4.com>
* Initial release

== Upgrade Notice ==

= 2.5 =
This plugin is now compatible with the WPML internationalization plugin.

= 2.0 =
If you use a caching plugin, please clear your cache after upgrading. New: Performance & compatibility improvements. Works with WordPress 3.1! Debug feature for advanced users.
