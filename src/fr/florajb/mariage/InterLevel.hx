package fr.florajb.mariage;
import com.eclecticdesignstudio.motion.Actuate;
import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author jb
 */

class InterLevel extends Sprite {

    public static var totalScore: Int = 0;
    
    public var score (default, setScore): Int;
    public var startMethod: Dynamic -> Void;
	
    private var totalScoreField: TextField;
    private var scoreField: TextField;
    private var soundChannel: SoundChannel;
    private var cookFormat: TextFormat;
    private var titleFormat: TextFormat;
    private var bookSprite: Sprite;
	private var pageIndex: Int = 1;
	private var sortRecipes: Array<Cocktail>;
	private var menu: Sprite;

    public function setScore(score: Int): Int
    {
        this.score = score;
        scoreField.text = "Level: " + score + "pts";
        totalScore += score;
        totalScoreField.text = "Total: " + totalScore + "pts";
        return score;
    }

    private function setMenu(): Void
    {
        menu = new Sprite();
        menu.addChild(new Bitmap(Assets.getBitmapData("img/menu.png")));
        menu.y = height - menu.height;
        menu.x = 260;
		
		var container = new Sprite();
        var title = new TextField();
        title.embedFonts = true;
        title.defaultTextFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 50, TextFormatAlign.CENTER);
        title.text = "Menu";
        title.width = menu.width;
        title.y = 55;
		title.selectable = title.mouseEnabled = false;
        container.addChild(title);

        var newIcon = new Bitmap(Assets.getBitmapData("img/b_newgame.png"));
        var newButton = new SimpleButton(newIcon, newIcon, newIcon, newIcon);
        newButton.x = 140;
        newButton.y = 180;
        newButton.addEventListener(MouseEvent.CLICK, startMethod);
        container.addChild(newButton);

        var instrIcon = new Bitmap(Assets.getBitmapData("img/b_instructions.png"));
        var instrButton = new SimpleButton(instrIcon, instrIcon, instrIcon, instrIcon);
        instrButton.x = newButton.x;
        instrButton.y = newButton.y + 80;
        instrButton.addEventListener(MouseEvent.CLICK, showInstructions);
        container.addChild(instrButton);

