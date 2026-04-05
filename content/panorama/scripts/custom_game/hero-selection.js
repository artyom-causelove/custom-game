const dotaRoot = getDotaRoot();

// Remove default selection UI
dotaRoot.FindChildTraverse('BottomPanelsContainer').style.visibility = 'collapse';
dotaRoot.FindChildTraverse('MainContents').style.visibility = 'collapse';

const root = $.GetContextPanel();

let selectedHero = 'none';

// Add 'onclick' listeners on hero cards
const heroItems = root.FindChildrenWithClassTraverse('hero-item');
heroItems.forEach(it => it.SetPanelEvent('onactivate', () => {
  selectedHero = it.GetAttributeString('hero', 'none');
}));

const [button] = root.FindChildrenWithClassTraverse('hero-selection-button');
button.SetPanelEvent('onactivate', () => {
  if (selectedHero === 'none') return;

  GameEvents.SendCustomGameEventToServer('custom_player_pick_hero', {
    playerId: Players.GetLocalPlayer(),
    heroname: selectedHero
  });
});

const [wrapper] = root.FindChildrenWithClassTraverse('hero-selection-wrapper');
wrapper.style.opacity = '1';
