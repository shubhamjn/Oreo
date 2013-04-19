package com.citrusengine.objects.persistance
{
	public class FinishData
	{
		public function FinishData()
		{
			_itemSet = new Vector.<FinishDataItem>();
			currentFuel = 0;
			maxFuel = 0;
			levelCrossed = 0;
			currentScore = 0;
			highScore = 0;
			otherScore = 0;
			time = 0;
			blackStars = 0;
			jetPackLeft = 0;
		}
		private var _itemSet:Vector.<FinishDataItem> = null;
		private var _currentFuel:uint = 0;
		private var _maxFuel:uint = 0;
		private var _levelCrossed:uint = 0;
		private var _currentScore:uint = 0;
		private var _highScore:uint = 0;
		private var _otherScore:uint = 0;
		private var _time:uint = 0;
		private var _blackStars:uint = 0;
		private var _jetPackLeft:uint = 0;
		
		public function addItem(item:FinishDataItem):void
		{
			_itemSet.push(item);
		}

		public function get itemSet():Vector.<FinishDataItem>
		{
			return _itemSet;
		}

		public function get blackStars():uint
		{
			return _blackStars;
		}

		public function set blackStars(value:uint):void
		{
			_blackStars = value;
		}

		public function get jetPackLeft():uint
		{
			return _jetPackLeft;
		}

		public function set jetPackLeft(value:uint):void
		{
			_jetPackLeft = value;
		}

		public function get time():uint
		{
			return _time;
		}

		public function set time(value:uint):void
		{
			_time = value;
		}

		public function get otherScore():uint
		{
			return _otherScore;
		}

		public function set otherScore(value:uint):void
		{
			_otherScore = value;
		}

		public function get highScore():uint
		{
			return _highScore;
		}

		public function set highScore(value:uint):void
		{
			_highScore = value;
		}

		public function get currentScore():uint
		{
			return _currentScore;
		}

		public function set currentScore(value:uint):void
		{
			_currentScore = value;
		}

		public function get levelCrossed():uint
		{
			return _levelCrossed;
		}

		public function set levelCrossed(value:uint):void
		{
			_levelCrossed = value;
		}

		public function get maxFuel():uint
		{
			return _maxFuel;
		}

		public function set maxFuel(value:uint):void
		{
			_maxFuel = value;
		}

		public function get currentFuel():uint
		{
			return _currentFuel;
		}

		public function set currentFuel(value:uint):void
		{
			_currentFuel = value;
		}


	}
	
}
