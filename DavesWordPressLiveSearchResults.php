<?php

include "DWLSTransients.php";

/**
 * Value object class
 */
class DavesWordPressLiveSearchResults {

	// Search sources
	const SEARCH_CONTENT = 0;
	const SEARCH_WPCOMMERCE = 1;
        
	public $searchTerms;
	public $results;
	public $displayPostMeta;
	
	/**
	 * @param int $source search source constant
	 * @param string $searchTerms
	 * @param boolean $displayPostMeta Show author & date for each post. Defaults to TRUE to keep original bahavior from before I added this flag
	 */
	function DavesWordPressLiveSearchResults($source, $searchTerms, $displayPostMeta = true, $maxResults = -1) {
		
		$this->results = array();

                switch($source) {
                    case self::SEARCH_CONTENT:
                        $this->populate($searchTerms, $displayPostMeta, $maxResults);
                        break;
                    case self::SEARCH_WPCOMMERCE:
                        $this->populateFromWPCommerce($searchTerms, $displayPostMeta, $maxResults);
                        break;
                    default:
                        // Unrecognized
                }
		$this->displayPostMeta = $displayPostMeta;
	}
	
	private function populate($wpQueryResults, $displayPostMeta, $maxResults) {
		
		global $wp_locale;
		global $wp_query;
		
		$dateFormat = get_option('date_format');
		
		// Some other plugin threw a fit once if I didn't instantiate
		// WP_Query once to initialize everything and then call it
		// for real. Might have been "Search Everything". I think there's
		// a comment about it in an old version of DWLS.
		$wp_query = $wpQueryResults = new WP_Query();
        $wp_query = $wpQueryResults = new WP_Query();
                     
		if(function_exists(relevanssi_do_query)) {
			// Relevanssi isn't treating 0 as "unlimited" results
			// like WordPress's native search does. So we'll replace
			// $maxResults with a really big number, the biggest one
			// PHP knows how to represent, if $maxResults == -1
			// (unlimited)
			if(-1 == $maxResults) {
				$maxResults = PHP_INT_MAX;
			}
		}
	
        $wpQueryResults->query(array(
          's' => $_GET['s'],
          'showposts' => $maxResults,
          'post_type' => 'any',
          'post_status' => 'publish',
        ));
        
        $this->searchTerms = $wpQueryResults->query_vars['s'];
        
        $wpQueryResults = apply_filters('dwls_alter_results', $wpQueryResults, $maxResults);
		
		foreach($wpQueryResults->posts as $result)
		//foreach($posts as $result)
		{
			// Add author names & permalinks
			if($displayPostMeta)
				$result->post_author_nicename = $this->authorName($result->post_author);
				
			$result->permalink = get_permalink($result->ID);
			
			if(function_exists('get_post_image_id')) {
				// Support for WP 2.9 post thumbnails
				$postImageID = get_post_image_id($result->ID);
				$postImageData = wp_get_attachment_image_src($postImageID, apply_filters('post_image_size', 'thumbnail'));
				 $result->attachment_thumbnail = $postImageData[0];
			}
			else {
				// If not post thumbnail, grab the first image from the post
				$result->attachment_thumbnail = $this->firstImageThumb($result->ID);
			}

			$result->post_excerpt = $this->excerpt($result);
			
			$result->post_date = date_i18n($dateFormat, strtotime($result->post_date));
			
			// We don't want to send all this content to the browser
			unset($result->post_content);

			// xLocalization
			$result->post_title = apply_filters("localization", $result->post_title); 
			
            $result->show_more = true;
			
			$this->results[] = $result;	
		}
	}

