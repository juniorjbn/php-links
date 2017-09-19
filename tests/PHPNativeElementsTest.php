<?php

use PHPUnit_Framework_TestCase as PHPUnit;

class Math
{

	public function sum( $firstValue, $secondValue )
	{
		return $firstValue + $secondValue;
	}

	public function substract( $firstValue, $secondValue )
	{
		return $firstValue - $secondValue;
	}
	
	public function divide( $firstValue, $secondValue )
	{
		return $firstValue / $secondValue;
	}
	
	public function multiplicate( $firstValue, $secondValue )
	{
		return $firstValue * $secondValue;
	}	
}

class PHPNativeElementsTest extends PHPUnit
{

	protected $math;

	public function setup()
	{
		$this->math = new Math;
	}

	public function testOperacaoMatematica()
	{
		$this->assertEquals(3, $this->math->sum(1,2), 'Não somou corretamente');
		$this->assertEquals(1, $this->math->substract(2,1), 'Não subtraiu corretamente');
		$this->assertEquals(3, $this->math->divide(9,3), 'Não dividiu corretamente');
		$this->assertEquals(4, $this->math->multiplicate(2,2), 'Não multiplicou corretamente');
	}

	public function tearDown()
	{

		/**/
	}

}