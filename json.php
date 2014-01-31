<?
/* This will make the answer into json */
?>

<?php
	$url = $_GET['url'];  /* .php?url=$url */
	$dom = new DOMDocument();
	@$dom->loadHTMLFile($url);
	$xpath = new DOMXPath($dom);

	foreach($xpath->query('//td[2]') as $td){
	  echo json_encode(array($td->nodeValue => 1));
	}
?>