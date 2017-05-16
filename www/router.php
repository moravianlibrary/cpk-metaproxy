<?php
require __DIR__.'/vendor/autoload.php';

$profilesXml = new SimpleXMLElement(file_get_contents('profiles.xml'));
$solr = $profilesXml->url;
$profiles = array();
foreach ($profilesXml->profile as $profileXml) {
	$name = (string) $profileXml->attributes()->name;
	$profile = array(
		'institutions' => array(),
		'filters' => array(),
	);
	foreach($profileXml->institutions->institution as $institution) {
		$profile['institutions'][] = $institution;
	}
	foreach($profileXml->filters->filter as $filter) {
		$profile['filters'][] = $filter;
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

$solr = 'http://frontie.cpk-infra.mzk.cz:8983';
$request = $_SERVER["REQUEST_URI"];
$url = $solr . $request;
error_log('url: ' . $url, 4);
$urlHelper = new UrlHelper($url);
$profile = $profiles[$_GET['profile']];
$institutions = $profile['institutions'];
$urlHelper->addParameter('fq', "{!parent which='merged_boolean:true'} local_institution_facet_str_mv:(\"" . implode('" OR "', $profile['institutions']) . "\")");
$urlHelper->addParameter('fq', 'merged_boolean:true');
$urlHelper->addParameter('fl', 'id,fullrecord,[child parentFilter=merged_boolean:true]');

$url = $urlHelper->getUrl();

error_log($url, 4);
$response = file_get_contents($url);
$xml = new SimpleXMLElement($response);
foreach ($xml->result->doc as $document) {
	$fullrecord = &$document->xpath("//str[@name='fullrecord']");
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
	$fullrecord[0][0]=$marc->next()->toXML();
	unset($document->doc);
}
$reply = $xml->asXML();
header('Content-Type: application/xml; charset=UTF-8');
header('Content-Length: ' . strlen($reply));
echo $reply;
