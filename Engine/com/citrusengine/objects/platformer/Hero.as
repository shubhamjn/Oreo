package com.citrusengine.objects.platformer
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2Fixture;
	
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.persistance.Persistance;
	import com.citrusengine.objects.persistance.PersistanceType;
	import com.citrusengine.physics.CollisionCategories;
	
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.media.Video;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import org.osflash.signals.Signal;
	
	/**
	 * This is a common, simple, yet solid implementation of a side-scrolling Hero. 
	 * The hero can run, jump, die, and kill enemies. It dispatches signals
	 * when significant events happen. The game state's logic should listen for those signals
	 * to perform game state updates (such as increment coin collections).
	 * 
	 * Don't store data on the hero object that you will need between two or more levels (such
	 * as current coin count). The hero should be re-created each time a state is created or reset.
	 */	
	public class Hero extends PhysicsObject
	{
		//properties
		
		/**
		 * This is the fastest speed that the hero can move left or right. 
		 */		
		public var maxVelocity:Number = 10/2;
				
		//events
		
		/**
		 * Dispatched whenever the hero's animation changes. 
		 */		
		public var onAnimationChange:Signal;
		
		public static var jetEnabled:Boolean = true;
		
		protected var _groundContacts:Array = [];//Used to determine if he's on ground or not.
		protected var _enemyClass:Class = Baddy;
		protected var _onGround:Boolean = false;
		protected var _friction:Number = .03;
		protected var _playerMovingHero:Boolean = false;
		
		protected var _forceSideways:V2;
		protected var _forceUpwards:V2;
		protected var _forceUpwardsInitial:V2;
		
		public static function Make(name:String, x:Number, y:Number, width:Number, height:Number, view:* = null):Hero
		{
			if (view == null) view = MovieClip;
			return new Hero(name, { x: x, y: y, width: width, height: height, view: view } );
		}
		
		/**
		 * Creates a new hero object.
		 */		
		public function Hero(name:String, params:Object = null)
		{
			this.persistance = new Persistance(this , PersistanceType.kPositionSaved);
			super(name, params);
			_forceUpwards = new V2(0,this._body.m_mass * 14 );
			_forceUpwardsInitial = new V2(0,this._body.m_mass * 25 );
			_forceSideways = new V2(this._body.m_mass * 9 ,0);
			onAnimationChange = new Signal();
		}
		
		override public function destroy():void
		{
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_fixture.removeEventListener(ContactEvent.END_CONTACT, handleEndContact);
			
			onAnimationChange.removeAll()
			super.destroy();
		}
		
		/**
		 * Whether or not the player can move and jump with the hero. 
		 */	
		public function get controlsEnabled():Boolean
		{
			return jetEnabled;
		}
		
		public function set controlsEnabled(value:Boolean):void
		{
			jetEnabled = value;
			
			
		}
		
		/**
		 * Returns true if the hero is on the ground and can jump. 
		 */		
		public function get onGround():Boolean
		{
			return _onGround;
		}
		
		/**
		 * The Hero uses the enemyClass parameter to know who he can kill (and who can kill him).
		 * Use this setter to to pass in which base class the hero's enemy should be, in String form
		 * or Object notation.
		 * For example, if you want to set the "Baddy" class as your hero's enemy, pass
		 * "com.citrusengine.objects.platformer.Baddy", or Baddy (with no quotes). Only String
		 * form will work when creating objects via a level editor.
		 */		
		public function set enemyClass(value:*):void
		{
			if (value is String)
				_enemyClass = getDefinitionByName(value as String) as Class;
			else if (value is Class)
				_enemyClass = value;
		}
		
		/**
		 * This is the amount of friction that the hero will have. Its value is multiplied against the
		 * friction value of other physics objects.
		 */	
		public function get friction():Number
		{
			return _friction;
		}
		
		public function set friction(value:Number):void
		{
			_friction = value;
			
			if (_fixture)
			{
				_fixture.SetFriction(_friction);
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			
			var velocity:V2 = _body.GetLinearVelocity();
			
			var moveKeyPressed:Boolean = false;
			
			if (_ce.input.isDown(Keyboard.RIGHT))
			{
				if(velocity.x<10)
				{
					_body.ApplyForce(_forceSideways,new V2(0,0));
					
				}					
				moveKeyPressed = true;
			}
			
			if (_ce.input.isDown(Keyboard.LEFT))
			{
				if(velocity.x>-10)
				{
					_body.ApplyForce(new V2(-_forceSideways.x,_forceSideways.y),new V2(0,0));
				}
				
				moveKeyPressed = true;
			}
			
			//If player just started moving the hero this tick.
			if (moveKeyPressed && !_playerMovingHero)
			{
				_playerMovingHero = true;
				//_fixture.SetFriction(0); //Take away friction so he can accelerate.
			}
			//Player just stopped moving the hero this tick.
			else if (!moveKeyPressed && _playerMovingHero)
			{
				_playerMovingHero = false;
				_fixture.SetFriction(_friction); //Add friction so that he stops running
			}
			if (_ce.input.justPressed(Keyboard.UP) && Fuel.currentFuel>0&&_onGround && jetEnabled)
			{
				body.ApplyForce(_forceUpwardsInitial,new V2(0,0));
			}
			else if (_ce.input.isDown(Keyboard.UP) && Fuel.currentFuel>0 && jetEnabled)
			{
				//trace(" time taken=",Fuel.currentFuel);
				Fuel.currentFuel-=timeDelta;
				if(velocity.y<-20)
					_body.ApplyForce(_forceUpwards,new V2(0,0));
				else
					_body.ApplyForce(new V2(0,-_forceUpwards.y),new V2(0,0));
				
			}
			else if (_ce.input.justPressed(74))//j
			{
				if (!jetEnabled && Score.sparePacks > 0 )
				{
				Score.sparePacks--;
				jetEnabled=true;
				}
			}
			//Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;		
				//update physics with new velocity
				_body.SetLinearVelocity(velocity);
			updateAnimation();
		}	
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
			_bodyDef.linearDamping = 0.8;
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = _friction;
			_fixtureDef.restitution = .2;
			_fixtureDef.filter.categoryBits = CollisionCategories.Get("GoodGuys");
			_fixtureDef.filter.maskBits = CollisionCategories.GetAll();
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.m_reportEndContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			_fixture.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}
		
		public static function die():void
		{
			Score.life = Score.life - 1;
			if(Score.life > 0)
				Oreo.getInstance().level = Oreo.getInstance().level;
			else
			{
				Oreo.getInstance().level = 1;
				Score.life = 3;
				Score.addBlackStar();
			}
				
		}
		
		protected function handleBeginContact(e:ContactEvent):void
		{
			var colliderBody:b2Body = e.other.GetBody();
			
			if (_enemyClass && colliderBody.GetUserData() is _enemyClass)
			{
				
			}
			
			
			//Collision angle
			if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
			{
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle > 45 && collisionAngle < 135)
				{
					SoundManager.getInstance().stopSoundByCategory(SoundManager.HERO_EFFECTS);
					SoundManager.getInstance().playSound("heroBounce",1,1);
					_groundContacts.push(e.other);
					_onGround = true;
				}
			}
		}
		
		protected function handleEndContact(e:ContactEvent):void
		{
			//Remove from ground contacts, if it is one.
			var index:int = _groundContacts.indexOf(e.other);
			if (index != -1)
			{
				_groundContacts.splice(index, 1);
				if (_groundContacts.length == 0)
					_onGround = false;
			}
		}
		
		
		protected function updateAnimation():void
		{
			var prevAnimation:String = _animation;
			
			var velocity:V2 = _body.GetLinearVelocity();
			if (!_onGround&&_ce.input.isDown(Keyboard.RIGHT))
			{
				_inverted = false;
			}
			else if (!_onGround&&_ce.input.isDown(Keyboard.LEFT))
			{
				_inverted = true;
			}
			/*else if (!_onGround&&!_ce.input.isDown(Keyboard.UP))
			{
				_animation = "idle";
			}
			else if (_ce.input.isDown(Keyboard.UP))
			{
				_animation = "flying";//not yet made
			}*/
			_animation = "walk";
			if (_ce.input.isDown(Keyboard.LEFT)&&_onGround)
			{
				_inverted = true;
				_animation = "Default";
			}
			
			else if (_ce.input.isDown(Keyboard.RIGHT)&&_onGround)
			{
				_inverted = false;
				_animation = "walk";
			}
			/*else
			{
				_animation = "idle";
			}*/
			
			
			if (prevAnimation != _animation)
			{
				onAnimationChange.dispatch();
			}
		}
	}
}