        private function populateFromWPCommerce($wpQueryResults, $displayPostMeta, $maxResults) {
            global $wpdb;

            $this->searchTerms = $_GET['s'];

			$tagQuery = "SELECT * FROM `{$wpdb->terms}` WHERE slug LIKE '%{$this->searchTerms}%'";
			$tagresults = $wpdb->get_results($tagQuery);

			$metaQuery = "SELECT * FROM ".WPSC_TABLE_PRODUCTMETA." WHERE meta_value LIKE '%".$this->searchTerms."%'";
			$metaresults = $wpdb->get_results($metaQuery);

			if($tagresults){
				  $term_id = $tagresults[0]->term_id;
				  
				  $tagresults = $wpdb->get_results("SELECT * FROM `{$wpdb->term_taxonomy}` WHERE term_id = '".$term_id."' AND taxonomy='product_tag'");
				  $taxonomy_id = $tagresults[0]->term_taxonomy_id;	
				  
				  $tagresults = $wpdb->get_results("SELECT * FROM `{$wpdb->term_relationships}` WHERE term_taxonomy_id = '".$taxonomy_id."'");
				  
				  foreach ($tagresults as $result) {
					$product_ids[] = $result->object_id; 
				  }
				  
					$product_id = implode(",",$product_ids);
					$sql = "SELECT list.id,list.name,list.description, list.price,image.image,list.special,list.special_price
							FROM ".WPSC_TABLE_PRODUCT_LIST." AS list
							LEFT JOIN ".WPSC_TABLE_PRODUCT_IMAGES." AS image
			        		ON list.image=image.id
							WHERE list.id IN (".$product_id.") 
							AND list.publish=1
							AND list.active=1"; 
							
				$wp_query = new WP_Query();
				
				$wp_query->query(array('tag_slug__and' => $_GET['s'], 'showposts' => $maxResults));
							
			}
			elseif($metaresults){
				  foreach($metaresults as $result){
						   $mprod_id = $result->product_id;
					  }
					  
					 $sql = "SELECT list.id,list.name,list.description,list.price,image.image,list.special,list.special_price
							FROM ".WPSC_TABLE_PRODUCT_LIST." AS list
							LEFT JOIN ".WPSC_TABLE_PRODUCT_IMAGES." AS image
			        		ON list.image=image.id
							WHERE list.id IN (".$mprod_id.") OR (list.name LIKE '%".$this->searchTerms."%' OR list.description LIKE '%".$this->searchTerms."%')
							AND list.publish=1
							AND list.active=1";  
					
				$wp_query = new WP_Query();
				
				$wp_query->query(array('s' => $_GET['s'], 'showposts' => $maxResults));
							
			}
			else {
				  $sql="SELECT list.id,list.name,list.description,list.price,image.image,list.special,list.special_price
			        FROM ".WPSC_TABLE_PRODUCT_LIST." AS list
			        LEFT JOIN ".WPSC_TABLE_PRODUCT_IMAGES." AS image
			        ON list.image=image.id
			        WHERE (list.name LIKE '%".$this->searchTerms."%' OR list.description LIKE '%".$this->searchTerms."%')
			        AND list.publish=1
			        AND list.active=1
			       ";
				   
				$wp_query = new WP_Query();
				
				$wp_query->query(array('s' => $_GET['s'], 'showposts' => $maxResults));
				    
			}
				  
			$results = $wpdb->get_results($sql, OBJECT);

            foreach($results as $result) {
                $resultObj = new stdClass();
                $resultObj->permalink = wpsc_product_url($result->id);
                $resultObj->post_title = apply_filters("localization", $result->name); 
                $resultObj->post_content = $result->description;
                $resultObj->post_excerpt = $result->description;
                $resultObj->post_excerpt = $this->excerpt($resultObj);
                
                $resultObj->post_price = $result->price;
                $resultObj->show_more = false;

                if(!empty($result->image)) {
                    $resultObj->attachment_thumbnail = WPSC_THUMBNAIL_URL.$result->image;
                }

                // Fields that don't really apply here
                //$resultObj->post_date =
                //$resultObj->post_author_nicename =
                
                $this->results[] = $resultObj;
            }

        }

	private function excerpt($result) {
		
		static $excerptLength = null;
		// Only grab this value once
		if(null == $excerptLength) {
			$excerptLength = intval(get_option('daves-wordpress-live-search_excerpt_length'));
		}
		// Default value
		if(0 == $excerptLength) {
			$excerptLength = 100;
		}
		
		if (empty($result->post_excerpt)) {
			 $content = apply_filters("localization", $result->post_content);
			 $excerpt = explode(" ",strrev(substr(strip_tags($content), 0, $excerptLength)),2);
			 $excerpt = strrev($excerpt[1]);
			 $excerpt .= " [...]";
		}
		else {
			$excerpt = apply_filters("localization", $result->post_excerpt);
		}
		
		return $excerpt;
	}
	
