use strict;
use warnings;
 
use 5.008;
 
use ExtUtils::MakeMaker;
WriteMakefile
(
  NAME         => 'Math-Calc',
  VERSION_FROM => 'lib/Math/Calc.pm',
  BUILD_REQUIRES => {
			'Test::More' => '0.47'
		    },
);
