<?php
require __DIR__.'/vendor/autoload.php';

$profilesXml = new SimpleXMLElement(file_get_contents('profiles.xml'));
$solr = $profilesXml->defaultSolrUrl;
$profiles = array();
foreach ($profilesXml->profile as $profileXml) {
	$type = (string) $profileXml->attributes()->type;
	if ($type !== 'solr') {
		break;
	}
	$name = (string) $profileXml->attributes()->name;
	$profile = array(
		'institutions' => array(),
		'filters' => array(),
	);
	if (is_object($profileXml->institutions->institution)) {
		foreach($profileXml->institutions->institution as $institution) {
			$profile['institutions'][] = $institution;
		}
	}
	if (is_object($profileXml->mergedFilters->filter)) {
		foreach($profileXml->mergedFilters->filter as $filter) {
			$profile['mergedFilters'][] = $filter;
		}
	}
	if (is_object($profileXml->filters->filter)) {
		foreach($profileXml->filters->filter as $filter) {
			$profile['filters'][] = $filter;
		}
	}
	$profiles[$name] = $profile;
}

class UrlHelper {

	protected $url;

	public function __construct($url) {
		$this->url = $url;
	}

	public function addParameter($key, $value) {
		$sep = (strpos($this->url, '?') !== false) ? '&' : '?';
		$this->url .= $sep . $key . '=' . urlencode($value);
	}

	public function getUrl() {
		return $this->url;
	}

}

$request = $_SERVER["REQUEST_URI"];
$url = rtrim($solr, '/') . '/select';
error_log('Base url: ' . $url, 4);
$urlHelper = new UrlHelper($url);
foreach ($_GET as $key => $value) {
	$urlHelper->addParameter($key, $value);
}
$profile = $profiles[$_GET['profile']];
$institutions = $profile['institutions'];
if (!empty($profile['institutions'])) {
	$urlHelper->addParameter('fq', "{!parent which='merged_boolean:true'} local_institution_facet_str_mv:(\"" . implode('" OR "', $profile['institutions']) . "\")");
}
if (!empty($profile['mergedFilters'])) {
	foreach ($profile['mergedFilters'] as $filter) {
		$urlHelper->addParameter('fq', "{!parent which='merged_boolean:true'} " . $filter);
	}
}
if (!empty($profile['filters'])) {
	foreach ($profile['filters'] as $filter) {
		$urlHelper->addParameter('fq', $filter);
	}
}
$urlHelper->addParameter('fq', 'merged_boolean:true');
$urlHelper->addParameter('fl', 'id,fullrecord,[child parentFilter=merged_boolean:true]');
$urlHelper->addParameter('wt', 'xml');

$url = $urlHelper->getUrl();

error_log('Query url: ' . $url, 4);
$response = file_get_contents($url);
$xml = new SimpleXMLElement($response);
foreach ($xml->result->doc as $document) {
	$fullrecord = &$document->xpath(".//str[@name='fullrecord']");
	$candidate = null;
	$candidateOrder = PHP_INT_MAX;
	foreach ($document->doc as $nested) {
		$sources = $nested->xpath("./arr[@name='local_institution_facet_str_mv']")[0]->str;
		$index = PHP_INT_MAX;
		foreach ($sources as $source) {
			$key = array_search($source, $institutions);
			if ($key !== FALSE && $key < $candidateOrder) {
				$candidate = &$nested->xpath("./str[@name='fullrecord']");
				$candidateOrder = $key;
			}
		}
	}
	error_log($url, 4);
	$marc = (isset($candidate)) ? $candidate[0][0] : $fullrecord[0][0];
	$marc = str_replace(
		['#29;', '#30;', '#31;'], ["\x1D", "\x1E", "\x1F"], $marc
	);
	$marc = new \File_MARC($marc, \File_MARC::SOURCE_STRING);
	$marc = $marc->next();
	$marc->deleteFields('996');
	$fullrecord[0][0]=$marc->toXML();
	foreach ($document->doc as $doc) {
		unset($document->doc);
	}
}
$reply = $xml->asXML();
header('Content-Type: application/xml; charset=UTF-8');
header('Content-Length: ' . strlen($reply));
echo $reply;