	/**
	 * @return string
	 */
	private function authorName($authorID) {
		static $authorCache = array();
		
		if(array_key_exists($authorID, $authorCache))
		{
			$authorName = $authorCache[$authorID];
		}
		else
		{
			$authorData = get_userdata($authorID);
			$authorName = $authorData->display_name;
			$authorCache[$authorID] = $authorName;
		}
		
		return $authorName;
	}

	/**
	 * @see http://wphackr.com/get-images-attached-to-post/
	 */	
	function firstImageThumb($postID) {
	
		// Get images for this post
		$arrImages =& get_children('post_type=attachment&post_mime_type=image&post_parent=' . $postID );
		
		// If images exist for this page
		if($arrImages) {
		
			// Get array keys representing attached image numbers
			$arrKeys = array_keys($arrImages);
			
			/******BEGIN BUBBLE SORT BY MENU ORDER************/
			// Put all image objects into new array with standard numeric keys (new array only needed while we sort the keys)
			foreach($arrImages as $oImage) {
			$arrNewImages[] = $oImage;
			}
			
			// Bubble sort image object array by menu_order TODO: Turn this into std "sort-by" function in functions.php
			for($i = 0; $i < sizeof($arrNewImages) - 1; $i++) {
				for($j = 0; $j < sizeof($arrNewImages) - 1; $j++) {
					if((int)$arrNewImages[$j]->menu_order > (int)$arrNewImages[$j + 1]->menu_order) {
						$oTemp = $arrNewImages[$j];
						$arrNewImages[$j] = $arrNewImages[$j + 1];
						$arrNewImages[$j + 1] = $oTemp;
					}
				}
			}
			 
			// Reset arrKeys array
			$arrKeys = array();
			 
			// Replace arrKeys with newly sorted object ids
			foreach($arrNewImages as $oNewImage) {
				$arrKeys[] = $oNewImage->ID;
			}
			
			/******END BUBBLE SORT BY MENU ORDER**************/
			
			// Get the first image attachment
			$iNum = $arrKeys[0];
			
			// Get the thumbnail url for the attachment
			$sThumbUrl = wp_get_attachment_thumb_url($iNum);
			
			return $sThumbUrl;
		}
	}
	
	public function ajaxSearch() {
		$maxResults = intval(get_option('daves-wordpress-live-search_max_results'));
		if($maxResults === 0) $maxResults = -1;
		
		$cacheLifetime = intval(get_option('daves-wordpress-live-search_cache_lifetime'));
		if(!is_user_logged_in() && 0 < $cacheLifetime) {
			$doCache = TRUE;
		}
		else {
			$doCache = FALSE;
		}
		
		if($doCache) {
			$cachedResults = DWLSTransients::get($_REQUEST['s']);
		}
		
		if((!$doCache) || (FALSE === $cachedResults)) {
		
			// Initialize the $wp global object
			// See class WP in classes.php
			// The Relevanssi plugin is using this instead of
			// the global $wp_query object
			$wp =& new WP();
			$wp->init();  // Sets up current user.
			$wp->parse_request();
		
			$displayPostMeta = (bool)get_option('daves-wordpress-live-search_display_post_meta');
			if(array_key_exists('search_source', $_REQUEST)) {
				$searchSource = $_GET['search_source'];
			}
			else {
		    	$searchSource = intval(get_option('daves-wordpress-live-search_source'));
			}
		
			$results = new DavesWordPressLiveSearchResults($searchSource, $searchTerms, $displayPostMeta, $maxResults);
		
			if($doCache) {
				DWLSTransients::set($_REQUEST['s'], $results, $cacheLifetime);
			}
		}
		else {
			// Found it in the cache. Return the results.
			$results = $cachedResults;
		}
		
		$json = json_encode($results);
	
		// If we don't output the text we want outputted here and
		// then die(), the wp_ajax code will die(0) or die(-1) after
		// this function returns and that value will get echoed out
		// to the browser, resulting in a JSON parsing error.
		die($json);
	}	
}

// Set up the AJAX hooks
add_action("wp_ajax_dwls_search", array("DavesWordPressLiveSearchResults", "ajaxSearch"));
add_action("wp_ajax_nopriv_dwls_search", array("DavesWordPressLiveSearchResults", "ajaxSearch"));