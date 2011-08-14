<style type="text/css">
/* Used on the built-in themes page to provide the line under the tabs */
.settings_page_daves-wordpress-live-search-DavesWordPressLiveSearch .wrap h2 {
border-bottom: 1px solid #ccc;
padding-bottom: 0px;
}
</style>

<div class="wrap">
<h2><?php _e("Dave's WordPress Live Search Options", 'dwls'); ?></h2>
<h2>
<a href="<?php echo $_SERVER['REQUEST_URI']."&tab=settings"; ?>" class="nav-tab nav-tab-active"><?php _e("Settings", 'dwls'); ?></a>
<a href="<?php echo $_SERVER['REQUEST_URI']."&tab=advanced"; ?>" class="nav-tab"><?php _e("Advanced", 'dwls'); ?></a>
<?php if($enableDebugger) : ?><a href="<?php echo $_SERVER['REQUEST_URI']."&tab=debug"; ?>" class="nav-tab"><?php _e("Debug", 'dwls'); ?></a><?php endif; ?>
</h2>
<form method="post" action="">
<input type="hidden" name="tab" value="<?php echo $_REQUEST['tab']; ?>" />

<?php
if ( function_exists('wp_nonce_field') )
	wp_nonce_field('daves-wordpress-live-search-config');
?>

<table class="form-table"><tbody>

<!-- Maximum results -->
<tr valign="top">
<th scope="row"><?php _e("Maximum Results to Display", 'dwls'); ?></th>

<td><input type="text" name="daves-wordpress-live-search_max_results" id="daves-wordpress-live-search_max_results" value="<?php echo $maxResults; ?>" class="regular-text code" /><span class="setting-description"><?php _e("Enter &quot;0&quot; to display all matching results", 'dwls'); ?></span></td>
</tr>

<tr valign="top">
<th scope="row"><?php _e("Minimum characters before searching", 'dwls'); ?></th>

<td>
<select name="daves-wordpress-live-search_minchars">
<option value="1" <?php if($minCharsToSearch == 1) echo 'selected="selected"'; ?>><?php _e("Search right away", 'dwls'); ?></option>
<option value="2" <?php if($minCharsToSearch == 2) echo 'selected="selected"'; ?>><?php _e("Wait for two characters", 'dwls'); ?></option>
<option value="3" <?php if($minCharsToSearch == 3) echo 'selected="selected"'; ?>><?php _e("Wait for three characters", 'dwls'); ?></option>
<option value="4" <?php if($minCharsToSearch == 4) echo 'selected="selected"'; ?>><?php _e("Wait for four characters", 'dwls'); ?></option>
</select>
</td>
</tr>


<tr valign="top">
<th scope="row"><?php _e("Results Direction", 'dwls'); ?></th>

<td><input type="radio" name="daves-wordpress-live-search_results_direction" id="daves-wordpress-live-search_results_direction_down" value="down" <?php if($resultsDirection == 'down'): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_results_direction_down"><?php _e("Down", 'dwls'); ?></input></label>

<input type="radio" name="daves-wordpress-live-search_results_direction" id="daves-wordpress-live-search_results_direction_up" value="up" <?php if($resultsDirection == 'up'): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_results_direction_up"><?php _e("Up", 'dwls'); ?></label><br /><span class="setting-description"><?php _e("When search results are displayed, in which direction should the results box extend from the search box?", 'dwls'); ?></span></td>
</tr>

<!-- Display post meta -->
<tr valign="top">
<th scope="row"><?php _e("Display Metadata", 'dwls'); ?></th>

<td>
    <input type="hidden" name="daves-wordpress-live-search_display_post_meta" value="" />
    <input type="checkbox" name="daves-wordpress-live-search_display_post_meta" id="daves-wordpress-live-search_display_post_meta" value="true" <?php if($displayPostMeta): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_display_post_meta"><?php _e("Display author & date for every search result", 'dwls'); ?></label>
</td> 
</tr>

<!-- Display post thumbnail -->
<tr valign="top">
<th scope="row"><?php _e("Display Post Thumbnail", 'dwls'); ?></th>

<td>
    <input type="hidden" name="daves-wordpress-live-search_thumbs" value="" />
    <input type="checkbox" name="daves-wordpress-live-search_thumbs" id="daves-wordpress-live-search_thumbs" value="true" <?php if($showThumbs): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_thumbs"><?php _e("Display thumbnail images for every search result with at least one image", 'dwls'); ?></label>
</td> 
</tr>

<!-- Display post excerpt -->
<tr valign="top">
<th scope="row"><?php _e("Display Post Excerpt", 'dwls'); ?></th>

<td>
    <input type="hidden" name="daves-wordpress-live-search_excerpt" value="" />
    <input type="checkbox" name="daves-wordpress-live-search_excerpt" id="daves-wordpress-live-search_excerpt" value="true" <?php if($showExcerpt): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_excerpt"><?php printf(__("Display an excerpt for every search result. If the post doesn't have one, use the first %s characters.", 'dwls'), "<input type=\"text\" name=\"daves-wordpress-live-search_excerpt_length\" id=\"daves-wordpress-live-search_excerpt_length\" value=\"$excerptLength\" size=\"3\" />"); ?></label>
