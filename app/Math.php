<?php
namespace Application\NativeElements;

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