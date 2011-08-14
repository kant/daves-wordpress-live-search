<?php

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

/**
 * Special wrapper around the WP transients API
 */
class DWLSTransients {
	static function clear() {
		$a = 255;
		while($a > -1) {
			$prefix = dechex($a);
			$index = get_transient("dwls_index_{$prefix}");
			if($index) {
				foreach($index as $hash=>$value) {
					delete_transient("dwls_result_{$hash}");
				}
				delete_transient("dwls_index_{$prefix}");
			}
			$a -= 1;
		}
	}
	
	static function set($key, $value, $expiration) {
		$hash = md5($key);
		$prefix = substr($hash, 0, 2);
		$index = get_transient("dwls_index_{$prefix}");
		if(!$index) {
			$index = array();
		}
		if(!array_key_exists($hash, $index)) {
			$index[$hash] = $hash;
			set_transient("dwls_index_{$prefix}", $index);
		}
		set_transient("dwls_result_{$hash}", $value);
	}
	
	static function get($key) {
		$hash = md5($key);
		$prefix = substr($hash, 0, 2);
		$index = get_transient("dwls_index_{$prefix}");
		if(!$index) {
			$index = array();
		}
		if(array_key_exists($hash, $index)) {
			return get_transient("dwls_result_{$hash}");	
		}
		
		return FALSE;
	}
	
	static function indexes() {
		$all_indexes = array();
		
		$a = 255;
		while($a > -1) {
			$prefix = dechex($a);
			$index = get_transient("dwls_index_{$prefix}");
			if($index) {
				$all_indexes[] = "dwls_index_{$prefix}";
			}
			$a -= 1;
		}
		return array_reverse($all_indexes);
	}
}
