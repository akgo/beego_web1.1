<?php

$aa = array(
	'bbb' => 3,
	'ccc' =>4,
);

$aa = array(
	'bbb'=>$aa['bbb'] + 1,
	'ccc'=>$aa['bbb']+1,
);

print_r($aa);
exit;
