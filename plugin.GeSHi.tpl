/**
 *  GeSHi Plugin 0.4 for MODx
 *  by Luca Allulli, April 2006
 *
 *  Event: OnLoadWebDocument
 *
 *  Based on the GeSHi highlighter at http://qbnz.com/highlighter/
 *
 *  License: GNU GPL
 *
 */
 
//Begin configuration
    global $defaultGeshiLang;
    $defaultGeshiLang="bash";
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
        $modx->documentObject['content']=preg_replace_callback("#<pre class=\"([^\"]*)\">(.*?)</pre>#s", "replaceCodeLang", $modx->documentObject['content']);
        
        $modx->documentObject['content']=preg_replace_callback("#<code>(.*?)</code>#s", "replaceCode", $modx->documentObject['content']);
        $modx->documentObject['content']=preg_replace_callback("#<code class=\"([^\"]*)\">(.*?)</code>#s", "replaceCodeLang", $modx->documentObject['content']);
        
        $modx->documentObject['content']= preg_replace('!<pre(.*?)>(.*?)</pre>!ise', " '<pre$1>' . stripslashes( str_replace(array(
            '&lt;br /&gt;',
            '[[',
            '&amp;',
            '&nbsp;',
            '<?php',
            '?>'
        ),array(
            '\n',
            '&#091;&#091;',
            '&',
            ' ',
            '&lt;?php',
            '?&gt;'
        ),'$2') ) . '</pre>' ", $modx->documentObject['content']);
        
        $modx->documentObject['content']= preg_replace('!<code(.*?)>(.*?)</code>!ise', " '<pre$1>' . stripslashes( str_replace(array(
            '&lt;br /&gt;',
            '[[',
            '&amp;',
            ' ',
            '<?php',
            '?>'
        ),array(
            '\n',
            '&#091;&#091;',
            '&',
            ' ',
            '&lt;?php',
            '?&gt;'
        ),'$2') ) . '</pre>' ", $modx->documentObject['content']);
        
        break;
        
    default:    // stop here
        return; 
        break;  
}