</td> 
</tr>

<!-- Display 'more results' -->
<tr valign="top">
<th scope="row"><?php _e("Display &quot;View more results&quot; link", 'dwls'); ?></th>

<td>
    <input type="hidden" name="daves-wordpress-live-search_more_results" value="" />
    <input type="checkbox" name="daves-wordpress-live-search_more_results" id="daves-wordpress-live-search_more_results" value="true" <?php if($showMoreResultsLink): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_more_results"><?php _e("Display the &quot;View more results&quot; link after the search results.", 'dwls'); ?></label>
</td> 
</tr>

<!-- CSS styles -->
<tr valign="top">
<td colspan="2"><h3><?php _e("Styles", 'dwls'); ?></h3></td>
</tr>

<tr valign="top">
<th scope="row"> </th>
<td>

<input type="radio" name="daves-wordpress-live-search_css" id="daves-wordpress-live-search_css_default_gray" value="default_gray" <?php if('default_gray' == $css): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_css_default_gray"><?php _e("Default Gray", 'dwls'); ?></label><br /><span class="setting-description"><?php _e("Default style in gray.", 'dwls'); ?></span>
<br /><br />
<input type="radio" name="daves-wordpress-live-search_css" id="daves-wordpress-live-search_css_default_red" value="default_red" <?php if('default_red' == $css): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_css_default_red"><?php _e("Default Red", 'dwls'); ?></label><br /><span class="setting-description"><?php _e("Default style in red", 'dwls'); ?></span>
<br /><br />
<input type="radio" name="daves-wordpress-live-search_css" id="daves-wordpress-live-search_css_default_blue" value="default_blue" <?php if('default_blue' == $css): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_css_default_blue"><?php _e("Default Blue", 'dwls'); ?></label><br /><span class="setting-description"><?php _e("Default style in blue", 'dwls'); ?></span>
<br /><br />
<input type="radio" name="daves-wordpress-live-search_css" id="daves-wordpress-live-search_css_theme" value="theme" <?php if('theme' == $css): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_css_theme"><?php _e("Theme-specific", 'dwls'); ?></label><br /><span class="setting-description"><strong><?php _e("For advanced users", 'dwls'); ?>:</strong> <?php _e("Theme must include a CSS file named daves-wordpress-live-search.css. If your theme does not have one, copy daves-wordpress-live-search_default_gray.css from this plugin's directory into your theme's directory and modify as desired.", 'dwls'); ?></span>
<br /><br />
<input type="radio" name="daves-wordpress-live-search_css" id="daves-wordpress-live-search_css_existing_theme" value="notheme" <?php if('notheme' == $css): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_css_theme"><?php _e("Theme-specific (theme's own CSS file)", 'dwls'); ?></label><br /><span class="setting-description"><strong><?php _e("For advanced users", 'dwls'); ?>:</strong> <?php _e("Use the styles contained within your Theme's stylesheet. Don't include a separate stylesheet for Live Search.", 'dwls'); ?>
</td> 
</tr>

<!-- WP E-Commerce -->
<?php if(defined('WPSC_VERSION')) : ?>
<tr valign="top">
<td colspan="2"><h3><?php _e("WP E-Commerce", 'dwls'); ?></h3></td>
</tr>

<tr valign="top">
<th scope="row"> </th>
<td>
    <div><span class="setting-description"><?php printf(__("When used with the %sWP E-Commerce%s plugin, Dave&apos;s WordPress Live Search can search your product catalog instead of posts & pages.", 'dwls'), '<a href="http://getshopped.org/">', '</a>'); ?></span></div>
    <table>
        <tr><td><input type="radio" id="daves-wordpress-live-search_source_1" name="daves-wordpress-live-search_source" value="0" <?php if(0 == $searchSource) : ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_source_1"><?php _e("Search posts &amp; pages", 'dwls'); ?></label></td></tr>
        <tr><td><input type="radio" id="daves-wordpress-live-search_source_2" name="daves-wordpress-live-search_source" value="1" <?php if(1 == $searchSource) : ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_source_2"><?php _e("Search products", 'dwls'); ?></label></td></tr>
    </table>

</td>
</tr>
<?php else : ?>
<input type="hidden" name="daves-wordpress-live-search_source" value="0" />
<?php endif; ?>

<!-- Submit buttons -->
<tr valign="top">
<?php $saveButtonText = __("Save Changes", 'dwls'); ?>
<td colspan="2"><div style="border-top: 1px solid #333;margin-top: 15px;padding: 5px;"><input type="submit" name="daves-wordpress-live-search_submit" id="daves-wordpress-live-search_submit" value="<?php echo $saveButtonText; ?>" /></div></td>
</tr>

</tbody></table>

</form>

<!-- Note -->

<p><?php printf(__("Do you find this plugin useful? Consider a donation to %sCat Guardians%s, a wonderful no-kill shelter where I volunteer.", 'dwls'), '<a href="http://catguardians.org">', '</a>'); ?></p>
</div>