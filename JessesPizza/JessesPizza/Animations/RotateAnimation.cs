using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace JessesPizza.Animations
{
    class RotateAnimation : TriggerAction<Label>
    {
        public AnimationAction Action { get; set; }
        public enum AnimationAction
        { Start, Stop }
        protected override async void Invoke(Label sender)
        {
            if (sender != null)
            {
                if (Action == AnimationAction.Start)
                    await SelectedAnimation(sender);
                else if (Action == AnimationAction.Stop)
                    await DeSelectedAnimation(sender);
            }
        }
        private async Task SelectedAnimation(Label myElement)
        {
            uint timeout = 500;

            await myElement.RotateTo(90, timeout);
        }
        private async Task DeSelectedAnimation(Label myElement)
        {
            uint timeout = 500;
            await myElement.RotateTo(0, timeout);

        }
    }
}
