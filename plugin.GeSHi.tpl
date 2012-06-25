/**
 *	GeSHi Plugin 0.4 for MODx Evolution
 *	by Luca Allulli, April 2006
 *
 *	edited Sergej Savelev, june 2012
 *	modification version 1.0
 *	
 *	Event: OnLoadWebDocument
 *
 *	Based on the GeSHi highlighter at http://qbnz.com/highlighter/
 *
 *	License: GNU GPL
 *
 */
 
//Begin configuration
        global $defaultGeshiLang;
	$defaultGeshiLang="java5";
//End configuration 
 
function replaceCodeBase($lang, $code) {
	global $modx;
	$path = $modx->config["base_path"].'assets/plugins/geshi/geshi/';
	$geshi = new GeSHi($code, $lang, $path);
	$geshi->set_header_type(GESHI_HEADER_PRE);
	$geshi->set_tab_width(4);
	return '<table width="100%"><tr><td>'.$geshi->parse_code().'</td></tr></table>';
}

function replaceCode($matches) {
	global $defaultGeshiLang;
	return replaceCodeBase($defaultGeshiLang, $matches[1]);
}

function replaceCodeLang($matches) {
	return replaceCodeBase($matches[1], $matches[2]);
}


$e = &$modx->Event;


switch ($e->name) {
	case "OnLoadWebDocument":

		include_once($modx->config["base_path"].'assets/plugins/geshi/geshi.php');

		$modx->documentObject['content']=preg_replace_callback("#<pre>(.*?)</pre>#s", "replaceCode", $modx->documentObject['content']);
		$modx->documentObject['content']=preg_replace_callback("#<pre language=\"([^\"]*)\">(.*?)</pre>#s", "replaceCodeLang", $modx->documentObject['content']);
		
		$modx->documentObject['content']=preg_replace('!<pre(.*?)>(.*?)</pre>!ise', " '<pre$1>' . stripslashes( str_replace(array('<br />','[[','&lt;','&gt;','&amp;','&nbsp;'),array('\n','[','<','>','&',' '),'$2') ) . '</pre>' ", $modx->documentObject['content']);
        	$modx->documentObject['content']=preg_replace('!<code(.*?)>(.*?)</code>!ise', " '<pre$1>' . stripslashes( str_replace(array('<br />','[[','&lt;','&gt;','&amp;','&nbsp;'),array('\n','[','<','>','&',' '),'$2') ) . '</pre>' ", $modx->documentObject['content']);
		
		break;
		
	default:	// stop here
		return; 
		break;	
}
