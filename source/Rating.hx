package;

class Rating
{
	public var name:String = '';
	public var image:String = '';
	public var counter:String = '';
	public var hitWindow:Null<Int> = 0; //ms
	public var ratingMod:Float = 1;
	public var score:Int = 350;
	public var noteSplash:Bool = true;

	public function new(name:String)
	{
		this.name = name;
		this.image = name;
		this.counter = name + 's';
		this.hitWindow = Reflect.field(ClientPrefs, name + 'Window');
		if(hitWindow == null)
		{
			hitWindow = 0;
		}
	}

	public static function loadDefault():Array<Rating>
	{
		var ratingsData:Array<Rating> = [new Rating('sick')]; //highest rating goes first

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);
		return ratingsData;
	}

	public function increase(blah:Int = 1)
	{
		Reflect.setField(PlayState.instance, counter, Reflect.field(PlayState.instance, counter) + blah);
	}
}