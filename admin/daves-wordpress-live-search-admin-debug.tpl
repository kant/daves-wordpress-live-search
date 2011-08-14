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
<a href="<?php echo $_SERVER['REQUEST_URI']."&tab=advanced"; ?>" class="nav-tab"><?php _e("Advanced", 'dwls'); ?></a>
<?php if($enableDebugger) : ?><a href="<?php echo $_SERVER['REQUEST_URI']."&tab=debug"; ?>" class="nav-tab nav-tab-active"><?php _e("Debug", 'dwls'); ?></a><?php endif; ?>
</h2>

<!-- Debugger Body -->
<div style="width: 500px; height: 800px;overflow-y:auto;border: 1px dotted #aaa;margin: 10px 0;padding: 1em;"><?php echo $debug_output; ?></div>

<!-- Note -->

<p><?php printf(__("Do you find this plugin useful? Consider a donation to %sCat Guardians%s, a wonderful no-kill shelter where I volunteer.", 'dwls'), '<a href="http://catguardians.org">', '</a>'); ?></p>
</div>