        var optionsIcon = new Bitmap(Assets.getBitmapData("img/b_options.png"));
        var optionsButton = new SimpleButton(optionsIcon, optionsIcon, optionsIcon, optionsIcon);
        optionsButton.x = instrButton.x;
        optionsButton.y = instrButton.y + 80;
        optionsButton.addEventListener(MouseEvent.CLICK, showOptions);
        container.addChild(optionsButton);
		menu.addChild(container);
        addChild(menu);
    }
	
	private function showOptions(e: MouseEvent) : Void
	{
		menu.getChildAt(1).visible = false;
		
		var container = new Sprite();
		var title = new TextField();
        title.embedFonts = true;
        title.defaultTextFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 50, TextFormatAlign.CENTER);
        title.text = "Options";
        title.width = menu.width;
        title.y = 55;
		title.selectable = title.mouseEnabled = false;
        container.addChild(title);
		
		var text = new TextField();
		text.embedFonts = true;
		text.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway_cd.ttf").fontName, 35, TextFormatAlign.JUSTIFY);
		text.text = "Son : ";
		text.wordWrap = true;
		text.autoSize = TextFieldAutoSize.CENTER;
		text.selectable = text.mouseEnabled = false;
		text.x = 90;
		text.y = 200;
		container.addChild(text);
		
		var mute = new Sprite();
		mute.addChild(new Bitmap(Assets.getBitmapData("img/mute.png")));
		mute.buttonMode = true;
		mute.x = 300;
		mute.y = 160;
		Actuate.transform (mute, 0.1).color (0xCCCCCC, 1);
		container.addChild(mute);
		var unmute = new Sprite();
		unmute.addChild(new Bitmap(Assets.getBitmapData("img/unmute.png")));
		unmute.buttonMode = true;
		unmute.x = 200;
		unmute.y = 185;
		Actuate.transform (unmute, 0.1).color (0xCCCCCC, 1);
		container.addChild(unmute);
		mute.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) {
			Actuate.transform (mute, 0.1).color (0xFF0000, 1);
			Actuate.transform (unmute, 0.1).color (0xCCCCCC, 1);
			Barman.mute = true;
		});
		unmute.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) {
			Actuate.transform (unmute, 0.1).color (0xFF0000, 1);
			Actuate.transform (mute, 0.1).color (0xCCCCCC, 1);
			Barman.mute = false;
		});
		
		var backIcon = new Bitmap(Assets.getBitmapData("img/b_continue.png"));
		var backButton = new SimpleButton(backIcon, backIcon, backIcon, backIcon);
		backButton.x = menu.width - backButton.width - 25;
        backButton.y = menu.height - backButton.height - 20;
		backButton.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) {
			menu.removeChild(container);
			container = null;
			menu.getChildAt(1).visible = true;
		});
		container.addChild(backButton);
		
		menu.addChild(container);
	}
	
	private function showInstructions(e: MouseEvent) : Void 
	{
		menu.getChildAt(1).visible = false;
		
		var container = new Sprite();
		var title = new TextField();
        title.embedFonts = true;
        title.defaultTextFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 50, TextFormatAlign.CENTER);
        title.text = "Instructions";
        title.width = menu.width;
        title.y = 55;
		title.selectable = title.mouseEnabled = false;
        container.addChild(title);
		
		var text = new TextField();
		text.embedFonts = true;
		text.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway_cd.ttf").fontName, 25, TextFormatAlign.JUSTIFY);
		text.text = "Vous êtes derrière votre bar, un groupe de client arrive...";
		text.text += "\nRéalisez le plus de cockails possible en 90 secondes et engrangez les points.";
		text.text += "\nSi vous avez la mémoire courte, consultez votre livre de cocktails en bas à droite de l'écran.";
		text.wordWrap = true;
		text.autoSize = TextFieldAutoSize.CENTER;
		text.selectable = text.mouseEnabled = false;
		text.width = menu.width -100;
		text.x = 50;
		text.y = 180;
		container.addChild(text);
		
		var backIcon = new Bitmap(Assets.getBitmapData("img/b_continue.png"));
		var backButton = new SimpleButton(backIcon, backIcon, backIcon, backIcon);
		backButton.x = menu.width - backButton.width - 25;
        backButton.y = menu.height - backButton.height - 20;
		backButton.addEventListener(MouseEvent.CLICK, function(e: MouseEvent) {
			menu.removeChild(container);
			container = null;
			menu.getChildAt(1).visible = true;
		});
		container.addChild(backButton);
		
		menu.addChild(container);
	}

    public function new(type: String, startMethod: Dynamic -> Void)
    {
        super();

        addChild(new Bitmap(Assets.getBitmapData("img/menubackground.png")));
        this.startMethod = startMethod;
        cookFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 15);
        titleFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 20, TextFormatAlign.CENTER);

        if(type == "interlevel")
            setInterlevel();
        else if(type == "menu"){
            setMenu();
        }
        else{
            setCookBook();
        }
    }

    public function update(level: Int): Void
    {
		var i = 0;
        while (bookSprite.numChildren > 2) {
			if(Std.is(bookSprite.getChildAt(i), Sprite))
				bookSprite.removeChildAt(i);
			else
				i++;
		}
        bookSprite.addChildAt(upgradeIngredients(level), 1);
        bookSprite.addChildAt(upgradeRecipes(level), 2);
    }

    private function setCookBook(): Void
    {
        displayCookbook();
		
		sortRecipes = new Array<Cocktail>();
		for(recipe in Cookbook.instance.recipes){
			sortRecipes.push(recipe);
		}
		sortRecipes.sort(sort);
		
		displayPage();
		
		addChild(bookSprite);
    }
	
	private function turnPage(e: MouseEvent) : Void 
	{
		pageIndex++;
		displayPage();
	}
	
	private function returnPage(e: MouseEvent) : Void 
	{
		pageIndex--;
		displayPage();
	}
	
	private function displayPage() : Void 
	{
		var i = 0;
        while (bookSprite.numChildren > 2) {
			if(Std.is(bookSprite.getChildAt(i), Sprite))
				bookSprite.removeChildAt(i);
			else
				i++;
		}
		
        var yOffset: Float = 30;
        var xOffset: Float = 50;
		var nbRecipe = 0;
		for (i in (pageIndex-1)*6...cast(Math.min(pageIndex*6, sortRecipes.length), Int)) {
			if (nbRecipe == 3){
				xOffset += bookSprite.width / 2;
				yOffset = 30;
			}
			var rec = displayCocktail(sortRecipes[i]);
			rec.x = xOffset;
            rec.y = yOffset;// + 10;
            yOffset += rec.height+20;
			bookSprite.addChild(rec);
			nbRecipe++;
		}
		
		if(Math.min(pageIndex*6, sortRecipes.length) != sortRecipes.length){
			var cornerBmp = new Bitmap(Assets.getBitmapData("img/book-corner.png"));
			var corner = new Sprite();
			corner.addChild(cornerBmp);
			corner.x = bookSprite.width - corner.width - 18;
			corner.y = 11;
			corner.buttonMode = true;
			corner.addEventListener(MouseEvent.CLICK, turnPage);
		
			bookSprite.addChild(corner);
		}
		if(pageIndex > 1){
			var cornerBmp = new Bitmap(Assets.getBitmapData("img/book-corner.png"));
			cornerBmp.scaleX = -1;
			var corner = new Sprite();
			corner.addChild(cornerBmp);
			corner.x = corner.width + 18;
			corner.y = 11;
			corner.buttonMode = true;
			corner.addEventListener(MouseEvent.CLICK, returnPage);
		
			bookSprite.addChild(corner);
		}		
	}
	
	private function sort(x: Cocktail, y: Cocktail) : Int 
	{
		if (x.name < y.name)
			return -1;
		else
			return 1;
	}

    private function onRemove(e: Event): Void
    {
		if(!Barman.mute)
			soundChannel.stop();
    }

    private function onAdd(e: Event): Void
    {
		if(!Barman.mute){
			var loop = Assets.getSound("sfx/interlevel.mp3");
			soundChannel = loop.play(0, 10);
			var soundTransform = new SoundTransform(0.25);
			soundChannel.soundTransform = soundTransform;
		}
    }

    private function setInterlevel(): Void
    {
        // Score
        var textFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 22, 0x00FF00, true);
        scoreField = new TextField();
        scoreField.embedFonts = true;
        scoreField.defaultTextFormat = textFormat;
        scoreField.selectable = scoreField.mouseEnabled = false;

        totalScoreField = new TextField();
        totalScoreField.embedFonts = true;
        totalScoreField.defaultTextFormat = textFormat;
        totalScoreField.selectable = totalScoreField.mouseEnabled = false;

        setScore(0);
        scoreField.autoSize = TextFieldAutoSize.CENTER;
        scoreField.x = 10;
        scoreField.y = 400;
        addChild(scoreField);

        totalScoreField.autoSize = TextFieldAutoSize.CENTER;
        totalScoreField.x = 10;
        totalScoreField.y = 450;
        addChild(totalScoreField);

        // Upgrades
        displayCookbook();

        update(0);

        addChild(bookSprite);

        addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
        addEventListener(Event.ADDED_TO_STAGE, onAdd);
    }
	
	private function displayCookbook() : Void 
	{
        bookSprite = new Sprite();
        var cookbook = new Bitmap(Assets.getBitmapData("img/open-book.png"));
        bookSprite.x = width - cookbook.width;
        bookSprite.y = height - cookbook.height;
        bookSprite.addChild(cookbook);		

        var continueIcon = new Bitmap(Assets.getBitmapData("img/b_continue.png"));
		var continueButton = new SimpleButton(continueIcon, continueIcon, continueIcon, continueIcon);
        continueButton.x = bookSprite.width - continueButton.width - 25;
        continueButton.y = bookSprite.height - continueButton.height - 20;
        continueButton.addEventListener(MouseEvent.CLICK, startMethod);
        bookSprite.addChild(continueButton);
	}

    private function displayIngredient(name: String): Sprite
    {
        var ingredient = new Sprite();
        var icon = new Bitmap(Assets.getBitmapData("img/" + name + ".png"));
        if(name != "menthe" && name != "citron" && name != "coco")
            icon.scaleX = icon.scaleY = 70 / icon.height;
        var tf = new TextField();
        tf.embedFonts = true;
        tf.defaultTextFormat = cookFormat;
        tf.text = setTitleCase(name);
        tf.x = icon.width + 20;
        tf.selectable = tf.mouseEnabled = false;
        ingredient.addChild(icon);
        ingredient.addChild(tf);

        return ingredient;
    }

    private function displayCocktail(cocktail: Cocktail): Sprite
    {
        var cocktailSprite = new Sprite();
        var icon = new Bitmap(cocktail.icon);
        var tf = new TextField();
        tf.embedFonts = true;
        tf.defaultTextFormat = cookFormat;
        var reg: EReg = ~/\n/g;
        tf.text = reg.replace(cocktail.name, "");
		if(Lambda.count(cocktail.recipe) < 5){
			for(ing in cocktail.recipe)
				tf.text += "\n   - " + setTitleCase(ing);
		}
		else{
			var array = new Array<String>();
			for (ing in cocktail.recipe)
				array.push(ing);
			for(i in 0...4){
				tf.text += "\n   - " + setTitleCase(array[i]) + (array.length > (i + 4) ? "  - " + setTitleCase(array[i + 4]):"");
			}
		}
        tf.x = icon.width + 20;
        tf.width = tf.textWidth + 10;
        tf.selectable = tf.mouseEnabled = false;
        cocktailSprite.addChild(icon);
        cocktailSprite.addChild(tf);

        return cocktailSprite;
    }

    private function setTitleCase(name: String): String
    {
        return name.charAt(0).toUpperCase() + name.substr(1);
    }

    private function upgradeRecipes(level: Int): Sprite
    {
        var sprite = new Sprite();
        var newRecipes = LevelManager.getNewRecipes(level);
        if(Lambda.count(newRecipes) == 0)
            return sprite;

        var recipes = new TextField();
        recipes.embedFonts = true;
        recipes.defaultTextFormat = titleFormat;
        recipes.text = Lambda.count(newRecipes) > 1 ? "Nouveaux cocktails" : "Nouveau cocktail";
        recipes.width = bookSprite.width / 2;
        recipes.x = bookSprite.width / 2;
        recipes.y = 65;
        recipes.selectable = recipes.mouseEnabled = false;
        sprite.addChild(recipes);

        var yOffset: Float = 120;
        var xOffset: Float = 50 + bookSprite.width / 2;
        for(recipe in newRecipes){
            var rec = displayCocktail(recipe);
            rec.x = xOffset;
            rec.y = yOffset + 5;
            yOffset += rec.height;
            sprite.addChild(rec);
        }
        return sprite;
    }

    private function upgradeIngredients(level: Int): Sprite
    {
        var sprite = new Sprite();
        var newIngredients = LevelManager.getNewIngredients(level);

        if(Lambda.count(newIngredients) > 0){
            var ingredients = new TextField();
            ingredients.embedFonts = true;
            ingredients.defaultTextFormat = titleFormat;
            ingredients.text = Lambda.count(newIngredients) > 1 ? "Nouveaux Ingredients" : "Nouvel Ingredient";
            ingredients.width = bookSprite.width / 2 ;
            ingredients.y = 65;
            ingredients.selectable = ingredients.mouseEnabled = false;
            sprite.addChild(ingredients);

            var yOffset: Float = 120;
            var xOffset: Float = 70;
            for(ingredient in newIngredients){
                var ing = displayIngredient(ingredient);
                ing.x = xOffset;
                ing.y = yOffset + 15;
                yOffset += ing.height;
                sprite.addChild(ing);
            }
        }
        return sprite;
    }

}