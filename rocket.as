package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;

	public class rocket extends MovieClip {

		const gravity: Number = 0.5; //gravity of the game
		const dist_btw_obstacles: Number = 300; //distance between two obstacles
		const ob_speed: Number = 4; //speed of the obstacle
		const jump_force: Number = 6; //force with which it jumps

		var player: Player = new Player();
		var lastob: Obstacle = new Obstacle(); //store the last obstacle in the obstacle array
		var obstacles: Array = new Array(); //store all the obstacles
		var yspeed: Number = 0; //speed of rocket
		var score: Number = 0;
		var letters: Array = new Array("a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","q","w","e","r","t","y","u","i","o","p");
		var myRandomNumber: Number = Math.floor(Math.random() * 26);

		public function rocket() {

			init();
			//random_txt.text = generateRandomString(4);

		}

		public function init(): void {


			player = new Player();
			lastob = new Obstacle();
			obstacles = new Array();
			yspeed = 0;
			score = 0;

			//add player to center of the stage
			player.x = stage.stageWidth / 2;
			player.y = stage.stageHeight / 2;
			addChild(player);
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			help_btn.addEventListener(MouseEvent.CLICK, fl_ClickToGoToNextFrame);

			createObstacle();
			createObstacle();
			createObstacle();
			random_txt.text = letters[myRandomNumber];
		}

		public function key_up(event: KeyboardEvent): void {
			help_btn.visible = false;
			var str: String = random_txt.text;
			if (event.charCode == str.charCodeAt(0)) {
				checking();
			}
		}

		//generateRandomString();

		public function checking(): void {
			yspeed = -jump_force;
		}

		public function restart(): void {

			if (contains(player)) {

				removeChild(player);
			}

			for (var i: int = 0; i < obstacles.length; ++i) {

				if (contains(obstacles[i]) && obstacles[i] != null) {
					removeChild(obstacles[i]);
				}
				obstacles[i] = null;

			}
			help_btn.visible = true;
			obstacles.slice(0);
			init();
			myRandomNumber= Math.floor(Math.random() * 26);
		}

		//go to frame1
		public function fl_ClickToGoToPreviousFrame(event: MouseEvent): void {

			prevFrame();
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			help_btn.addEventListener(MouseEvent.CLICK, fl_ClickToGoToNextFrame);
			restart();
			//updateObstacle(i);
			//changeObstacle(ob);
			createObstacle()
			random_txt.visible = true;
			player.visible = true;
		}


		//go to frame2 (how to play)
		public function fl_ClickToGoToNextFrame(event: MouseEvent): void {
			nextFrame();
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			play_btn.addEventListener(MouseEvent.CLICK, fl_ClickToGoToPreviousFrame);
			createObstacle()
			random_txt.visible = false;
			player.visible = false;
		}

		public function onEnterFrameHandler(event: Event) {

			//update player
			yspeed += gravity;
			player.y += yspeed;

			//restart if the player touches the ground
			if (player.y + player.height / 2 > stage.stageHeight) {
				restart();
			}

			//don't allow the rocket to go above the screen
			if (player.y - player.height / 2 < 0) {
				player.y = player.height / 2;
			}

			//update obstacles
			for (var i: int = 0; i < obstacles.length; ++i) {
				updateObstacle(i);
			}

			//display the score
			scoretxt.text = String(score);

		}

		public function updateObstacle(i: int) {
			var ob: Obstacle = obstacles[i];

			if (ob == null) {
				return;
			}
			ob.x -= ob_speed;

			if (ob.x < -ob.width) {

				changeObstacle(ob);

			}

			//If the rocket hits an obstacle then restart the game
			if (ob.hitTestPoint(player.x + player.width / 2, player.y + player.height / 2, true) || ob.hitTestPoint(player.x + player.width / 2, player.y - player.height / 2, true) || ob.hitTestPoint(player.x - player.width / 2, player.y + player.height / 2, true) || ob.hitTestPoint(player.x - player.width / 2, player.y - player.height / 2, true)) {

				restart();

			}

			//If the rocket got through the obstacle without hitting it then increase the score
			if ((player.x - player.width / 2 > ob.x + ob.width / 2) && !ob.covered) {
				myRandomNumber = Math.floor(Math.random() * 26);
				random_txt.text = letters[myRandomNumber];
				++score;
				ob.covered = true;
			}
		}

		public function changeObstacle(ob: Obstacle) {

			//var ob:Obstacle = new Obstacle();
			ob.x = lastob.x + dist_btw_obstacles;
			ob.y = 100 + Math.random() * (stage.stageHeight - 200);
			lastob = ob;
			ob.covered = false;
		}

		public function createObstacle() {

			var ob: Obstacle = new Obstacle();
			if (lastob.x == 0) {
				ob.x = 800;
			} else {
				ob.x = lastob.x + dist_btw_obstacles;
			}
			ob.y = 100 + Math.random() * (stage.stageHeight - 200);
			addChild(ob);
			obstacles.push(ob);
			lastob = ob;
		}

	}
}