<?php
 return array (
  'class' => 'CDbConnection',
  'connectionString' => 'mysql:host=db;port=3306;dbname=db_yupe',
  'username' => 'yupe',
  'password' => '123',
  'emulatePrepare' => true,
  'charset' => 'utf8',
  'enableParamLogging' => defined('YII_DEBUG') && YII_DEBUG ? true : 0,
  'enableProfiling' => defined('YII_DEBUG') && YII_DEBUG ? true : 0,
  'schemaCachingDuration' => 108000,
  'tablePrefix' => 'yupe_',
  'pdoClass' => 'yupe\\extensions\\NestedPDO',
);
