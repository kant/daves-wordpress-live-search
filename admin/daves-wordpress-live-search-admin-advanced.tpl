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
<a href="<?php echo $_SERVER['REQUEST_URI']."&tab=settings"; ?>" class="nav-tab"><?php _e("Settings", 'dwls'); ?></a>
<a href="<?php echo $_SERVER['REQUEST_URI']."&tab=advanced"; ?>" class="nav-tab nav-tab-active"><?php _e("Advanced", 'dwls'); ?></a>
<?php if($enableDebugger) : ?><a href="<?php echo $_SERVER['REQUEST_URI']."&tab=debug"; ?>" class="nav-tab"><?php _e("Debug", 'dwls'); ?></a><?php endif; ?>
</h2>
<form method="post" action="">
<input type="hidden" name="tab" value="<?php echo $_REQUEST['tab']; ?>" />

<?php
if ( function_exists('wp_nonce_field') )
	wp_nonce_field('daves-wordpress-live-search-config');
?>

<table class="form-table"><tbody>

<tr valign="top">
<th scope="row"><?php _e("Exceptions", 'dwls'); ?></th>

<td>
<?php $permalinkFormat = get_option('permalink_structure'); ?>

<div><span class="setting-description"><?php printf(__("Enter the %s of pages which should not have live searching, one per line. The * wildcard can be used at the start or end of a line. For example: %s", 'dwls'), empty($permalinkFormat) ? __('paths', 'dwls') : __('permalinks'), '<ul style="list-style-type:disc;margin-left: 3em;">' . empty($permalinkFormat) ? '<li>?page_id=123</li><li>page_id=1*</li>' : '<li>about</li><li>employee-*</li>' . '</ul>'); ?>

<p><strong><?php _e("NOTE", 'dwls'); ?>:</strong> <?php _e("These pages will still be returned in search results. This only disables the Live Search feature for the search box on these pages.", 'dwls'); ?></p></span></div>
<textarea name="daves-wordpress-live-search_exceptions" id="daves-wordpress-live-search_exceptions" rows="5" cols="60"><?php echo $exceptions; ?></textarea></td> 
</tr>

<!-- X Offset -->
<tr valign="top">
<th scope="row"><?php _e("Search Results box X offset", 'dwls'); ?></th>

<td>
<div><span class="setting-description"><?php _e("Use this setting to move the search results box left or right to align exactly with your theme's search field. Value is in pixels. Negative values move the box to the left, positive values move it to the right.", 'dwls'); ?></span></div>

<input type="text" name="daves-wordpress-live-search_xoffset" id="daves-wordpress-live-search_xoffset" value="<?php echo $xOffset; ?>"</td> 
</tr>

<!-- Cache lifetime -->
<tr valign="top">
<th scope="row"><?php _e("Cache Lifetime", 'dwls'); ?></th>

<td><input type="text" name="daves-wordpress-live-search_cache_lifetime" id="daves-wordpress-live-search_cache_lifetime" value="<?php echo $cacheLifetime; ?>" class="regular-text code" /><span class="setting-description"><?php _e("Enter &quot;0&quot; to disable caching", 'dwls'); ?></span></td>
</tr>

<!-- Enable debugger -->
<tr valign="top">
<th scope="row"><?php _e("Enable debugger", 'dwls'); ?></th>

<td><input type="checkbox" name="daves-wordpress-live-search_debug" id="daves-wordpress-live-search_debug" value="true" <?php if($enableDebugger): ?>checked="checked"<?php endif; ?> /><label for="daves-wordpress-live-search_debug"><?php _e("Enable the Debug tab.", 'dwls'); ?></label></td> 
</tr>

<!-- Clear Cache -->
<tr valign="top">
<th scope="row"><?php _e("Clear Cache", 'dwls'); ?></th>

<td><button type="submit" name="daves-wordpress-live-search_submit" id="daves-wordpress-live-search_submit_cache" value="Clear Cache"><?php _e("Clear Cache", 'dwls'); ?></button>&nbsp;<label for="daves-wordpress-live-search_submit"><?php _e("If you change settings or post/edit content, your cache will be cleared automatically. Use this button to clear the cache manually if needed.", 'dwls'); ?></label></td> 
</tr>

<!-- Submit buttons -->
<tr valign="top">
<td colspan="2"><div style="border-top: 1px solid #333;margin-top: 15px;padding: 5px;"><input type="submit" name="daves-wordpress-live-search_submit" id="daves-wordpress-live-search_submit" value="<?php _e("Save Changes", 'dwls'); ?>" /></div></td>
</tr>

</tbody></table>

</form>

<!-- Note -->

<p><?php printf(__("Do you find this plugin useful? Consider a donation to %sCat Guardians%s, a wonderful no-kill shelter where I volunteer.", 'dwls'), '<a href="http://catguardians.org">', '</a>'); ?></p>
</div>