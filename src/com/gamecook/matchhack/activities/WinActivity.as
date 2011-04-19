/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.gamecook.matchhack.activities
{
    import com.gamecook.matchhack.factories.CharacterFactory;
    import com.gamecook.matchhack.factories.TextFieldFactory;
    import com.gamecook.matchhack.sounds.MHSoundClasses;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     *
     * Shown when the player wins and is ready to move onto the next level.
     *
     */
    public class WinActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/you_win.png")]
        private var YouWinImage:Class;

        [Embed(source="../../../../../build/assets/click_to_continue.png")]
        private var ContinueImage:Class;

        private var scoreTF:TextField;
        private var bonusTF:TextField;

        public function WinActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            //TODO need to update player stats and save out state.
            var youWin:Bitmap = addChild(Bitmap(new YouWinImage())) as Bitmap;
            youWin.x = (fullSizeWidth * .5) - (youWin.width * .5);
            youWin.y = logo.y + logo.height + 30;

            var character:Bitmap = addChild(CharacterFactory.createPlayerBitmap()) as Bitmap;
            character.x = (fullSizeWidth - character.width) * .5;
            character.y = youWin.y + youWin.height + 15;

            bonusTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, formatBonusText(), 160)) as TextField;
            bonusTF.x = (fullSizeWidth - bonusTF.width) * .5;
            bonusTF.y = character.y + character.height + 10;

            scoreTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, TextFieldFactory.SCORE_LABEL+TextFieldFactory.padScore(), 160)) as TextField;
            scoreTF.x = (fullSizeWidth - scoreTF.width) * .5;
            scoreTF.y = bonusTF.y + bonusTF.height + 10;

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

            var continueLabel:Bitmap = addChild(Bitmap(new ContinueImage())) as Bitmap;
            continueLabel.x = (fullSizeWidth - continueLabel.width) * .5;
            continueLabel.y = fullSizeHeight - (continueLabel.height + 10);

        }

        private function formatBonusText():String
        {
            var message:String = "SUCCESS BONUS\n" +
                                 "Life: +"+activeState.playerLife+"\n" +
                                 "Turns: "+activeState.levelTurns+"\n" +
                                 "Level: x"+activeState.playerLevel;

            return message;
        }

        private function onClick(event:MouseEvent):void
        {
            soundManager.destroySounds(true);
            soundManager.play(MHSoundClasses.WalkStairsSound);
            nextActivity(GameActivity);
        }
    }
}
